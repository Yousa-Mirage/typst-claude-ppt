#import "../src/lib.typ": slides
#show: slides.with(title: [内容，自有秩序], authors: "yousa-mirage", toc: false)

== 用简洁的语言，组织复杂的信息

- 从一个值得回答的问题出发。
- 将证据放在观点附近。
  - 数据解释现象。
  - 案例帮助理解。
- 用明确的行动结束讨论。

== 让重要的话，留在视线中

#quote(attribution: [设计笔记])[
  好的表达让复杂的想法变得容易理解，也让下一步行动变得清晰。
]

了解 #link("https://typst.app")[Typst]，从 `#show: slides.with(...)` 开始。

== 用表格比较，用公式解释

#table(
  columns: (1fr, 1fr, 1fr),
  table.header([阶段], [关注点], [产出]),
  [理解], [定义问题], [共同目标],
  [探索], [比较方案], [可行路径],
  [验证], [收集反馈], [下一步行动],
)

$ "平均值" = 1/n sum_(i=1)^n x_i $

== 代码也需要清晰的阅读节奏

```python
def describe(idea):
    # 从一个清晰的想法开始
    return {"title": idea, "steps": ["理解", "探索", "验证"]}

message = describe("Make ideas visible")
print(message)
```
