#import "@preview/numbly:0.1.0": numbly
#import "theme.typ": colors, fonts, medium, typography
#import "elements.typ": elements

// Metadata and compact footers use textual content; the cover keeps markup.
#let plain(body) = {
  if type(body) == str { body } else if type(body) != content { "" } else if body.has("text") {
    body.text
  } else if body.has("children") { body.children.map(plain).join() } else if body.has("body") {
    plain(body.body)
  } else if body.func() in (linebreak, parbreak) { " " } else { "" }
}

#let compact-label(label, width) = context {
  let chars = label.clusters()
  if measure(label).width <= width { label } else {
    let low = 0
    let high = chars.len()
    while low < high {
      let middle = calc.ceil((low + high) / 2)
      if measure(chars.slice(0, middle).join() + "…").width <= width {
        low = middle
      } else { high = middle - 1 }
    }
    chars.slice(0, low).join() + "…"
  }
}

#let page-footer(title, authors) = context {
  set text(font: fonts.sans, size: 7pt, fill: colors.muted)
  let author = authors.join("、")
  let label = if authors.len() == 0 { plain(title) } else { author + " | " + plain(title) }
  grid(
    columns: (1fr, auto),
    column-gutter: 12pt,
    align: (left, right),
    layout(size => compact-label(label, size.width)), counter(page).display("1 / 1", both: true),
  )
}

#let header-label(body) = {
  set text(size: 19pt, weight: "regular")
  set par(leading: 0.25em)
  layout(size => {
    assert(
      measure(body, width: size.width).height <= 1.4cm,
      message: "slide title exceeds two lines; shorten the title",
    )
    block(height: 1.4cm, width: 100%)[
      #set align(left + top)
      #body
    ]
  })
}

#let numbered-title(it) = context {
  if it.numbering != none {
    // Continuation pages reuse the counter at the original heading's location.
    let prefix = numbering(it.numbering, ..counter(heading).at(it.location()))
    if prefix != none {
      prefix
      h(0.45em)
    }
  }
  it.body
}

#let running-title() = context {
  let current = here().page()
  let latest = query(heading.where(level: 1).or(heading.where(level: 2)))
    .rev()
    .find(it => it.location().page() <= current)
  if latest != none and latest.level == 2 {
    header-label[
      #numbered-title(latest)
      #if latest.location().page() < current {
        let continuation = current - latest.location().page() + 1
        text(font: fonts.sans, size: 14pt, fill: colors.faint, h(0.6em) + "(" + str(continuation) + ")")
      }
    ]
  }
}

#let cover(title, subtitle, authors, date) = {
  set page(header: none, footer: none, margin: (x: medium.space / 2, top: 0.7cm, bottom: 0.9cm))
  block(height: 100%, width: 100%, breakable: false)[
    #v(1fr)
    #line(length: 22pt, stroke: 2pt + colors.accent)
    #v(12pt)
    #block(width: 100%)[
      #set par(leading: 0.28em)
      #text(size: 29pt, weight: "regular", title)
    ]
    #if subtitle != none and subtitle != "" {
      v(10pt)
      text(size: 13pt, fill: colors.muted, subtitle)
    }
    #v(1fr)
    #text(font: fonts.sans, size: 9pt, fill: colors.muted)[
      #authors.join("、")
      #if authors.len() > 0 and date != none {
        h(0.7em)
        [·]
        h(0.7em)
      }
      #if date != none { date }
    ]
  ]
}

#let section-slide(it) = {
  pagebreak(weak: true)
  set page(header: none)
  block(height: 100%, width: 100%, breakable: false)[
    #v(1fr)
    #set par(leading: 0.3em)
    #text(size: 27pt, weight: "regular", numbered-title(it))
    #v(14pt)
    #line(length: 22pt, stroke: 2pt + colors.accent)
    #v(1fr)
  ]
  pagebreak(weak: true)
}

#let contents() = context {
  let sections = query(heading.where(level: 1, outlined: true))
  let target = if sections.len() > 0 { heading.where(level: 1, outlined: true) } else {
    heading.where(level: 2, outlined: true)
  }
  if query(target).len() > 0 {
    set page(header: header-label[目录])
    show outline.entry: it => block(above: 0pt, below: 10pt, breakable: false)[
      #link(it.element.location())[
        #grid(
          columns: (1fr, auto),
          column-gutter: 12pt,
          numbered-title(it.element),
          text(font: fonts.sans, size: 9pt, fill: colors.faint, numbering(
            "1",
            ..counter(page).at(it.element.location()),
          )),
        )
      ]
    ]
    outline(title: none, target: target, indent: 0pt)
    pagebreak(weak: true)
  }
}

#let slides(
  body,
  title: none,
  subtitle: none,
  date: none,
  authors: (),
  ratio: 16 / 9,
  footer: true,
  toc: true,
) = {
  assert(title != none and plain(title).trim() != "", message: "title must be non-empty text or content")
  assert(ratio in (16 / 9, 4 / 3), message: "ratio must be 16/9 or 4/3")
  assert(type(footer) == bool and type(toc) == bool, message: "footer and toc must be booleans")
  let authors = if authors == none { () } else if type(authors) == str { (authors,) } else { authors }
  assert(type(authors) == array, message: "authors must be a string or an array of strings")
  assert(authors.all(it => type(it) == str), message: "authors must contain only strings")
  let authors = authors.filter(it => it.trim() != "")
  let displayed-date = if type(date) == datetime { date.display("[year]-[month]-[day]") } else { date }

  set document(title: title, author: authors, date: if type(date) == datetime { date } else { none })
  show: typography
  show: elements
  set heading(numbering: numbly("{1}", "{1}.{2}", default: none))
  set page(
    width: medium.height * ratio,
    height: medium.height,
    fill: colors.background,
    margin: (x: medium.space / 2, top: 2.2cm, bottom: 0.9cm),
    header: running-title(),
    header-ascent: 0.1cm,
    footer: if footer { page-footer(title, authors) },
    footer-descent: 0.4cm,
    numbering: none,
  )
  show heading.where(level: 1): section-slide
  show heading.where(level: 2): {
    pagebreak(weak: true)
    // Give even an intentionally empty slide a page before the next heading.
    block(height: 0pt, above: 0pt, below: 0pt)
  }
  show heading.where(level: 3): set text(size: 14pt)
  show heading.where(level: 4): set text(size: 12pt)

  cover(title, subtitle, authors, displayed-date)
  pagebreak(weak: true)
  if toc { contents() }
  body
}
