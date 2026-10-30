---
status: in progress
---

# Claude 浅色风格 Typst 幻灯片模板：调研与实现计划

更新：2026-10-30。已开始实现；以下“最新实施约束”优先于初始规划。

## 最新实施约束（用户于实现开始时确认）

- 文稿配置只保留 `title`、`subtitle`、`date`、`authors`、`ratio`、`footer`、`toc`。
- 固定 Claude 浅色主题与 diatypst medium 尺寸（高 10.5cm、space 1.6cm），不提供 layout、字体或颜色配置。
- `ratio` 只接受 `16/9`（默认）和 `4/3`。
- 永远生成封面，无 `first-slide` 开关；目录 `toc` 默认开启。
- `footer` 默认开启；左下角为“作者 | 主标题”，右下角为数字“当前页 / 总页数”。所有页面保持相同页码语义。
- 无 count、footer-title、footer-subtitle、theme 等配置。下面原始规划中更宽泛的 API 设想均已收敛。

### 实施进度

- [x] 固定浅色颜色、三种 Anthropic 字体链、medium 尺寸与包最低编译版本。
- [x] 封面、目录、标题分页、章节、续页与统一页脚。
- [x] 原生元素样式与轻量内容组件。
- [ ] 独立本地包模板、使用文档与真实样张。
- [ ] 两种比例、分页、非法参数及包边界的编译和视觉验证。

验证记录：核心 API 已通过 `python3 scripts/check.py`，覆盖 16:9 / 4:3、目录开关/长目录/无章节回退、封面独页、空内容页、续页、作者缺省、页脚省略号和非法参数。已目视检查两种比例、两行标题与封面。标题超过两行会给出明确错误；页脚长文字按宽度省略。change：`xnsmmylo`（固定主题）、`kospzorp`（分页与页脚）。

原生元素样式：`pnpwzuxr`，已增加列表、枚举、术语、引用、三线表、公式、图注、链接和代码块；自有 `claude.tmTheme` 提供沉稳的语法颜色。`examples/elements.typ` 已编译和目视检查，核心分页回归通过。

内容组件：`mxtzsuuv`，导出 `card`、`callout`、`two-columns`、`badge`、`message`、`artifact`。大于整张内容页的面板会明确报错。10 页真实内容样张 `examples/showcase.typ` 在 16:9 / 4:3 均为 10 页，已检查两栏卡片、对话、Artifact 和代码页。

本地包：`rpnuqqxw`，新增 `[template]`、独立 starter、Makefile。`make package` 只安装到项目的 `.packages/`，不修改全局 Typst 配置。已在仓库以外的临时目录验证 `typst init`、独立编译、包内语法主题和调用方图片。

## 目标与范围

制作主要供个人使用的 Typst 模板包，以 Claude Web 的浅色视觉语言为方向，以本机 `claude.css` 为具体设计参考，以 diatypst 的标题式幻灯片写作为交互参考。

已确认的约束：

- 仅实现浅色模式；不提供暗色配置或预留主题切换框架。
- 优先使用本机 Anthropic 字体，中文回退至思源宋体。
- 使用 jj 管理版本；每个功能修改先创建独立 change，并填写描述。
- 本轮交付调研结论和实现规划，保持 `src/lib.typ` 与 `typst.toml` 的现有内容。
- 主要供个人使用，优先小 API、低依赖、本地复用和可直接修改的源码。

当前设计假设：16:9，Typst 源码编写，主要导出 PDF 幻灯片，PNG 用于预览。用户尚未单独确认导出格式；若需要可编辑 `.pptx`，必须另行设计转换方案，Typst 的 PDF/PNG 导出不能提供原生 PowerPoint 对象。

规划记录暂置于 `_dev/todos/pending/`，后续可按用户偏好迁移。

## 已完成的理解

