#set document(
  title: "Simulación de desalojo de edificios",
  author: ("César Moreno Cabello", "Jose Luis Parrilla Fuentes"),
)
#set page(paper: "a4", margin: 2.5cm, numbering: "1")
#set text(lang: "es", size: 12pt)
#set par(justify: true, leading: 0.65em)
#set heading(numbering: "1.1")
// Separación alrededor de figuras (imágenes y diagramas)
#show figure: set block(above: 1em, below: 2.2em)
// Separación entre el cuerpo de la figura y su pie
#show figure: set figure.caption(separator: [. ])
#set figure(gap: 1em)
// Pies de figura: tipografía con serifa y más pequeña
#show figure.caption: set text(font: "Liberation Serif", size: 10pt)
// Separación entre elementos de la lista
#set list(spacing: 1em)
// Separación de las tablas con el texto
#show table: set block(above: 1.2em, below: 1.2em)
#show heading: set block(above: 2.2em, below: 1em)

// ---------- Portada ----------
#let verde = rgb("#006B3F")
#let gris = rgb("#555555")

#page(numbering: none, margin: (x: 2.5cm, y: 2.5cm))[
  #set par(justify: false)
  // Banda superior
  #place(top + left, dx: -2.5cm, dy: -2.5cm, rect(width: 100% + 5cm, height: 1.2cm, fill: verde))

  #v(1.5cm)
  #align(center)[
    #image("resources/UJA_logo.png", width: 50%)
    #v(-3.5em)
    #text(size: 15pt, fill: gris, top-edge: "bounds")[Simulación]
  ]

  #v(1fr)

  #align(center)[
    #line(length: 40%, stroke: 1.5pt + verde)
    #v(0.8em)
    #text(size: 30pt, weight: "bold")[Simulación de desalojo \ de edificios]
    #v(0.6em)
    #text(size: 14pt, fill: gris, style: "italic")[Documentación técnica del proyecto]
    #v(0.8em)
    #line(length: 40%, stroke: 1.5pt + verde)
  ]

  #v(1fr)

  #align(center)[
    #text(size: 11pt, weight: "bold", fill: verde, tracking: 0.1em)[AUTORES]
    #v(0.8em)
    #grid(
      columns: (1fr, 1fr),
      column-gutter: 1cm,
      align: center,
      [
        #text(size: 13pt, weight: "bold")[César Moreno Cabello] \
        #text(size: 10pt, fill: gris)[cmc00150\@red.ujaen.es]
      ],
      [
        #text(size: 13pt, weight: "bold")[Jose Luis Parrilla Fuentes] \
        #text(size: 10pt, fill: gris)[jlpf0006\@red.ujaen.es]
      ],
    )
    #v(0.6em)
  ]

  #v(1.5cm)

  #align(center)[
    #text(size: 10pt, fill: gris)[
      Repositorio: \
      #link("https://github.com/ParriCode/simulacion_desalojo_edificios/tree/desarrollo")[
        #text(fill: verde)[github.com/ParriCode/simulacion_desalojo_edificios]
      ] \
      #datetime.today().display("[day]/[month]/[year]")
    ]
  ]

  #place(bottom + left, dx: -2.5cm, dy: 2.5cm, rect(width: 100% + 5cm, height: 0.6cm, fill: verde))
]

#counter(page).update(1)

#outline(title: "Índice", indent: auto)
#pagebreak()

= Parte I: Modelo
== Introducción a la propuesta
Nuestro objetivo es simular un escenario donde un edificio ha de ser desalojado debido a una emergencia. Intentando ser lo más fiel a la realidad posible.

