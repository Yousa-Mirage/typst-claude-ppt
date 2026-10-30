#import "../src/lib.typ": slides, card, callout, two-columns, badge, message, artifact

#show: slides.with(
  title: [让想法清晰呈现],
  subtitle: [A quieter space for better ideas.],
  authors: ("yousa-mirage",),
  date: "2026-10-30",
)

= 安静的画布

== 为内容留出呼吸的空间

#badge[Claude-inspired · Light]
#v(7pt)
#two-columns(
  card(title: [01 / 清晰])[
    让观点成为主角。

    用明确的层级，引导读者理解。
  ],
  card(title: [02 / 克制])[
    让留白参与表达。

    用温暖的色彩，承接重要内容。
  ],
)
#v(7pt)
#callout(title: [设计笔记])[每一页，只围绕一个主要观点展开。]

== 中英文，自然地一起阅读

Anthropic Serif Web Text 承接英文，思源宋体呈现中文。

#quote(attribution: [表达的原则])[
  先想清楚，再说清楚。
]

他说：“真正清晰的表达，来自对问题的充分理解。”

== 结构，比装饰更重要

#table(
  columns: (1fr, 1fr, 1fr),
  table.header([步骤], [问题], [结果]),
  [理解], [为什么做？], [共同目标],
  [探索], [可以怎样做？], [可行方案],
  [验证], [如何判断？], [下一步行动],
)

#v(7pt)
#text(size: 10pt)[让证据靠近观点，让行动紧随结论。]

= 从对话到成果

== 像对话一样，逐步展开思考

#message[怎样把复杂的研究，讲给第一次接触的人听？]
#v(9pt)
#message(role: "assistant")[
  从一个具体的问题开始，再逐步建立结构。

  + 先说清它为什么值得关注。
  + 只保留支撑结论的关键证据。
  + 给听众一个明确的下一步。
]

== 将想法，放进可以使用的成果里

#artifact(title: [研究计划 · Research plan])[
  #two-columns(
    [*现在知道什么*

    问题的背景、已有证据与尚未解决的部分。],
    [*接下来做什么*

    一个可验证的假设，以及一项具体的行动。],
  )
]

#v(8pt)
#badge[清晰的结构 → 可执行的计划]

== 从一段简洁的源码开始

```typ
#show: slides.with(
  title: [让想法清晰呈现],
  authors: "yousa-mirage",
)

= 从问题出发
== 每一页，讲清一个观点
```

了解 #link("https://typst.app")[Typst]，让内容与设计一起生长。