- [x] 阅读用户引用的 `/Users/yousa-mirage/.codex/RTK.md`。
- [x] 检查项目、Typst 编译器、字体清单和 jj 状态。
- [x] 找到并阅读本机 Claude 浅色 Typora 主题。
- [x] 阅读 diatypst 的清单、README 和实现，核查到已发布的 0.9.3。
- [x] 用 Typst 0.15.1 编译并目视检查三种字体角色的中英文混排小样。
- [x] 编译 diatypst 普通示例和长内容示例，核查章节页、内容页及续页。
- [x] 为初始骨架补充 jj 描述，并新建本次规划 change。
- [x] 将只需浅色模式的要求纳入范围。
- [ ] 实现下列里程碑，并随每个 change 更新本文。

## 项目现状

初始文件只有：

```text
typst.toml       # 已声明包名、0.1.0 和 src/lib.typ 入口
src/lib.typ      # 空文件
```

本机编译器为 `typst 0.15.1 (unknown commit)`。建议第一版以 0.15.1 为最低兼容版本，在清单中声明；若以后需要旧版本，再实际验证后降低要求。

清单目前没有 `[template]`，因此尚不能提供开箱即用的 `typst init` 模板。已有 `disciplines = ["sociology"]` 不是通用幻灯片模板的必要限制，封装阶段再决定是否移除。个人包暂不要求发布到 Universe，也不擅自选定项目许可证。

版本状态：

- `uprpospm`：`chore: initialize Typst presentation package skeleton`，保存原有两个文件。
- `ryzlkvuz`：`docs: research and plan light Claude-style presentation template`，本次规划。
- 初期 `.git/objects` 写入受到环境限制；用户调整权限后，jj 已能正常创建 change，无需替换仓库或另建版本库。

## 浅色主题的可复用设计语言

参考文件：`/Users/yousa-mirage/Library/Application Support/abnerworks.Typora/themes/claude.css`。

其 SHA-256 为 `1137443273066279f648079544729f45841ee1ebec1d11f5cc54d306f6424a4e`，用于定位本次参考版本。模板运行不读取这个外部文件，也不复制整份 CSS。

| 角色 | 浅色 CSS 来源 | 模板中的用途 |
| --- | --- | --- |
| 页面底色 | `#FAF9F5` | 所有默认页面的暖米白画布 |
| 主要文字 | `#141413` | 标题、正文、重要数据 |
| 次级文字 | `#3D3D3A` | 元信息、说明、辅助标签 |
| 弱背景 | `#F0EEE6`、`#E8E6DC` | 卡片、提示区、用户消息底色 |
| 细边框 | `#1F1E1D` 的低透明度版本 | 卡片边界、分隔线、代码框 |
| 强调色 | `#D97757` | 小面积图形、列表标记、强调线 |
| 行内代码色 | `#8A2424` | 与正文区分的代码文字 |
| 圆角 | CSS 的 8 / 12 / 20px 层级 | 按幻灯片尺寸重新标定的三级圆角 |

映射原则：

1. 用暖底色、Serif 大标题、舒展正文、细边框和克制的圆角形成一致风格。
2. 正文延续主题的 Serif；Sans 用于页码、标签、面板标题和其他界面文字；Mono 用于代码。
3. 默认内容页保持干净；对话和 Artifact 面板作为可选组件。浏览器地址栏、侧栏、输入按钮等不占据每一页。
4. CSS 的布局、hover/focus、窗口菜单、滚动条、阴影和打印补丁不直接移植到 PDF。
5. 第一版优先平面层次与细边框，暂不实现复杂模糊阴影或纹理。
6. 不默认加入 Claude 商标或复制官方 Logo；后续如需要可通过用户传入的图像内容扩展。

颜色计算结果：`#141413` / 背景约 17.50:1，`#3D3D3A` 约 10.34:1，`#D97757` 约 2.96:1。橙色不用于小号文字和承载信息的细字；大标题仍优先深色。小号链接可沿用深色文字加橙色下划线，或另选经检查的深橙色。

这是以用户浅色主题为依据的设计，不宣称逐像素复现当前 Claude Web。

## 字体方案与已验证边界

Typst 实际识别的族名如下，必须使用族名而非文件名或 CSS 别名：

| 角色 | 首选 | 回退 |
| --- | --- | --- |
| 标题与正文 | `Anthropic Serif Web Text` | `Source Han Serif SC` |
| 界面文字 | `Anthropic Sans Web Text` | `Source Han Serif SC` |
| 代码 | `Anthropic Mono Web` | `Source Han Serif SC` |
| 数学公式 | `Libertinus Math` | 保留 Typst 数学排版机制 |