Para lograr esto nos basamos en información de varios estudios:
- @kuligowski2015stairs Investigadores (el NIST, en EE. UU.) que grabaron con cámaras simulacros de evacuación en edificios de distintas alturas, hasta 62 plantas, 14 edificios. Midieron cuánto tardaba cada persona en empezar a bajar por la escalera, a qué velocidad bajaba y cuántas personas había a la vez en cada tramo. @kuligowski2015stairs[Resumen ejecutivo, Tabla 4, sec. 4.1.5, 4.3 y 4.4].
- @kuligowski2010incendio Análisis de una evacuación de un incendio real en 2008 en un edificio de oficinas de 32 plantas con unas 4.400 personas. Usaron cuestionarios anónimos en papel. Se devolvieron más de 670 y analizaron una muestra de 375 @kuligowski2010incendio[p. 5 y 6]. La espera hasta empezar a bajar fue de 10,4 minutos de media (de 1 a 45 min) @kuligowski2010incendio[Tabla 1, p. 6].
- @averill2005ocupantes Son diapositivas de una conferencia sobre el 11-S (no sobre el atentado de 1993). Se basan en 225 entrevistas en persona, 803 telefónicas y 6 grupos de discusión, sobre unos 15.400 supervivientes @averill2005ocupantes[diap. «Collection of First Person Accounts» y «Building Population»].
- @sagun2013salidas Estudio sobre qué salida elige la gente al evacuar. Observaron simulacros en tres oficinas abiertas (41, 97 y 86 participantes) con vídeo, contadores y cuestionarios @sagun2013salidas[sec. 3.2.1]. La puerta principal concentró el 92 %, 51 % y 70 % de los evacuados @sagun2013salidas[sec. 4.1.4 y Figura 7]. Con simulaciones en EXODUS, que todos usen la puerta principal alarga la evacuación en torno a un 20 % @sagun2013salidas[sec. 4.3 y Tabla 4].

== Decisiones y consideraciones
=== Suposiciones
#enum(numbering: "a)", spacing: 1.5em,
  [*COMPORTAMIENTO EN GRUPO*: No vamos a modelar un sistema de físicas, en su lugar usaremos los datos que nos da el documento @kuligowski2015stairs[sec. 5.4 y Apéndice E] para simular la distribución de agrupamiento en una puerta.

  Se vio que las personas no salen por las escaleras de forma uniforme, sino que lo hacen en rachas donde hay más cantidad saliendo a la vez y otros donde casi no hay nadie; debido a que se influencian entre sí. @kuligowski2015stairs[sec. 5.4.2]],
  [*CHOQUES Y ADELANTAMIENTO*: Aunque el estudio midió el agrupamiento, no tuvo en cuenta choques y adelantamientos que puedan alterar este flujo de salida @kuligowski2015stairs[sec. 2.2.5 y 6.5], por lo que en este modelo tampoco se tendrá en cuenta.],
  [*INDIVIDUALIDAD*: Características como la edad, el peso y el cansancio aunque el documento aporta cierta información @kuligowski2015stairs[Resumen ejecutivo], no son características que sean imprescindibles para el tiempo final.

  Así como tampoco vamos a tener en cuenta factores de personalidad (personas ayudando a otra) y efectos personales encima.],
  [*Características de la escalera*: No vamos a modelar la forma de la escalera ya que en el propio estudio no se observó un efecto significativo del ancho o altura entre escalones sobre los resultados. @kuligowski2015stairs[Resumen ejecutivo y sec. 6.4].],
  [*CAMINO DESDE LAS HABITACIONES HASTA LAS ESCALERAS*: Aunque este ámbito no se haya tenido en cuenta directamente en el estudio @kuligowski2015stairs[Resumen ejecutivo], podemos ayudarnos de cierta información proporcionada para tomar decisiones realistas:
    - Consideramos que cada planta tiene la misma cantidad de personas (simulando una oficina).
    - A mayor densidad de gente por metro cuadrado la velocidad se reduce @kuligowski2015stairs[sec. 5.6.1].
    - El tamaño de las plantas y el número de habitaciones vendrá dado por el usuario final, pero las rutas que siguen las personas en el modelo serán en linea recta, por lo que el tiempo vendrá dado por esa linea hacia la salida.
    - La probabilidad de que una entidad elija la puerta conocida (en nuestro caso lo simplificaremos a la principal) antes que la de emergencia es del 70% (extraído del documento @sagun2013salidas[sec. 4.1.4 y Figura 7] @kuligowski2010incendio[p. 9, «Evacuation trends on stairs»]).
    - La salida principal se comporta de la misma forma que la salida de emergencia pero se le añade una penalización de en el orden de un 20% más (media sacada de @sagun2013salidas[sec. 4.3 y Tabla 4]).
    - Cada persona tarda un tiempo en reaccionar, según el estudio de WTC del 11S @averill2005ocupantes[diap. «WTC 1», tabla «Activities Before Evacuation»] la distribución era la siguiente: 70 % habló con otros, 46 % cogió sus cosas, 30 % ayudó a otros, 23 % buscó a alguien, 16 % llamó por teléfono, 6 % apagó el ordenador @kuligowski2010incendio[Metodología, p. 7 y Apéndice A, pregunta 6, p. 22] @kuligowski2010incendio[Tabla 2, p. 13]. Según este mismo estudio, el tiempo medido desde el impacto por  tipo de tarea fue: Sin *ninguna tarea previa*	1,8 min hasta ponerse en marcha, *una tarea de acción* (coger cosas, avisar a otros)	2,9 min, *dos tareas de acción*	4,0 min, el coste estimado por tarea de acción	≈ 0,97 min (unos 58 s) @galea2012wtc[sec. «Response times», p. 513].

      *En resumen* (TL;DR), como hemos dicho que omitimos la interacción por grupos nos quedamos con que cada persona al sonar una alarma tiene un: *46% de coger sus cosas, 16% de llamar a alguien y 6% de apagar el ordenador. Son acciones no excluyentes y cada acción suma 58s de _delay_*.]
)

