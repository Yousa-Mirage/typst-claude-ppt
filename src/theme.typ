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
  sans: ((name: "Anthropic Sans Web Text", covers: "latin-in-cjk"), "Source Han Serif SC"),
  mono: ((name: "Anthropic Mono", covers: "latin-in-cjk"), "Source Han Serif SC"),
)

#let medium = (height: 10.5cm, space: 1.6cm, body: 12pt)

#let typography(body) = {
  set text(font: fonts.serif, size: medium.body, fill: colors.ink, lang: "zh", region: "CN")
  set par(leading: 0.65em, spacing: 0.8em, justify: false)
  set heading(numbering: none)
  show heading: set text(weight: "regular")
  set math.equation(numbering: none)
  show math.equation: set text(font: ("Libertinus Math", "Source Han Serif SC"))
  body
}
