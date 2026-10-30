#import "../src/lib.typ": callout, card, slides, two-columns

#show: slides.with(
  title: [让想法清晰呈现],
  subtitle: [A quieter space for better ideas.],
  authors: ("Yousa Mirage", "天然純真"),
  date: "2026-10-30",
)

= 安静的画布

== 为内容留出呼吸的空间

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

== 用简洁的语言，组织复杂的信息

- 从一个值得回答的问题出发。
- 将证据放在观点附近。
  - 数据解释现象。
  - 案例帮助理解。
- 用明确的行动结束讨论。

== 结构，比装饰更重要

#table(
  columns: (1fr, 1fr, 1fr),
  table.header([步骤], [问题], [结果]),
  [理解], [为什么做？], [共同目标],
  [探索], [可以怎样做？], [可行方案],
  [验证], [如何判断？], [下一步行动],
)

$ "平均值" = 1/n sum_(i=1)^n x_i $

#text(size: 10pt)[用表格比较，用公式解释，让证据靠近观点。]

#pagebreak()

=== 从数据回到问题

一个统计量可以概括数据，但还需要结合分布与样本理解。

==== 先确定比较对象

关注样本来自哪里、测量是否一致，以及结论适用于什么范围。

#callout(title: [同一主题，继续展开])[
  这一页延续上一页的二级标题与编号。页内小标题不编号。
]

= 从证据到结论

== 将证据组织成可以检验的论证

从研究问题出发，依次说明方法、证据和限制。

#two-columns(
  card(title: [证据])[
    说明数据来源、测量方式和分析过程。
  ],
  card(title: [结论])[
    明确结论适用的范围，以及仍然未知的部分。
  ],
)

== 从一段简洁的源码开始

```typ
#show: slides.with(
  title: [让想法清晰呈现],
  authors: "yousa-mirage",
)

= 从问题出发
== 每一页，讲清一个观点
```

了解 #link("https://typst.app")[Typst]，从 `#show: slides.with(...)` 开始。

== 代码也需要清晰的阅读节奏

```python
def describe(idea):
    # 从一个清晰的想法开始
    return {"title": idea, "steps": ["理解", "探索", "验证"]}

result = describe("Make ideas visible")
print(result)
```
