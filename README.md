# typst-claude-ppt

个人使用的 Claude 浅色风格 Typst 幻灯片模板。需要 Typst 0.13.0 及以上。

[可查看演示 PDF](examples/showcase.pdf)。

## 在自己的文稿中使用

目前没有发布到 Typst Universe 的计划。推荐使用 [`typship`](https://github.com/sjfhsjfh/typship) 从 GitHub 下载安装包。

```sh
typship download https://github.com/yousa-mirage/typst-claude-ppt
```

`typship download` 会将包默认安装到本地的 `@local` 命名空间中，安装完成后即可在 Typst 中导入使用：

```typst
#import "@local/typst-claude-ppt:0.1.0": *
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

- 封面始终展示；存在一级标题时默认生成目录，目录只包含一级标题。
- `= 一级标题` 独占章节页，按 `1 标题` 编号；`== 二级标题` 开始内容页，位于某个一级标题下时按 `1.1 标题` 编号。全文没有一级标题时，二级标题按 `1 标题`、`2 标题` 编号。
- 正文过长时自然续页，在标题栏右侧依次显示 `(I)`、`(II)` 等。可使用 `#pagebreak()` 主动分隔。
- 封面不显示页脚。后续页面默认显示页脚：左下角为 `主标题 | 作者`，右下角为 `当前页 / 总页数`。过长的页脚自动折叠。

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
| `#callout(title: none)[内容]` | 带橙色侧线的提示区，可添加标题 |
| `#two-columns([左侧], [右侧])` | 等宽双栏，可放卡片或图片 |

## 使用字体

模板使用的字体如下：

| 用途 | 字体链 |
| --- | --- |
| 正文、标题 | `Anthropic Serif Web Text` → `Source Han Serif SC` |
| 页脚、面板标题 | `Anthropic Sans Web Text` → `Source Han Sans SC` |
| 代码 | `Anthropic Mono` → `Source Han Serif SC` |
| 公式 | `Libertinus Math` → `Source Han Serif SC` |

## 在 Quarto 中使用

`quarto` 开发书签中提供基础扩展，格式名为 `claude-ppt-typst`。需要 Quarto 1.10 及以上，按前文使用 `typship download` 安装 Typst 包，并在系统中安装所需字体。扩展直接调用 `@local/typst-claude-ppt:0.1.0`，与原生 Typst 文稿共用同一套样式。

在本仓库中运行：

```sh
quarto render examples/quarto.qmd
```

生成的文件为 `examples/quarto.pdf`，不会自动打开。[查看 Quarto 示例源码](examples/quarto.qmd)。

在其他项目中使用时，从 `quarto` 书签检出后，将本仓库的 `_extensions/claude-ppt` 目录复制到项目的 `_extensions/claude-ppt` 下。扩展不会自动安装 Typst 包。

将 `quarto` 书签推送到 GitHub 后，也可以在自己的 Quarto 项目目录中安装扩展：

```sh
quarto add Yousa-Mirage/typst-claude-ppt@quarto
```

保存下面的示例为 `slides.qmd`，运行 `quarto render slides.qmd` 即可生成同目录下的 `slides.pdf`。

最小文稿示例：

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

{{< pagebreak >}}

同一主题的续页。
```

- `title`、`subtitle`、`date` 对应模板元数据；Quarto 的 `author` 自动转换为模板的作者列表，也支持多个作者及 `name` 字段。
- `#` 开始章节页，`##` 开始内容页，`###` 及以下为页内标题。编号、目录和续页标记沿用 Typst 模板的规则。全文只有 `##` 时按 `1`、`2` 编号，不生成目录。
- 默认 `ratio: 16/9`、`toc: true`、`footer: true`。可以在格式配置中覆盖：

```yaml
format:
  claude-ppt-typst:
    ratio: 4/3
    toc: false
    footer: false
```

代码块使用 Typst 原生高亮。公式、图片和表格使用 Quarto 的常规写法；原生参考文献处理会将参考文献放在单独的内容页，可用 `reference-section-title` 修改标题。示例文稿展示了 `bibliography` 与 `[@typst-docs]` 引用的写法。

### Markdown 组件

使用带 class 的 fenced Div 调用模板组件，内部仍可写列表、代码、公式、链接和引用。

提示框使用 `.callout`，默认没有标题：

```markdown
::: {.callout}
需要强调的结论。
:::
```

也支持 Quarto 的 `.callout-note`、`.callout-tip`、`.callout-warning`、`.callout-important` 和 `.callout-caution`。它们统一使用模板的橙色提示框样式，不自动添加类型名称。PDF 中始终展开，不采用网页中的图标、折叠或外观选项。

卡片使用 `.card`。提示框和卡片都可通过 `title` 属性或内部的第一个标题设置组件标题；两者同时出现时，`title` 属性优先。组件标题不会参与幻灯片分页、编号或目录：

```markdown
::: {.callout-note}
### 下一步

- 明确研究问题。
- 收集对应证据。
:::

::: {.card title="研究结论"}
用 **Markdown** 表达正文。
:::
```

双栏使用 `.columns`，其中放置两个 `.column`。两栏等宽、顶部对齐，栏中可以继续嵌套提示框或卡片。省略 `width` 即可，也接受 `width="50%"`；其他比例和多于两栏的布局不在此组件的支持范围内。

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

嵌套 Div 时，外层使用更多冒号。提示框和卡片沿用 Typst 组件的完整面板布局，单个面板必须能放进一张内容页；内容太长时请拆为多页。

需要直接调用 Typst 时，仍可在原生块中通过 `claude` 命名空间访问组件：

````markdown
```{=typst}
#claude.callout[需要强调的结论。]
```
````

## 致谢

参考了 [diatypst](https://typst.app/universe/package/diatypst/) 的实现思路。