=== Sucesos, eventos y flujo de datos
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

Se ha elegido un enfoque *orientado a procesos*: se describe el recorrido de una persona cualquiera por el edificio, y después se traduce a sucesos (tabla de sucesos de esta sección) para poder implementarlo tanto en Simio como en un lenguaje orientado a eventos.

*Descripción verbal de las acciones del sistema.* El sistema es un edificio de oficinas de $N_f$ plantas con $N_p$ personas por planta, con dos salidas: la *principal* (conocida por todos) y la de *emergencia*. Cada una tiene su escalera y su puerta a la calle.

+ En $t = 0$ suena la alarma. Todas las personas están en su puesto, en una posición aleatoria de su planta.
+ Cada persona realiza antes de moverse hasta 3 acciones previas (coger sus cosas, llamar por teléfono, apagar el ordenador). Su retardo es un valor base más un coste fijo por cada acción realizada.
+ Terminado el retardo, elige salida: la principal con probabilidad 0,7 y la de emergencia con 0,3.
+ Camina en línea recta hasta la entrada de la escalera de la salida elegida. Su velocidad baja si hay mucha densidad de gente en la planta.
+ Baja las escaleras hasta la planta baja a la velocidad observada en los simulacros. No se modelan choques ni adelantamientos.
+ Llega a la puerta de su salida. Si está ocupada se pone en la cola de esa puerta (FIFO). La puerta deja salir a las personas en rachas, siguiendo un proceso de Hawkes @kuligowski2015stairs[sec. 5.4 y Apéndice E]; la principal añade una penalización del 20 %.
+ Al cruzar la puerta, la persona abandona el sistema y se anota su tiempo de salida.

La simulación termina cuando ha salido el 95 % de las personas (ver condición de finalización en la descripción del modelo).

*Tabla de sucesos.* Hay cinco tipos de sucesos. Los planificados ocurren en un instante calculado de antemano; los condicionales dependen del estado del sistema.

