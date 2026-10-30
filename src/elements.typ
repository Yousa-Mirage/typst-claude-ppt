#import "theme.typ": colors, fonts

#let elements(body) = {
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
    inset: (left: 12pt, y: 6pt),
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
      underline(stroke: 0.6pt + colors.accent, offset: 2pt, it)
    } else { it }
  }
  body
}
