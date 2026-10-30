#import "@local/typst-claude-ppt:0.1.0": slides, card, two-columns

#show: slides.with(
  title: [你的演示标题],
  subtitle: [用一句话介绍你的主题],
  authors: ("你的名字",),
  date: "2026-10-30",
  ratio: 16/9,
)

= 从问题出发

== 每一页，讲清一个观点

在这里写下你的核心观点。

- 第一项证据。
- 第二项证据。
- 一项明确的行动。

= 让想法成为行动

== 现在与下一步

#two-columns(
  card(title: [我们已经知道])[
    整理问题的背景与已有证据。
  ],
  card(title: [接下来要做])[
    提出一个可以验证的假设。
  ],
)
