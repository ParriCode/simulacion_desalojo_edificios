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
-
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
    - Cada persona tarda un tiempo en reaccionar, según el estudio de WTC del 11S @averill2005ocupantes[diap. «WTC 1», tabla «Activities Before Evacuation»] la distribución era la siguiente: 70 % habló con otros, 46 % cogió sus cosas, 30 % ayudó a otros, 23 % buscó a alguien, 16 % llamó por teléfono, 6 % apagó el ordenador @kuligowski2010incendio[Metodología, p. 7 y Apéndice A, pregunta 6, p. 22]
    @kuligowski2010incendio[Tabla 2, p. 13]. Según este mismo estudio, el tiempo medido desde el impacto por  tipo de tarea fue: Sin *ninguna tarea previa*	1,8 min hasta ponerse en marcha, *una tarea de acción* (coger cosas, avisar a otros)	2,9 min, *dos tareas de acción*	4,0 min, el coste estimado por tarea de acción	≈ 0,97 min (unos 58 s) @galea2012wtc[sec. «Response times», p. 513].

      *En resumen* (TL;DR), como hemos dicho que omitimos la interacción por grupos nos quedamos con que cada persona al sonar una alarma tiene un: *46% de coger sus cosas, 16% de llamar a alguien y 6% de apagar el ordenador. Son acciones no excluyentes y cada acción suma 58s de _delay_*.]
)

=== Sucesos, eventos y flujo de datos
=== Distribuciones de probabilidad
Una distribución esa de rangos en la puerta, ponemos a varias personas en grupo y van saliendo, aunque el sink tenga una distribución cualquiera, la puerta lo consumirá en rachas, como si se atascaran al llegar.
== Descripción del modelo
== Pregunta y experimentos
El objetivo de hacer esta simulación sobre los datos del documento @kuligowski2015stairs es hacer que se parezcan lo máximo posible y responder a las siguientes preguntas:

#align(center)[#grid(columns: (80%))[#text("¿Cuál es el tiempo de salida medio del 95% de las personas para un edificio dado?", size: 15pt)]]

Aunque el estudio lo responda @kuligowski2015stairs[sec. 5.6.5 y Tabla 19], este no modela interacciones antes de entrar en las escaleras y elecciones de puertas principales; por lo que nuestra simulación esperamos que de unos resultado más reales.

Se escoge el 95% y no el 100% porque el último 5% tarda muchísimo más en salir, por lo que alarga muchísimo el resultado final cuando la mayoría de personas ya han salido.

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