#figure(
  table(
    columns: (auto, auto, 1fr, 2fr),
    inset: 5pt,
    align: left + horizon,
    table.header([*Suceso*], [*Tipo*], [*Condición de activación*], [*Acciones (datos que lee y escribe)*]),
    [Inicio de la simulación], [Planificado], [Reloj $= 0$.],
    [Crea las $N_f dot N_p$ personas. Para cada una sortea y escribe en sus atributos: planta, posición, $K$ y retardo $R_i$. Pone a cero contadores y colas, y deja vacía la historia de salidas de cada puerta. Programa un Fin de reacción en $R_i$ para cada persona.],
    [Fin de reacción], [Planificado], [Reloj $= R_i$ de la persona $i$.],
    [Sortea la salida (lee $p_"princ"$), calcula la distancia en línea recta $d_i$ (lee posición) y la velocidad en planta (lee la densidad actual $D$ de su planta). Escribe salida elegida, $v_i$ y el tiempo de bajada de escalera. Programa la Llegada a la puerta.],
    [Llegada a la puerta], [Planificado], [Reloj $= R_i + d_i / v_i + t_"esc,i"$.],
    [Escribe el instante de llegada $t_"ll,i"$. Si la puerta está libre y la cola vacía, activa Salida; si no, añade a $i$ al final de la cola y actualiza el máximo de cola.],
    [Salida por la puerta], [Condicional], [Cola no vacía y puerta libre, y reloj $>=$ instante de la siguiente salida de Hawkes.],
    [Saca a la primera persona de la cola. Escribe $t_"sal,i"$ y calcula su espera en cola. Suma 1 a los evacuados y al contador de esa puerta. Añade el instante a la historia de la puerta (que "excita" la intensidad) y calcula la siguiente salida con el procedimiento _Siguiente-salida_.],
    [Fin de la simulación], [Condicional], [Evacuados $>= ceil("0,95" dot N)$ (con $N = N_f dot N_p$).],
    [Guarda $T_95$ (instante de esa salida), los acumuladores y las estadísticas de la réplica. Detiene la réplica.],
  ),
  caption: [Sucesos del modelo, con su condición de activación y las acciones que ejecutan.],
) <tab-sucesos>

*Salidas de Hawkes (rachas en la puerta).* Cada puerta guarda la historia $H$ de sus instantes de salida $t_j$ y su intensidad es
$ lambda(t) = mu + sum_(t_j < t) alpha e^(-beta (t - t_j)) $
donde $mu$ es la intensidad de fondo, $alpha$ la fuerza con que una salida "arrastra" a las siguientes y $beta$ lo rápido que se disipa ese efecto @kuligowski2015stairs[sec. 5.4.2 y Apéndice E]. El siguiente instante de salida se genera por _thinning_ de Ogata:

```
PROCEDIMIENTO Siguiente-salida(t0, puerta p)
INICIO
  t <- t0
  REPETIR
    lmax <- mu + SUMA_{tj en H_p} alfa * exp(-beta * (t - tj))   {entre salidas la intensidad solo decrece}
    t    <- t + Exponencial(media = 1 / lmax)
    l    <- mu + SUMA_{tj en H_p} alfa * exp(-beta * (t - tj))
    u    <- Uniforme(0, 1)
  HASTA QUE u <= l / lmax
  DEVOLVER t0 + f_p * (t - t0)      {f_p = 1,2 en la puerta principal; 1 en la de emergencia}
FIN
```

Esta función viene definida en @kuligowski2015stairs, podría reducirse a otro estudiado en clase. La explicación ha sido generada por AI.

*Flujo de datos.* La figura siguiente muestra cómo se mueven los datos entre las rutinas del modelo (esquema de dos fases con avance por sucesos, como en los apuntes de la asignatura).

