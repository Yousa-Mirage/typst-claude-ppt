// Fixed Claude light palette, translated from the personal Typora theme.
#let colors = (
  background: rgb("faf9f5"),
  surface: rgb("f0eee6"),
  raised: rgb("fdfcf9"),
  ink: rgb("141413"),
  muted: rgb("3d3d3a"),
  faint: rgb("73726c"),
  border: rgb("1f1e1d").transparentize(85%),
  accent: rgb("d97757"),
  code: rgb("8a2424"),
)

#let fonts = (
  serif: ((name: "Anthropic Serif Web Text", covers: "latin-in-cjk"), "Source Han Serif SC"),
  sans: ((name: "Anthropic Sans Web Text", covers: "latin-in-cjk"), "Source Han Sans SC"),
  mono: ((name: "Anthropic Mono", covers: "latin-in-cjk"), "Source Han Serif SC"),
)

#let dimensions = (
  height: 10.5cm,
  margin: (x: 0.8cm, top: 2.2cm, bottom: 0.9cm),
  cover-top: 0.7cm,
  header-height: 1.4cm,
  header-ascent: 0.1cm,
  footer-descent: 0.4cm,
)
#let content-height = dimensions.height - dimensions.margin.top - dimensions.margin.bottom

#let theme(body) = {
  set text(font: fonts.serif, size: 12pt, fill: colors.ink, lang: "zh", region: "CN")
  set par(leading: 0.65em, spacing: 0.8em, justify: false)
  show heading: set text(weight: "regular")
  set math.equation(numbering: none)
  show math.equation: set text(font: ("Libertinus Math", "Source Han Serif SC"))

  set raw(theme: "../assets/claude.tmTheme")
  set list(
    indent: 0.15em,
    body-indent: 0.65em,
    spacing: 0.6em,
    marker: depth => text(fill: colors.accent, if depth == 0 { [•] } else { [◦] }),
  )
  set enum(indent: 0pt, body-indent: 0.65em, spacing: 0.6em)
  set terms(spacing: 0.65em)

  show raw: set text(font: fonts.mono)
  show raw.where(block: false): it => box(
    fill: colors.surface,
    radius: 2pt,
    inset: (x: 3pt, y: 1pt),
    text(fill: colors.code, it),
  )
  show raw.where(block: true): it => block(
    width: 100%,
    fill: colors.raised,
    stroke: 0.5pt + colors.border,
    radius: 6pt,
    inset: 10pt,
    breakable: true,
  )[
    #set par(leading: 0.5em)
    #show raw: set text(size: 11pt)
    #show raw.line: line => {
      show regex("\\S{24,}"): token => token.text.clusters().join(sym.zws)
      line.body
    }
    #it
  ]

  set quote(block: true)
  show quote.where(block: true): it => block(
    width: 100%,
    fill: colors.surface,
    inset: (left: 12pt, y: 12pt),
    stroke: (left: 2pt + colors.accent),
  )[
    #set text(fill: colors.muted)
    #it
  ]

  set table(
    inset: (x: 8pt, y: 6pt),
    stroke: (x: none, y: 0.5pt + colors.border),
    align: left + top,
    fill: (x, y) => if y == 0 { colors.surface },
  )
  show table: set text(size: 10pt)
  show table.header: set text(font: fonts.sans, weight: "bold")
  show table.cell.where(y: 0): set text(font: fonts.sans, weight: "bold")

  set figure(gap: 7pt)
  show figure.caption: set text(font: fonts.sans, size: 8pt, fill: colors.muted)
  show link: it => {
    if type(it.dest) == str {
      underline(stroke: 0.6pt + colors.accent.darken(20%), offset: 2pt, text(fill: colors.accent.darken(20%), it))
    } else { it }
  }
  body
}
