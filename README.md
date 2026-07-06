# edu-radar · 教育优惠 & edu 邮箱申请查询 Skill

![](https://img.shields.io/badge/skill-edu--radar-blue?style=flat-square)
![](https://img.shields.io/badge/articles-249-green?style=flat-square)
![](https://img.shields.io/badge/refresh-weekly-orange?style=flat-square)
![](https://img.shields.io/badge/install-npx%20skills-black?style=flat-square)
![](https://img.shields.io/badge/license-MIT-lightgrey?style=flat-square)

> 像雷达一样扫描教育优惠——「Replit 有没有学生折扣？」「美国哪些大学能申请 edu 邮箱？」一问就答。

一个 agent skill，把 [edumails.cn](https://www.edumails.cn) 上 **249 篇**教育邮箱相关图文教程索引成可检索的知识库，让 Claude Code、Codex、ZCode 等 AI 助手能精准回答两类问题：

1. **优惠查询** —— 某个产品/网站有没有教育优惠、学生折扣、免费教育版（Replit、Notion、Figma、JetBrains、GitHub Copilot、ChatGPT、Grok、Gemini、MATLAB、Adobe、Perplexity …）
2. **edu 邮箱申请** —— 美国/加拿大/澳洲/德国/日本/台湾/越南等地哪些院校能申请 edu 邮箱，以及具体申请方法（学校官网、申请入口、邮箱后缀、审核速度、附赠权益）

---

## ✨ 特性

- **全覆盖索引** —— 收录 edumails.cn 两个核心分类共 249 篇教程：`/us`（150+ 产品优惠）+ `/edu`（70+ 所美国院校及海外院校的 edu 邮箱申请方法）
- **三种查询模式** —— 正向（某产品有无优惠）、反向（edu 邮箱能享受哪些产品）、申请（某大学 edu 邮箱怎么拿）
- **自动每周刷新** —— 内置 `refresh.sh` + macOS launchd 定时任务，每周一 03:00 自动增量抓取新内容
- **渐进式加载** —— catalog 索引常驻，详情按需读取，不会撑爆上下文
- **基于事实作答** —— 只依据收录内容回答，不编造，附来源链接

---

## 📦 安装

### 方式一：用 `npx skills`（推荐）

通过 [skills](https://github.com/vercel-labs/skills) CLI 一键安装，自动适配 Claude Code、Codex、Cursor、ZCode、OpenCode 等 70+ agent：

```bash
npx skills add dingyi/dingyi-edu-radar-skill
```

CLI 会自动检测你正在使用的 agent，把 skill 装到对应目录（如 Claude Code 的 `~/.claude/skills/`、ZCode 的 `~/.agents/skills/` 等）。

### 方式二：手动克隆

如果你不想用 CLI，也可以直接 clone 到对应 agent 的 skills 目录：

```bash
# Claude Code / Codex / ZCode 通用路径
git clone https://github.com/dingyi/dingyi-edu-radar-skill.git ~/.agents/skills/dingyi-edu-radar
```

或放到项目级目录（仅当前项目生效）：

```bash
git clone https://github.com/dingyi/dingyi-edu-radar-skill.git your-project/.agents/skills/dingyi-edu-radar
```

> Skill 发现优先级：`.zcode/skills/` > `.agents/skills/` > `~/.zcode/skills/` > `~/.agents/skills/`。

---

## 🚀 使用

安装后，在 Claude Code / Codex / ZCode 里直接用自然语言提问，skill 会自动触发：

```
Replit 有教育优惠吗？
Figma 学生怎么免费用？
edu 邮箱能享受哪些 AI 编程工具的优惠？
美国有哪些大学可以申请 edu 邮箱？
特拉华技术社区学院的 edu 邮箱怎么申请？
```

也可以用斜杠命令强制加载：

```
/dingyi-edu-radar 印第安纳大学的校友 edu 邮箱怎么申请
```

### 示例输出

> **Q：Replit 有教育优惠吗？**
>
> ✅ Replit Core 用 `.edu` 邮箱验证后 **5 折，$10/月**（原价 $20/月）。
> - 认证地址：https://replit.com/edu/students
> - 必须用美国 .edu 邮箱注册；登录后点 "Claim student discount" → 选 Core → 完成支付
> - 来源：https://www.edumails.cn/replit.html

---

## 📂 项目结构

```
dingyi-edu-radar-skill/
├── README.md
├── LICENSE
└── skills/
    └── dingyi-edu-radar/
        ├── SKILL.md            # skill 主文件（触发条件 + 查询工作流）
        ├── catalog.json        # 249 条索引（slug / title / kw / file）
        ├── CATALOG.md          # 人类可读目录
        ├── scripts/
        │   ├── refresh.sh      # 内容刷新脚本（增量 / 全量）
        │   └── refresh.log     # 刷新日志（运行后生成）
        └── references/         # 249 篇教程，按需读取
            ├── replit.md
            ├── notion.md
            ├── figma.md
            └── ...
```

---

## 🔄 自动刷新（可选）

本 skill 内置每周自动刷新能力（macOS）。用 `bash` 调用，无需可执行权限：

```bash
# 手动增量刷新（只拉新文章）
bash skills/dingyi-edu-radar/scripts/refresh.sh

# 全量重建
bash skills/dingyi-edu-radar/scripts/refresh.sh --full
```

注册成 macOS launchd 定时任务（每周一 03:00 自动运行）：

```bash
# 把模板里的 <HOME> 替换为你的主目录后复制
sed 's#<HOME>#'"$HOME"'#g' skills/dingyi-edu-radar/scripts/cn.bao.edumails-radar-refresh.plist \
   > ~/Library/LaunchAgents/cn.bao.edumails-radar-refresh.plist
launchctl load ~/Library/LaunchAgents/cn.bao.edumails-radar-refresh.plist
```

查看刷新日志：

```bash
tail -f skills/dingyi-edu-radar/scripts/refresh.log
```

> **依赖**：`curl` + `python3`（含 `beautifulsoup4`、`lxml`）
> ```bash
> pip3 install --user --break-system-packages beautifulsoup4 lxml
> ```

---

## 🧠 工作原理

```
用户提问
   │
   ▼
[1] 读 catalog.json (249 条索引) → 关键词匹配定位文章
   │
   ▼
[2] 读 references/<slug>.md → 获取完整优惠方案 / 申请步骤
   │
   ▼
[3] 组织回答：结论先行 + 价格表 + 申请步骤 + 常见坑 + 来源链接
```

**渐进式加载**：catalog（36KB）常驻上下文，249 篇详情按需读取，避免一次性灌入全部内容。

---

## 📊 覆盖范围

| 分类 | 数量 | 示例 |
|------|------|------|
| 产品教育优惠 (`/us`) | 158 篇 | Replit、Notion、Figma、JetBrains、ChatGPT、Grok、Gemini、MATLAB、Adobe、Perplexity … |
| edu 邮箱申请 (`/edu`) | 91 篇 | 特拉华技术社区学院、印第安纳大学、加州大学旧金山分校、墨尔本大学、淡江大学 … |
| **合计** | **249 篇** | |

---

## ⚠️ 注意事项

- 所有内容来自 [edumails.cn](https://www.edumails.cn)，**优惠信息可能随时间失效**，回答时会提醒"以官网为准"并附来源链接。
- 抓取脚本仅做内容同步，请求间隔 0.25s，不对源站造成压力。

---

## ⚖️ 使用声明（重要）

本项目的目的**仅限于查询产品的官方教育优惠、以及查询如何合法申请 edu 邮箱**，是一个公开信息的索引工具。使用时请知悉并遵守以下边界：

**✅ 本项目提供：**
- 各厂商**官方公布**的教育优惠、学生折扣、免费教育版方案
- 各院校**官方注册入口**的 edu 邮箱申请方法（学校官网、网申系统、校友会等公开渠道）
- 官方学生身份认证平台（SheerID / UNiDAYS / Student Beans 等）的使用说明

**❌ 本项目不提供，也请勿用于：**
- 盗用他人身份、冒用他人学生资格申请 edu 邮箱或教育优惠
- 伪造学生证、学籍、录取通知书等证明材料
- 批量注册、机器刷号、绕过官方认证审核
- 买卖来路不明的 edu 邮箱（此类邮箱多为盗取的二手账号，易被找回、被封号，且涉嫌违法）

**关于教程原文的措辞：** `references/` 下的教程转载自 edumails.cn 原文，部分文章标题或正文中可能出现"白嫖""薅羊毛"等口语化表述——那是**源站原文的用词，不代表本项目立场**。本项目仅作客观索引，引用时一律以中性词转述，不渲染、不鼓励任何违规获取行为。

请通过正规渠道获取教育身份：在校学生使用本校邮箱，毕业生申请校友邮箱，或通过官方学生认证平台完成资格验证。各产品教育优惠的最终解释权归相应厂商所有。

---

## 📄 License

MIT © [Ding Yi](https://github.com/dingyi)