每个 Anthropic 族在当前编译器清单中只有 Normal / 400；中文思源宋体有多个字重。不能将 CSS 的 430、530 等权重视为本机存在的真实字体实例。标题主要依赖尺寸与留白，强调字重需要检查实际渲染，不能承诺原生 Anthropic Bold/Italic。

拟使用字体描述符，将中文共用标点交给 CJK 字体：

```typst
font: (
  (name: "Anthropic Serif Web Text", covers: "latin-in-cjk"),
  "Source Han Serif SC",
)
```

该描述符只处理特定中西文共用标点，不是任意字符范围过滤器。使用 `lang: "zh", region: "CN"`，保留 Typst 默认中西文间距，不逐字插入空格。

已编译并目视检查中文、English、数字、中文引号、书名号、括号、粗体和斜体混排，未见缺字或方框。小样关闭了系统最后回退，以便检查指定字体链。尚未核查每个输出 glyph 的具体字体来源，也未验证所有罕见汉字。

代码中的汉字会回退为宋体，不能保证与西文代码严格等宽。V1 不依赖中文字符的列宽来对齐代码；中文 ASCII 表格等特殊需求日后单独处理。

字体文件仅从系统读取，不随包复制。没有安装 Anthropic 字体的机器仍可使用思源宋体；缺少思源宋体时，由使用者安装或明确覆盖字体参数。跨机器可复现需记录编译器和字体版本。

## 对 diatypst 的理解与取舍

本轮以 `diatypst:0.9.3` 的发布目录为主要参考，清单要求 Typst >= 0.12.0，入口为约 491 行的单个 `lib.typ`，许可证为 MIT-0。

主要机制：

- `#show: slides.with(...)` 设置文档、画布、页眉页脚和元素 show rules。
- `= 一级标题` 生成章节页；`== 二级标题` 通过弱分页开始内容页。
- 页眉通过 `query(heading.where(level: 2))` 查找当前页及之前最近的标题，续页会附加编号。
- 页码取物理 PDF 页数；提供数字、圆点、章节圆点等模式。
- 内置封面、目录、代码、术语、列表、表格、引用与链接样式。

验证结果：

- 普通夹具：封面 + 两个章节 + 三个内容标题，实际 6 页，标题所在页符合预期。
- 将一页内容改为 `lorem(700)`：实际生成 9 页，第二章移至第 8 页，最后一页位于第 9 页。
- 目视检查了普通章节页、内容页、长内容页和末页。
- 这证明其流式续页在当前夹具中可用，不代表所有表格、不可分块内容均能自动适配。

建议借鉴写作接口和分页思路，独立实现包，不把 diatypst 作为运行依赖：

- Claude 的边框、背景、正文层次需要独立语义颜色；从单一主题色 `.lighten()` 无法得到参考 CSS 的各层颜色。
- diatypst 的页眉、计数器、彩色章节栏与封面尺寸高度耦合，外层覆盖容易产生规则优先级和边距问题。
- 本项目只需要浅色个人模板，独立的薄实现更易维护，初版可保持零第三方 Typst 包依赖。
- 若实现时直接借用代码片段，记录来源并保留相应归属说明；当前只在临时目录保存了参考源码供验证。

## 拟定架构与写作 API

按职责拆分少量模块，`src/lib.typ` 为唯一公开导入入口：

```text
src/
  lib.typ           # 汇总公开 API
  theme.typ         # 浅色 token、字体角色、尺寸参数
  slides.typ        # 文档设置、标题分页、封面、章节、续页、页脚
  elements.typ      # 正文、列表、引用、表格、代码、链接的样式
  components.typ    # 卡片、提示、布局与可选对话/Artifact
template/
  main.typ          # typst init 后可独立使用的起点
examples/
  showcase.typ      # 真实中英文内容的视觉样张
tests/
  fixtures/         # 分页、配置和资源路径等边界夹具
scripts/
  check.*           # 编译及少量结构检查，按实际需要选择语言
README.md
typst.toml
```