#let nd = (fill: rgb("#e3f1ef"), stroke: 0.8pt + rgb("#2f6f68"))
#let nd2 = (fill: rgb("#fdf3dc"), stroke: 0.8pt + rgb("#9a7416"))
#figure(
  text(size: 8pt, diagram(
    spacing: (11mm, 11mm),
    node-inset: 6pt,
    edge-stroke: 0.7pt,
    node((0, 0), align(center)[Parámetros \ de entrada], name: <par>, shape: fletcher.shapes.rect, ..nd2),
    node((1, 0), align(center)[Rutina de \ inicialización], name: <ini>, ..nd),
    node((2, 0), align(center)[Rutina de \ temporización \ (reloj y lista \ de sucesos)], name: <tmp>, ..nd),
    node((3, 0), align(center)[Rutina del \ suceso $i$], name: <suc>, ..nd),
    node((4, 0), align(center)[Generadores \ aleatorios], name: <rng>, ..nd2),
    node((3, 1), align(center)[Estado y \ contadores], name: <est>, ..nd2),
    node((2, 1), align(center)[Rutina de \ informes], name: <inf>, ..nd),
    edge(<par>, <ini>, "->"),
    edge(<ini>, <tmp>, "->", [lista inicial]),
    edge(<tmp>, <suc>, "->", [suceso $i$]),
    edge(<suc>, (3, -1), (2, -1), <tmp>, "->", [nuevos sucesos]),
    edge(<suc>, <rng>, "<->"),
    edge(<suc>, <est>, "<->"),
    edge(<tmp>, <inf>, "->", [condición de fin]),
    edge(<est>, <inf>, "->"),
  )),
  caption: [Flujo de datos entre las rutinas del modelo. En amarillo, los datos; en verde, las rutinas.],
) <fig-flujo>

=== Distribuciones de probabilidad
*Una distribución esa de rangos en la puerta, ponemos a varias personas en grupo y van saliendo, aunque el sink tenga una distribución cualquiera, la puerta lo consumirá en rachas, como si se atascaran al llegar.*

Estas son las variables aleatorias de entrada. Las demás entradas son deterministas (ver la tabla de variables en la descripción del modelo). Que cada una siga la familia indicada es una hipótesis de modelado: se justifica por los estudios citados y por el criterio de los apuntes (distribuciones teóricas antes que empíricas, y las más simples cuando no hay datos de ajuste).

#figure(
  table(
    columns: (1fr, 1fr, 1fr),
    inset: 9pt,
    align: left + horizon,
    table.header([*Variable*], [*Distribución*], [*Valor*]),
    [Acciones previas (coger cosas, llamar, apagar el ordenador)], [Tres Bernoulli independientes], [$p = "0,46"$; $"0,16"$; $"0,06"$],
    [Retardo de reacción $R$], [Determinista dado $K$ (nº de acciones, $K in {0,1,2,3}$): $R = 108 + 58 K$ s], [Base 1,8 min; 58 s por acción],
    [Salida elegida], [Bernoulli (principal / emergencia)], [$p_"princ" = "0,7"$],
    [Posición en la planta], [Uniforme en el rectángulo de la planta], [$L times A$ dados por el usuario],
    [Velocidad en planta], [Determinista dada la densidad $D$: $v = v_0 (1 - "0,266" D)$ si $D > "0,54"$ pers/m², y $v = v_0$ si no], [$v_0 = "1,2"$ m/s],
    [Velocidad en escalera], [Normal truncada], [$mu = "0,44"$ m/s, $sigma = "0,19"$ m/s, en $["0,07"; "1,7"]$],
    [Instantes de salida por la puerta], [Proceso de Hawkes (ver más arriba); huecos $times$ 1,2 en la principal], [$mu = "0,14"$; $alpha = "0,38"$; $beta = "0,57"$ (en s y 1/s)],
  ),
  caption: [Distribuciones de probabilidad de las variables aleatorias de entrada.],
) <tab-dist>

Los parámetros de Hawkes son la media de las 27 escaleras sin ocupantes con movilidad reducida de la Tabla 13 del estudio (medianas: $"0,12"$; $"0,39"$; $"0,53"$). Con ellos, el cociente $alpha / beta approx "0,67"$ indica que una de cada tres salidas ocurre sin estar "arrastrada" por otra, y el flujo medio de la puerta es $mu / (1 - alpha / beta) approx "0,42"$ pers/s. Los tres valores se pueden variar en los experimentos.

== Descripción del modelo
Según el guion de la asignatura, el modelo se describe mediante sus elementos (entidades, atributos, variables, recursos, colas y acumuladores), su estructura lógica y las condiciones de la simulación.

=== Elementos del modelo

