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

#let badge(body) = box(
  fill: colors.surface, stroke: 0.5pt + colors.border,
  radius: 20pt, inset: (x: 7pt, y: 3pt),
  text(font: fonts.sans, size: 8pt, fill: colors.muted, body),
)

#let message(body, role: "user") = {
  assert(role in ("user", "assistant"), message: "message role must be user or assistant")
  if role == "user" {
    align(right, block(width: 88%)[
      #panel(fill: colors.surface, stroke: none)[#set align(left); #body]
    ])
  } else {
    block(width: 100%)[
      #block(below: 5pt)[#text(font: fonts.sans, size: 9pt, fill: colors.muted)[Claude]]
      #body
    ]
  }
}

#let artifact(body, title: [Artifact]) = panel(inset: 0pt)[
  #block(width: 100%, fill: colors.surface, inset: (x: 12pt, y: 8pt), radius: (top: 7pt))[
    #text(font: fonts.sans, size: 9pt, fill: colors.muted, title)
  ]
  #block(inset: 12pt, width: 100%)[#body]
]
