#let portada() = {
  let tinta = rgb("142D42")
  let acento = rgb("D96B36")
  page(
    paper: "a4",
    margin: (x: 2.3cm, y: 2cm),
    numbering: none,
    header: none,
    footer: none,
    fill: rgb("F6F4EF"),
  )[
    #set text(fill: tinta, lang: "es", size: 11pt)
    #rect(width: 1.5cm, height: 4pt, fill: acento, stroke: none)
    #v(0.6cm)
    #text(size: 10pt, tracking: 1.5pt, weight: "bold")[PROYECTO DE SIMULACIÓN]
    #v(1.8cm)
    #text(size: 39pt, weight: "bold")[Simulación de\ desalojo de\ edificios]
    #v(0.5cm)
    #text(size: 15pt, fill: rgb("526574"))[
      Modelo de evacuación y visualización 3D en tiempo real
    ]
    #v(1cm)
    #block(fill: tinta, inset: (x: 13pt, y: 8pt), radius: 3pt)[
      #text(fill: white, size: 10pt, weight: "bold", tracking: 1pt)[DESARROLLADO EN RUST]
    ]
    #v(1fr)
    #line(length: 100%, stroke: 0.7pt + rgb("CCD2D5"))
    #v(0.6cm)
    #text(size: 9pt, tracking: 1.3pt, weight: "bold", fill: acento)[AUTORES]
    #v(0.4cm)
    #grid(
      columns: (1fr, 1fr),
      column-gutter: 0.6cm,
      [
        #text(size: 12pt, weight: "bold")[Jose Luis Parrilla Fuentes]
        #v(0.15cm)
        #text(size: 10pt)[#link("mailto:jlpf0006@red.ujaen.es")[jlpf0006\@red.ujaen.es]]
      ],
      [
        #text(size: 12pt, weight: "bold")[Cesar Moreno Cabello]
        #v(0.15cm)
        #text(size: 10pt)[#link("mailto:cmc00150@red.ujaen.es")[cmc00150\@red.ujaen.es]]
      ],
    )
    #v(1.2cm)
    #text(size: 10pt, fill: rgb("526574"))[Memoria del proyecto]
    #h(1fr)
    #text(size: 10pt, fill: rgb("526574"))[
      #datetime.today().display("[day padding:zero]/[month padding:zero]/[year]")
    ]
  ]
}
