#import "theme.typ": colors, fonts, medium

// A panel may move to the next page, but must fit on a whole content page.
#let panel(body, fill: colors.raised, stroke: 0.5pt + colors.border, inset: 12pt, radius: 7pt) = layout(size => {
  let result = block(width: 100%, breakable: false, fill: fill, stroke: stroke,
    inset: inset, radius: radius, body)
  assert(measure(result, width: size.width).height <= medium.height - 3.2cm,
    message: "panel is taller than a slide; split the content across slides")
  result
})

#let card(body, title: none) = panel[
  #if title != none {
    block(below: 7pt)[#text(font: fonts.sans, size: 10pt, fill: colors.muted, title)]
  }
  #body
]

#let callout(body, title: [提示]) = panel(
  fill: colors.surface, stroke: (left: 2pt + colors.accent), radius: 3pt,
)[
  #if title != none {
    block(below: 6pt)[#text(font: fonts.sans, size: 10pt, fill: colors.muted, title)]
  }
  #body
]

#let two-columns(left, right) = grid(
  columns: (1fr, 1fr), column-gutter: 14pt, align: top,
  left, right,
)
