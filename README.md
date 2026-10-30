# typst-claude-ppt

个人使用的 Claude 浅色风格 Typst 幻灯片模板。需要 Typst 0.13.0 及以上。

[可查看演示 PDF](examples/showcase.pdf)。

## 在自己的文稿中使用

目前没有发布到 Typst Universe 的计划。推荐使用 [`typship`](https://github.com/sjfhsjfh/typship) 从 GitHub 下载安装包。

```sh
typship download https://github.com/yousa-mirage/typst-claude-ppt
```

## 文稿写法

```typst
#import "@local/typst-claude-ppt:0.1.0": slides, card

#show: slides.with(
  title: [主标题],
  subtitle: [副标题],
  authors: ("你的名字",),
  date: "2026-10-30",
)

= 章节标题

== 使用 `==` 开始内容页

先写结论，再用证据支持它。

#card(title: [下一步])[
  把观点变成一项具体的行动。
]

== 第二页

这是第二页的内容。
```

- 封面始终展示，之后默认生成目录。
- `= 一级标题` 独占章节页，默认编号为 `1 标题`；`== 二级标题` 开始内容页，默认编号为 `1.1 标题`。三级及以下标题留在当前页，不编号。
- 目录优先列出章节；没有章节时，列出内容页。没有可列出的标题时，不生成空目录页。条目可以点击跳转，长目录自动续页。
- 正文过长时自然续页，顶部重复当前标题和原编号，在标题栏右侧依次显示 `(I)`、`(II)` 等。可使用 `#pagebreak()` 主动分隔。
- 封面不显示页脚。后续页面默认显示页脚：左下角为 `主标题 | 作者`，右下角为 `当前页 / 总页数`。
- 多位作者使用顿号连接；未填写作者时只显示主标题。过长的页脚自动折叠。

## 配置

只提供以下文稿配置：

| 参数 | 默认值 | 说明 |
| --- | --- | --- |
| `title` | 必填 | 非空字符串或 Typst 文本内容 |
| `subtitle` | `none` | 可选副标题，字符串或内容 |
| `date` | `none` | 日期字符串或 `datetime`；`datetime` 显示为 YYYY-MM-DD |
| `authors` | `()` | 作者字符串或字符串数组，也可省略 |
| `ratio` | `16/9` | 只接受 `16/9` 和 `4/3` |
| `footer` | `true` | 控制封面之后的左侧页脚及右侧页码 |
| `toc` | `true` | 是否生成目录 |

## 内容组件

从包入口按需导入：

```typst
#import "@local/typst-claude-ppt:0.1.0": card, callout, two-columns
```

| 写法 | 用途 |
| --- | --- |
| `#card(title: [标题])[内容]` | 带细边框的卡片，标题可省略 |
| `#callout(title: [提示])[内容]` | 带橙色侧线的提示区 |
| `#two-columns([左侧], [右侧])` | 等宽双栏，可在两栏中放卡片或图片 |

## 使用字体

模板使用的字体如下：

| 用途 | 字体链 |
| --- | --- |
| 正文、标题 | `Anthropic Serif Web Text` → `Source Han Serif SC` |
| 页脚、面板标题 | `Anthropic Sans Web Text` → `Source Han Sans SC` |
| 代码 | `Anthropic Mono` → `Source Han Serif SC` |
| 公式 | `Libertinus Math` → `Source Han Serif SC` |

## 致谢

参考了 [diatypst](https://typst.app/universe/package/diatypst/) 的实现思路。