#figure(
  table(
    columns: (auto, 1fr, 2fr),
    inset: 5pt,
    align: left + horizon,
    table.header([*Elemento*], [*Tipo (Simio)*], [*Descripción y parámetros*]),
    [Alarma], [_Source_], [Crea las $N_f dot N_p$ entidades _Persona_ en $t = 0$ (llegada simultánea) y las reparte por plantas.],
    [Reacción], [_Server_ (capacidad $infinity$)], [Retardo $R = 108 + 58 K$ s. No hay cola: todas las personas reaccionan a la vez.],
    [Elección de salida], [_Decision_], [Bernoulli: 70 % principal, 30 % emergencia.],
    [Caminata por planta], [_Path_ / _TimePath_], [Longitud $d_i$ (línea recta). Velocidad $v_0 (1 - "0,266" D)$ si $D > "0,54"$ pers/m².],
    [Escalera principal / de emergencia], [_Path_], [Longitud $f dot ell$, con $f$ la planta de origen y $ell$ la longitud de escalera por planta. Velocidad Normal(0,44; 0,19).],
    [Puerta principal / de emergencia], [_Server_ (capacidad 1) con cola FIFO], [Tiempo de proceso = hueco hasta la siguiente salida (Hawkes). Hueco $times$ 1,2 en la principal.],
    [Exterior], [_Sink_], [Recibe a las personas y registra $t_"sal,i"$.],
  ),
  caption: [Elementos del modelo y su correspondencia con objetos de Simio.],
)

*Entidad.* Existe un único tipo, *Persona*, con los atributos: identificador, planta $f$, posición $(x, y)$, nº de acciones previas $K$, retardo $R_i$, salida elegida, distancia $d_i$, velocidad en planta $v_i$, tiempo de escalera $t_"esc,i"$, instante de llegada a la puerta $t_"ll,i"$ e instante de salida $t_"sal,i"$.

*Recursos.* Dos: la puerta principal y la de emergencia, de capacidad 1 cada una. La escalera no se modela como recurso, porque no se tienen en cuenta adelantamientos ni choques en ella.

*Colas.* Una cola FIFO por puerta. Es el único sitio donde una persona espera a otras.

