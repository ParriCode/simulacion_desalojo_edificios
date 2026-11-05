#set document(title: "Documentación del proyecto", author: "Equipo")
#set page(paper: "a4", margin: 2.5cm, numbering: "1")
#set text(lang: "es", size: 11pt)
#set par(justify: true, leading: 0.65em)
#set heading(numbering: "1.1")

#align(center)[
  #text(size: 22pt, weight: "bold")[Documentación del proyecto]

  #v(0.5em)
  Equipo de desarrollo \
  #datetime.today().display("[day]/[month]/[year]")
]

#v(1em)
#outline(title: "Índice", indent: auto)
#pagebreak()

= Introducción

Este documento describe el diseño y el funcionamiento del proyecto, escrito en Rust.
Se compila con Typst y forma parte del mismo repositorio que el código fuente.

= Arquitectura

El repositorio se organiza así:

#table(
  columns: (auto, 1fr),
  inset: 8pt,
  align: (left, left),
  [*Carpeta*], [*Contenido*],
  [`src/`], [Código fuente en Rust],
  [`docs/`], [Documentación en Typst],
)

== Ejemplo de código

Un ejemplo mínimo en Rust:

```rust
fn main() {
    println!("Hola, mundo");
}
```

= Fundamentos matemáticos

Typst soporta fórmulas en línea, como $a^2 + b^2 = c^2$, y fórmulas en bloque:

$ sum_(i=1)^n i = (n (n + 1)) / 2 $

= Conclusiones

Aquí irán las conclusiones del trabajo.
