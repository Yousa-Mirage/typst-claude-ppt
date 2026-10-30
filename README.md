# typst-claude-ppt

一个供个人使用的 Claude 浅色风格 Typst 幻灯片模板。暖米白画布、炭黑文字、陶土橙点缀，西文优先使用 Anthropic 字体，中文回退至思源宋体。无第三方 Typst 包依赖。

![两栏卡片与提示区样张](docs/preview.png)

## 先看效果

需要 Typst **0.15.1 或更新版本**。在仓库目录执行：

```sh
make demo       # build/showcase.pdf 与 build/showcase-4x3.pdf
make preview    # 同时生成逐页 PNG
```

示例源文件：

- [`examples/minimal.typ`](examples/minimal.typ)：最小完整文稿。
- [`examples/showcase.typ`](examples/showcase.typ)：10 页样张，包含卡片、表格、对话和 Artifact。
- [`examples/elements.typ`](examples/elements.typ)：列表、引用、公式与代码。

也可以直接编译：

```sh
typst compile --root . examples/showcase.typ build/showcase.pdf
typst compile --root . --input ratio=4:3 examples/showcase.typ build/showcase-4x3.pdf
```

示例中的 `--input ratio=4:3` 只是 showcase 入口选择比例的方式。模板 API 中使用数值 `ratio: 4/3`。

## 在自己的文稿中使用

先将包复制到项目的 `.packages/`，再创建一份独立文稿：

```sh
make package
typst init --package-path "$PWD/.packages" @local/typst-claude-ppt:0.1.0 build/my-talk
typst compile --package-path "$PWD/.packages" build/my-talk/main.typ build/my-talk.pdf
```

实时预览：

```sh
typst watch --package-path "$PWD/.packages" build/my-talk/main.typ build/my-talk.pdf
```

以上命令在仓库目录运行，不修改系统 Typst 配置。若把文稿移到其他位置，继续传入这个包目录的绝对路径。修改包源码后重新运行 `make package`，再编译自己的文稿。

已有本地 Typst 包目录时，也可以运行 `make package PACKAGE_ROOT=/你的/包目录`，目录内会生成 `local/typst-claude-ppt/0.1.0/`。项目暂未发布到 `@preview`。

## 文稿写法

```typst
#import "@local/typst-claude-ppt:0.1.0": slides, card

#show: slides.with(
  title: [让想法清晰呈现],
  subtitle: [A quieter space for better ideas.],
  authors: ("你的名字",),
  date: "2026-10-30",
)

= 从问题出发

== 每一页，讲清一个观点

先写结论，再用证据支持它。

#card(title: [下一步])[
  把观点变成一项具体的行动。
]

=== 页内小标题

继续展开这一页的内容。
```

- 封面始终展示，之后默认生成目录。
- `= 一级标题` 独占章节页，`== 二级标题` 开始内容页，三级及以下标题留在当前页。
- 目录优先列出章节；没有章节时，列出内容页。没有可列出的标题时，不生成空目录页。条目可以点击跳转，长目录自动续页。
- 正文过长时自然续页，顶部重复当前标题并标记“续”。可使用 `#pagebreak()` 主动分隔。
- 所有页面默认显示页脚：左下角为 `作者 | 主标题`，右下角为 `当前页 / 总页数`。封面、目录、章节和续页均计入总数。
- 多位作者使用顿号连接；未填写作者时只显示主标题。过长的页脚使用省略号，避免挤压页码。

## 配置

只提供以下文稿配置：

| 参数 | 默认值 | 说明 |
| --- | --- | --- |
| `title` | 必填 | 非空字符串或 Typst 文本内容 |
| `subtitle` | `none` | 可选副标题，字符串或内容 |
| `date` | `none` | 日期字符串或 `datetime`；`datetime` 显示为 YYYY-MM-DD |
| `authors` | `()` | 作者字符串或字符串数组，也可省略 |
| `ratio` | `16/9` | 只接受 `16/9` 和 `4/3` |
| `footer` | `true` | 统一控制左侧页脚及右侧页码 |
| `toc` | `true` | 是否生成目录 |

