#set document(
  title: "Simulación de desalojo de edificios",
  author: ("César Moreno Cabello", "Jose Luis Parrilla Fuentes"),
)
#set page(paper: "a4", margin: 2.5cm, numbering: "1")
#set text(lang: "es", size: 11pt)
#set par(justify: true, leading: 0.65em)
#set heading(numbering: "1.1")

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
== Decisiones y consideraciones
=== Suposiciones
=== Sucesos, eventos y flujo de datos
=== Distribuciones de probabilidad
== Descripción del modelo
== Pregunta y experimentos
= Parte II: Implementación
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

= Bibliografía