不一次性创建空模块；随着相应功能落地再拆分。构建产物统一进入忽略的目录。

主写作方式拟定为：

```typst
#import "@local/typst-claude-ppt:0.1.0": slides, card
#show: slides.with(
  title: [让想法清晰呈现],
  subtitle: [A Claude-inspired presentation],
  authors: ("yousa-mirage",),
  date: "2026-10-30",
)

= 问题与方法

== 核心观点

每页围绕一个主要观点展开。

#card(title: [设计原则])[
  暖色画布、清晰层级、适量留白。
]

=== 进一步说明

三级及以下标题保留为页内小标题。
```

这是拟定 API 示例，不是已经可编译的实现。首批参数包括标题、可选副标题/作者/日期、比例、正文字号、强调色、三类字体、封面开关和页脚开关。目录默认关闭；第一版不提供暗色、圆点导航、多套外观、动画或演讲者备注系统。

主题参数由文档入口解析为统一配置，各模块共享同一套结果。独立组件通过局部样式上下文读取当前配置，避免全局可变状态、配置传参遗漏，以及组件与主文档使用不同颜色/字体。具体采用上下文样式或 Typst `state` 的方式在最小实现中验证后决定。

## 页面、分页与组件约束

建议初始画布为 16:9，高 7.5in、宽由比例计算；默认正文约 22–24pt，内容标题约 38–42pt，封面约 56–64pt。以上为首轮视觉调参起点，最终以实际中英文样张决定。

页面行为：

- 自动封面可关闭；标题允许一至两行，作者和日期可省略，省略后不留下空占位。
- 一级标题独占章节页；二级标题开始内容页；三级及以下为页内标题。
- 页眉、正文、页脚各自预留空间，不依赖负间距把内容推到位置。
- 默认使用简洁物理页码 `当前 / 总数`；封面和章节页隐藏显示，但仍计入 PDF 总页数。
- 流式正文超长允许续页，重复当前标题并标注“续”；不默认缩小整页字号，也不默默裁切。
- 手动 `pagebreak()` 可用于主动拆页；相邻标题、第一张内容页、无章节文档和末页都需要验证空白页与样式恢复。
- 不把任意内容提前塞进固定高度 box 来伪造一页；不可分卡片等对象仍可能放不下，必须靠夹具检查和内容约束处理。

组件分两批：

| 优先级 | 内容 | 预期形式 |
| --- | --- | --- |
| 第一批 | 封面、章节、普通内容页 | 完整文稿的基础 |
| 第一批 | 列表、引用、表格、行内/块代码、图片/图注、公式 | 继承 Typst 原生写法并应用风格 |
| 第一批 | `card`、`callout`、`two-columns`、`badge` | 最少数量的通用内容组件 |
| 第二批 | 用户消息、助手回复、Artifact 面板 | Claude UI 特征明显的可选组合组件 |
| 按样张需要 | 大字观点/收尾页 | 优先组合现有组件，避免增加重复 API |

两栏使用 `(1fr, 1fr)` 等分配与显式 gutter，不用双 `50%` 加间距造成超宽。图片由调用方传入 `image(...)` 内容，或在需要文件参数时接受调用方创建的 `path(...)`，不把调用方的相对路径误解为包内路径。

## 分阶段实施与 jj change 划分

每个功能必须在开始修改前 `jj new -m '...'`；完成该功能的验证后检查 `jj diff`，更新本文，再进入下一个 change。变更范围超出描述时同步改写描述，不把所有实现累积到一个 change。

