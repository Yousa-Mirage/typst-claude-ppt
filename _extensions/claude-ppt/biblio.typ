$if(citations)$
$if(csl)$
#set bibliography(style: "$csl$")
$elseif(bibliographystyle)$
#set bibliography(style: "$bibliographystyle$")
$endif$
$if(bibliography)$
$if(suppress-bibliography)$
#show bibliography: none
$else$
// Use a content slide instead of Typst's default level-one heading.
#heading(level: 2, outlined: false)[$if(reference-section-title)$$reference-section-title$$else$参考文献$endif$]
$endif$
#bibliography(($for(bibliography)$"$bibliography$"$sep$,$endfor$), title: none)
$endif$
$endif$
