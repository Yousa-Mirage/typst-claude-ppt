// Pandoc template partial: Quarto/Pandoc expands template variables and conditionals before Typst compilation.
// Map Quarto metadata to claude.slides and apply the presentation template to the document.
#show: doc => claude.slides(
  title: [$title$],
$if(subtitle)$
  subtitle: [$subtitle$],
$endif$
  authors: (
$for(by-author)$
    content-to-string([$it.name.literal$]),
$endfor$
  ),
$if(date)$
  date: [$date$],
$endif$
  ratio: $ratio$,
  footer: $if(footer)$true$else$false$endif$,
  toc: $if(toc)$true$else$false$endif$,
  accent: $if(accent)$true$else$false$endif$,
  doc,
)

// Remove Quarto's inner code panel; the package draws the complete panel.
#show raw.where(block: true): set block(fill: none, inset: 0pt, radius: 0pt)