#figure(
  text(size: 8pt, diagram(
    spacing: (9mm, 13mm),
    node-inset: 6pt,
    edge-stroke: 0.7pt,
    node((0, 1), align(center)[*Alarma* \ #text(size: 6.5pt)[Source: $N_f dot N_p$ \ personas en $t = 0$]], shape: fletcher.shapes.pill, name: <alarma>, fill: rgb("#e3f1ef"), stroke: 0.8pt + rgb("#2f6f68")),
    node((1, 1), align(center)[*Reacción* \ #text(size: 6.5pt)[Server cap. $infinity$ \ $108 + 58 K$ s]], name: <reac>, fill: rgb("#e3f1ef"), stroke: 0.8pt + rgb("#2f6f68")),
    node((2, 1), [¿Salida?], shape: fletcher.shapes.diamond, name: <dec>, fill: rgb("#3b7dc4"), stroke: 0.8pt + rgb("#3b7dc4"), inset: 3pt),
    node((3, 0), align(center)[*Caminata* \ #text(size: 6.5pt)[$v_0 (1 - "0,266" D)$]], name: <cp>, fill: rgb("#e3f1ef"), stroke: 0.8pt + rgb("#2f6f68")),
    node((4, 0), align(center)[*Escalera principal* \ #text(size: 6.5pt)[$f dot ell$ m; N(0,44; 0,19)]], name: <ep>, fill: rgb("#e3f1ef"), stroke: 0.8pt + rgb("#2f6f68")),
    node((5, 0), align(center)[*Puerta principal* \ #text(size: 6.5pt)[cap. 1, FIFO \ Hawkes $times$ 1,2]], name: <pp>, fill: rgb("#e3f1ef"), stroke: 0.8pt + rgb("#2f6f68")),
    node((3, 2), align(center)[*Caminata* \ #text(size: 6.5pt)[$v_0 (1 - "0,266" D)$]], name: <ce>, fill: rgb("#e3f1ef"), stroke: 0.8pt + rgb("#2f6f68")),
    node((4, 2), align(center)[*Escalera emergencia* \ #text(size: 6.5pt)[$f dot ell$ m; N(0,44; 0,19)]], name: <ee>, fill: rgb("#e3f1ef"), stroke: 0.8pt + rgb("#2f6f68")),
    node((5, 2), align(center)[*Puerta emergencia* \ #text(size: 6.5pt)[cap. 1, FIFO \ Hawkes]], name: <pe>, fill: rgb("#e3f1ef"), stroke: 0.8pt + rgb("#2f6f68")),
    node((6, 1), align(center)[*Exterior* \ #text(size: 6.5pt)[Sink: registra $T_i$]], shape: fletcher.shapes.pill, name: <sink>, fill: rgb("#e3f1ef"), stroke: 0.8pt + rgb("#2f6f68")),
    edge(<alarma>, <reac>, "->"),
    edge(<reac>, <dec>, "->"),
    edge(<dec>, (2, 0), <cp>, "->", [70 %], label-side: left),
    edge(<dec>, (2, 2), <ce>, "->", [30 %], label-side: right),
    edge(<cp>, <ep>, "->", [$d_i$ m]),
    edge(<ep>, <pp>, "->"),
    edge(<ce>, <ee>, "->", [$d_i$ m]),
    edge(<ee>, <pe>, "->"),
    edge(<pp>, (6, 0), <sink>, "->"),
    edge(<pe>, (6, 2), <sink>, "->"),
  )),
  caption: [Estructura lógica del modelo: recorrido de una entidad _Persona_ (en el mismo estilo que el esquema de ejemplo del guion).],
) <fig-modelo>

=== Variables del modelo

#figure(
  table(
    columns: (auto, 2fr, 1fr),
    inset: 5pt,
    align: left + horizon,
    table.header([*Tipo*], [*Variables*], [*Naturaleza*]),
    [Entrada (parámetros)], [$N_f$, $N_p$, dimensiones de la planta $L times A$, posiciones de las dos salidas, $ell$, $p_"princ"$, factor de penalización $f_"princ" = "1,2"$, probabilidades de acciones previas, retardo base y coste por acción, $v_0$, $mu$, $alpha$, $beta$], [Deterministas (los fija el usuario)],
    [Entrada aleatoria], [$K$, salida elegida, posición, velocidad en escalera, instantes de salida por la puerta], [Aleatorias (ver tabla de distribuciones)],
    [Estado], [Reloj; nº de personas moviéndose en cada planta (da $D$); cola y estado (libre/ocupada) de cada puerta; historia de salidas de cada puerta; nº de evacuados], [Dependen de su valor anterior],
    [Atributos], [Los de la entidad _Persona_ (arriba)], [Por entidad],
    [Acumuladores], [Evacuados por cada puerta, suma de esperas en cola, espera máxima, tamaño máximo de cola, $T_95$ y $T_100$ de la réplica], [Se inician a 0],
    [Salida], [$T_95$ (tiempo hasta que sale el 95 %), $T_100$, % de personas por cada puerta, espera media en cola de cada puerta, tamaño máximo de cada cola, flujo medio de cada puerta], [Aleatorias (dependen de entradas aleatorias)],
  ),
  caption: [Variables de entrada, estado y salida del modelo.],
)

La salida principal del estudio es $T_95$ de cada réplica; las demás se recogen porque, como indican los apuntes, es mejor registrar más medidas de las necesarias que quedarse sin datos.

=== Condiciones de la simulación

- *Condiciones iniciales*: reloj a 0, todas las personas en sus plantas (ninguna ha reaccionado), colas vacías, puertas libres, historias de salida vacías y contadores a 0.
- *Condición de finalización*: ha salido el 95 % de las personas, es decir, evacuados $>= ceil("0,95" dot N)$. Se puede cambiar a "han salido todas" para medir $T_100$.
- *Tipo de simulación*: finita (terminal), sin calentamiento. Cada réplica usa semillas distintas, y los resultados se promedian entre réplicas.

== Pregunta y experimentos
El objetivo de hacer esta simulación sobre los datos del documento @kuligowski2015stairs es hacer que se parezcan lo máximo posible y responder a la siguiente pregunta principal:

#align(center)[#grid(columns: (80%))[#text("¿Cuál es el tiempo de salida medio del 95% de las personas para un edificio dado?", size: 15pt)]]

Aunque el estudio lo responda @kuligowski2015stairs[sec. 5.6.5 y Tabla 19], este no modela interacciones antes de entrar en las escaleras y elecciones de puertas principales; por lo que nuestra simulación esperamos que de unos resultado más reales.

Se escoge el 95% y no el 100% porque el último 5% tarda muchísimo más en salir, por lo que alarga muchísimo el resultado final cuando la mayoría de personas ya han salido.


Además de la pregunta principal, el modelo permite responder a estas otras:

+ ¿Cuánto cambia el tiempo si todos usan la salida principal (frente al reparto 70/30)?
+ ¿Cuánto pesan las acciones previas a la evacuación (coger cosas, llamar, apagar el ordenador)?
+ ¿Cómo crece el tiempo con la altura y la población del edificio?
+ ¿Importa que las salidas por la puerta sean en rachas, o bastaría un flujo constante con la misma media?

*Experimentos.* En todos se simulan $R = 30$ réplicas por configuración, con semillas distintas, y se da la media de $T_95$ con su intervalo de confianza al 95 %. El escenario base es un edificio de 10 plantas con 40 personas por planta (valores de ejemplo, ajustables) y los parámetros de la tabla de distribuciones.

#figure(
  table(
    columns: (auto, 2fr, 1.6fr, 1.2fr),
    inset: 5pt,
    align: left + horizon,
    table.header([*Exp.*], [*Qué se varía*], [*Qué se mide*], [*Responde a*]),
    [E0. Validación], [Reproducir los edificios 4 a 8 del estudio con su población (Tabla 13) y su altura (Tabla 4), sin salida de emergencia ($p_"princ" = 1$) y con retardo ajustado a los simulacros], [$T_95$ simulado frente a medido (Tabla 19)], [¿Se parece el modelo a los datos reales? (el estudio llegó a $plus.minus 17 %$)],
    [E1. Base], [Nada (escenario base)], [$T_95$, % por puerta, esperas y colas], [Pregunta principal],
    [E2. Elección de puerta], [$p_"princ" in {0; "0,3"; "0,5"; "0,7"; "0,9"; 1}$], [$T_95$], [Pregunta 1 (se espera algo más de un 20 % al pasar de 0,7 a 1, según Sagun)],
    [E3. Reacción], [Sin acciones previas ($K = 0$ para todos) frente a probabilidades del modelo], [$T_95$], [Pregunta 2],
    [E4. Tamaño], [$N_f in {5, 10, 20, 40}$ y $N_p in {20, 40, 80}$], [$T_95$], [Pregunta 3],
    [E5. Rachas], [Hawkes ($alpha = "0,38"$) frente a Poisson con la misma intensidad media ($alpha = 0$ y $mu' = mu / (1 - alpha / beta)$)], [$T_95$, espera máxima y cola máxima], [Pregunta 4],
  ),
  caption: [Experimentos a simular y pregunta de la que cada uno aporta respuesta.],
)

Con E0 se valida el modelo antes de usarlo; E1 responde a la pregunta principal, y E2 a E5 son análisis de sensibilidad sobre los factores que el estudio no modela. El número de réplicas puede aumentarse si la mitad del intervalo de confianza de $T_95$ supera el 5 % de su media.


= Parte II: Implementación

*borrador*
Modelar las escaleras como una cola de prioridad donde a mayor altura este una persona mas tarde en salir y va bajando con el tiempo (simulando que baja las escaleras, se hará según la función que se haya recogido en los datos @kuligowski2015stairs[sec. 5.6.1])

== Decisiones tecnológicas
== Estructura del repositorio
=== Carpetas
=== Contenido de cada archivo
== Explicación del código
== Compilación y ejecución

= Parte III: Resultados
== Ejecuciones realizadas
== Resultados
== Comparación con el estudio
== Limitaciones

= Conclusiones y trabajo futuro

#bibliography("bibliografia.yml", title: "Referencias" )