| 顺序 | 拟定描述 | 工作与验收 |
| --- | --- | --- |
| 0 | `docs: research and plan light Claude-style presentation template` | 当前 change；调研、方案、范围、记录依据 |
| 1 | `feat: add light theme tokens and Anthropic font roles` | 颜色/尺寸/字体入口、最低编译版本、基础中英文小样；无缺字与未知字体警告 |
| 2 | `feat: add heading-driven slides and page navigation` | 画布、封面、章节、内容、续页、页脚；页数和标题位置正确，无意外空白页 |
| 3 | `feat: style native content elements for presentations` | 列表/引用/表格/代码/图片/公式/链接；检查长代码、表头与中英文标点 |
| 4 | `feat: add cards callouts and column layouts` | 通用组件和少量参数；检查长标题、长卡片与栏间距 |
| 5 | `feat: add optional conversation and artifact panels` | 可选 Claude UI 组件；验证真实内容的区分与文字可读性 |
| 6 | `feat: add reusable local package starter` | `[template]`、独立初始化、`@local` 使用和资源路径验证 |
| 7 | `docs: add usage guide and verified showcase` | 中文快速上手、参数/字体说明、真实样张；最终视觉回归与运行命令 |

若某一步包含独立功能或需要单独修复，应继续拆 change；小步的功能验证与对应功能放在同一 change，避免先堆功能、最后集中补验证。

第一轮可评审成果应在步骤 2 后出现：包含封面、章节、普通中英文内容页的短 PDF，先判断视觉方向，再扩展组件。这样能尽早发现字号、中文宋体密度和 Claude 风格是否符合预期。

## 验证与完成标准

采用实际编译、必要结构断言和渲染检查，不为每个颜色常量编写镜像测试。

- 编译最小文档与真实 showcase，PDF 和 PNG 均需实际导出。
- 覆盖封面开/关、无章节、多个章节、相邻标题、手动分页、自动续页；用 Typst 0.15.1 的 `eval --in` 查询标题页位置，并核对物理页数。
- 检查首尾页、长标题、含中文标点的换行、代码长行、较宽表格、长卡片、两栏和图片；编译成功不等同于没有出界或重叠。
- 代表性页面查看整页布局，必要时放大检查文字；以实际内容而非全 Lorem ipsum 作为最终验收素材。
- 默认参数与至少一组字号/强调色/字体覆盖配置均能工作，所有组件继承同一配置。
- 在独立临时目录构建 `packages/local/typst-claude-ppt/0.1.0/`，通过 `--package-path` 导入，检查包根隔离；不只测试 `../src/lib.typ` 导入。
- 从模板复制/初始化出的独立项目能编译；调用方图片路径正确，不借扩大 `--root` 掩盖路径问题。
- 文档中给出系统字体依赖与安装/编译命令，不全局安装包或改动字体目录来完成测试。
- 不宣称支持尚未验证的 HTML、可编辑 PPTX、旧 Typst 版本、动画、自动缩放或全字符字体覆盖。

本轮临时验证材料位于 `/private/tmp/claude-ppt-research.9mYycL/`：字体小样、diatypst 0.9.3 参考源码、普通/长文夹具及渲染图。它们未加入项目，也不作为包运行依赖；临时目录可能被系统清理，上述结论已记录在本文。

## 参考来源

- 用户本机浅色主题：`claude.css`，见上文绝对路径及摘要。
- [diatypst 0.9.3 发布目录](https://github.com/typst/packages/tree/main/packages/preview/diatypst/0.9.3)
- [diatypst 0.9.3 实现](https://github.com/typst/packages/blob/main/packages/preview/diatypst/0.9.3/lib.typ)
- [diatypst 0.9.3 清单](https://github.com/typst/packages/blob/main/packages/preview/diatypst/0.9.3/typst.toml)
- [Typst 字体文档](https://typst.app/docs/reference/text/text/)
- [Typst 包清单规范](https://github.com/typst/packages/blob/main/docs/manifest.md)

## 决策记录

### 2026-10-30：浅色范围与独立实现

用户明确只需要浅色模式。采用浅色单套 token，优先原生 Typst，参考 diatypst 的标题式写作，自行实现页面与组件，暂不添加外部 Typst 包依赖。

### 2026-10-30：字体与写作边界

本机已验证 Anthropic 三类字体和思源宋体可用于中英文混排。使用实际族名，避免 CSS 的 Mono Variable 别名。当前按 PDF 幻灯片规划，PPTX 仍为未确认的独立导出要求。

### 2026-10-30：版本控制恢复

环境权限调整后，成功描述初始骨架并创建规划 change。后续每个功能独立新建 change；无须新建仓库、复制 `.git` 或更换版本控制方式。
