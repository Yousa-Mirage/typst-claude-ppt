// Pandoc template partial: Quarto/Pandoc expands template variables and conditionals before Typst compilation.
// Load bibliography sources and options; the Typst package styles its unnumbered content-slide title.
$if(citations)$
$if(csl)$
#set bibliography(style: "$csl$")
$elseif(bibliographystyle)$
#set bibliography(style: "$bibliographystyle$")
$endif$
$if(bibliography)$
$if(suppress-bibliography)$
#show bibliography: none
$endif$
#bibliography(($for(bibliography)$"$bibliography$"$sep$,$endfor$), title: [$if(reference-section-title)$$reference-section-title$$else$参考文献$endif$])
$endif$
$endif$
