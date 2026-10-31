# Typst-Claude-PPT

个人使用的 Claude 浅色风格 Typst 幻灯片模板，需要 Typst 0.13.0 及以上。[可查看演示 PDF](examples/showcase.pdf)。

同时包含对应的 [Quarto 扩展](#在-quarto-中使用)，可以在 Quarto 中使用，将 Quarto 文稿直接渲染为使用本模板的 PDF 幻灯片。

## 本地使用

目前没有发布到 Typst Universe 的计划。推荐使用 [`typship`](https://github.com/sjfhsjfh/typship) 从 GitHub 下载安装包。

```sh
typship download https://github.com/yousa-mirage/typst-claude-ppt
```

`typship download` 会将包默认安装到本地的 `@local` 命名空间中，安装完成后即可在 Typst 中导入使用：

```typst
#import "@local/typst-claude-ppt:0.1.0": *
```

同时还需要安装一些字体，包括 Anthropic 系列和思源系列。具体如下，字体可从网络自行获取。

| 用途 | 字体链 |
| --- | --- |
| 正文、标题 | `Anthropic Serif Web Text` → `Source Han Serif SC` |
| 页脚、面板标题 | `Anthropic Sans Web Text` → `Source Han Sans SC` |
| 代码 | `Anthropic Mono` → `Source Han Serif SC` |
| 公式 | `Libertinus Math` → `Source Han Serif SC` |

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

- 封面始终展示；存在一级标题时默认生成目录，目录只包含一级标题。
- `= 一级标题` 独占章节页，按 `1 标题` 编号；`== 二级标题` 开始内容页，位于某个一级标题下时按 `1.1 标题` 编号。全文没有一级标题时，二级标题按 `1 标题`、`2 标题` 编号。参考文献不参与编号。
- 正文过长时自然续页，在标题栏右侧依次显示 `(I)`、`(II)` 等。可使用 `#pagebreak()` 主动分隔。
- 封面不显示页脚。后续页面默认显示页脚：左下角为 `主标题 | 作者`，右下角为 `当前页 / 总页数`。过长的页脚自动折叠。

### 配置

| 参数 | 默认值 | 说明 |
| --- | --- | --- |
| `title` | 必填 | 非空字符串或 Typst 文本内容 |
| `subtitle` | `none` | 可选副标题，字符串或内容 |
| `date` | `none` | 日期字符串或 `datetime`；`datetime` 显示为 YYYY-MM-DD |
| `authors` | `()` | 作者字符串或字符串数组，也可省略 |
| `ratio` | `16/9` | 只接受 `16/9` 和 `4/3` |
| `footer` | `true` | 控制封面之后的左侧页脚及右侧页码 |
| `toc` | `true` | 是否生成目录 |
| `accent` | `true` | 默认使用橙色强调色；设为 `false` 时关闭强调色 |

### 内容组件

从包入口按需导入：

```typst
#import "@local/typst-claude-ppt:0.1.0": card, callout, two-columns
```

| 写法 | 用途 |
| --- | --- |
| `#card(title: [标题])[内容]` | 带细边框的卡片，标题可省略 |
| `#callout(title: none)[内容]` | 带橙色侧线的提示区，可添加标题 |
| `#two-columns([左侧], [右侧])` | 等宽双栏，可放卡片或图片 |

## 在 Quarto 中使用

Quarto 1.10 及以上已支持 Typst 格式渲染，因此也可以使用该模板。完整写法和导出效果可参考 [Quarto 示例代码](examples/quarto.qmd) 和 [示例 PDF](examples/quarto.pdf)。

首先安装 `typst`、`quarto`、`typship` 和前文列出的字体。在自己的 Quarto 项目根目录中依次运行以下命令，安装 Typst 模板包和 Quarto 扩展：

```sh
typship download https://github.com/Yousa-Mirage/typst-claude-ppt
quarto add Yousa-Mirage/typst-claude-ppt
```

第一条命令将 Typst 包安装到本机的 `@local/typst-claude-ppt:0.1.0`；第二条命令将 Quarto 扩展安装到**当前项目**的 `_extensions/` 路径下。安装完成后，在项目中的 Quarto 文稿中配置 `format: claude-ppt-typst` 即可应用本模板。

以下为一个简单示例 `slides.qmd`：

```markdown
---
title: 主标题
subtitle: 副标题
author: 你的名字
date: 2026-10-31
format: claude-ppt-typst
---

# 章节标题

## 内容页

用 Markdown 撰写正文。

## 第二页

- 要点 1
  - 要点 2

其他正文
```

在项目根目录运行：

```sh
quarto render slides.qmd
```

生成的 PDF 为同目录下的 `slides.pdf`。

### 基本配置

- `title`、`subtitle`、`date` 对应模板元数据。
- `#` 开始章节页，`##` 开始内容页。编号、目录和续页标记沿用 Typst 模板的规则。
- 默认 `ratio: 16/9`、`toc: true`、`footer: true`、`accent: true`。可以在格式配置中覆盖：
  ```yaml
  format:
    claude-ppt-typst:
      ratio: 4/3
      toc: false
      footer: false
      accent: false
  ```
- 原生参考文献处理会将参考文献放在单独的内容页，可用 `reference-section-title` 修改标题。示例文稿展示了 `bibliography` 与 `[@typst-docs]` 引用的写法。

### Markdown 组件

提示框使用 `.callout`，卡片使用 `.card`：

```markdown
::: {.callout}
需要强调的结论。
:::

::: {.card}
用 **Markdown** 表达正文。
:::
```

提示框和卡片都可通过 `title` 属性或内部的第一个标题设置组件标题。

```markdown
::: {.callout-note}
### 下一步

- 明确研究问题。
- 收集对应证据。
:::

::: {.card title="研究结论"}
Quarto + Typst = 💖
:::
```

双栏使用 `.columns`，其中放置两个 `.column`。栏中可以继续嵌套提示框或卡片。

```markdown
::::: {.columns}
:::: {.column}
::: {.card title="问题"}
左栏内容。
:::
::::

:::: {.column}
::: {.card title="证据"}
右栏内容。
:::
::::
:::::
```

## 致谢

参考了 [diatypst](https://typst.app/universe/package/diatypst/) 的实现思路。