固定使用 Claude 浅色主题和 medium 画布：高 10.5cm，宽由比例决定。正文 12pt，内容标题 19pt。字体、颜色、布局档位、计数器类型和封面开关不作为模板配置。

例如，关闭目录并使用 4:3：

```typst
#show: slides.with(title: [我的演示], authors: "作者", ratio: 4/3, toc: false)
```

## 内容组件

从包入口按需导入：

```typst
#import "@local/typst-claude-ppt:0.1.0": card, callout, two-columns, badge, message, artifact
```

| 写法 | 用途 |
| --- | --- |
| `#card(title: [标题])[内容]` | 带细边框的卡片，标题可省略 |
| `#callout(title: [提示])[内容]` | 带橙色侧线的提示区，默认标题为“提示”；`title: none` 隐藏标题 |
| `#two-columns([左侧], [右侧])` | 等宽双栏，可在两栏中放卡片或图片 |
| `#badge[标签]` | 小号圆角标签 |
| `#message[问题]` | 右侧用户消息 |
| `#message(role: "assistant")[回答]` | 左侧助手回复 |
| `#artifact(title: [成果标题])[内容]` | 带标题栏的成果面板 |

列表、编号、引用、表格、原生 `figure` 图注、数学公式、链接、行内代码和代码块均已应用主题。表格首行使用弱背景，语义表头建议使用 `table.header(...)`。代码块支持语法配色及自然换行。

图片直接在自己的文稿中加载，再作为内容传入组件：

```typst
#card(title: [研究结果])[
  #figure(
    image("assets/result.png", width: 80%, alt: "结果图的说明"),
    caption: [研究结果],
  )
]
```

## 字体与内容边界

本机需要安装以下字体，使用 `typst fonts` 查看编译器实际识别的族名：

| 用途 | 字体链 |
| --- | --- |
| 正文、标题 | `Anthropic Serif Web Text` → `Source Han Serif SC` |
| 标签、页脚、面板标题 | `Anthropic Sans Web Text` → `Source Han Serif SC` |
| 代码 | `Anthropic Mono Web` → `Source Han Serif SC` |
| 公式 | `Libertinus Math` → `Source Han Serif SC` |

字体不随包分发。当前 Anthropic 系统字体只有 Regular 实例，粗体/斜体的效果由编译器及实际字体决定。中文代码回退至宋体，不能用字符数量假定中西文等宽。

内容标题最多两行，过长会明确报错；建议将解释性文字放入正文。卡片、提示和 Artifact 是完整面板，过高会提示拆页。普通正文与长表格可自然续页，复杂内容仍建议检查逐页预览。

连续 24 字符以上的代码 token 会加入零宽换行机会，避免长标识符或 URL 越界。从 PDF 复制这类代码可能包含零宽空格，执行代码请使用原始源码。

输出以 PDF 为主，也可导出逐页 PNG/SVG；没有可编辑 PowerPoint、动画或演讲者备注导出功能。

## 验证与开发

```sh
make check
```

检查需要 Python 3.9+、Typst 和 Poppler 的 `pdfinfo` / `pdftotext`。覆盖比例、页码/页脚、目录开关与续页、空内容页、日期/作者、两行标题、代码边界、组件错误路径，以及仓库外独立项目的包导入、初始化和图片路径。两种比例的样张都应为 10 页。

开发使用 jj，每项功能先新建 change 并写明描述：

```sh
jj new -m 'feat: describe the next feature'
```

设计参考：个人 Claude 浅色 Typora 主题，以及 [diatypst 0.9.3](https://github.com/typst/packages/tree/main/packages/preview/diatypst/0.9.3) 的标题式写作和分页思路。本包独立实现，不依赖 diatypst。
