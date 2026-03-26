# Claude Code 配置备份与一键安装包

## 本机安装的组件

### 插件 (Plugins)

| 插件名称 | 版本 | 说明 |
|---------|------|------|
| **everything-claude-code** | v1.9.0 | ECC 技能库 (100+ 技能) |
| **claude-hud** | v0.0.11 | 状态栏显示工具 |
| **glm-plan-usage** | v0.0.1 | GLM Coding Plan 使用量查询 |
| **glm-plan-bug** | v0.0.1 | GLM Coding Plan 问题反馈 |

### 自定义规则 (Custom Rules)

#### 通用规则 (common/)
- `agents.md` - 代理编排指南
- `coding-style.md` - 编码风格指南（不可变性）
- `development-workflow.md` - 开发工作流程（研究→计划→TDD→评审→提交）
- `git-workflow.md` - Git 工作流和 PR 规范
- `hooks.md` - Hooks 系统配置
- `patterns.md` - 通用模式（Repository、API响应格式）
- `performance.md` - 性能优化（模型选择、上下文管理）
- `security.md` - 安全指南
- `testing.md` - 测试要求（80%覆盖率）

#### 语言特定规则

**Python** (`python/`):
- `patterns.md` - Pythonic 模式
- `coding-style.md` - PEP 8 标准
- `hooks.md` - Python 钩子
- `security.md` - Python 安全
- `testing.md` - pytest/TDD 策略

**TypeScript** (`typescript/`):
- `patterns.md` - TS 模式
- `coding-style.md` - TS 编码规范
- `hooks.md` - TS 钩子
- `security.md` - TS 安全
- `testing.md` - Jest/TDD 策略

**Go** (`golang/`):
- `patterns.md` - Go 模式

### 自定义代理/技能 (Custom Agents/Skills)

**gstack** (24个代理):
- `gstack` - 基础浏览器代理
- `gstack-investigate` - 系统调试
- `gstack-review` - 代码审查
- `gstack-careful` - 安全模式
- `gstack-design-consultation` - 设计咨询
- `gstack-browse` - 浏览器测试
- `gstack-qa` - QA测试
- `gstack-qa-only` - 只报告不修复
- `gstack-freeze` - 限制编辑范围
- `gstack-unfreeze` - 解除限制
- `gstack-autoplan` - 自动评审
- `gstack-benchmark` - 性能测试
- `gstack-plan-ceo-review` - CEO评审模式
- `gstack-plan-design-review` - 设计评审
- `gstack-setup-deploy` - 部署配置
- `gstack-canary` - 金丝雀监控
- `gstack-cso` - CSO审计模式
- `gstack-land-and-deploy` - Land & Deploy
- `gstack-document-release` - 文档更新
- `gstack-guard` - 全面安全模式
- `gstack-investigate` - 调查
- `gstack-plan-eng-review` - Eng评审
- `gstack-retro` - 周会回顾
- `gstack-ship` - Ship工作流
- `gstack-upgrade` - 升级gstack

### 环境配置

- **API Endpoint**: `https://open.bigmodel.cn/api/anthropic`
- **默认模型**: `sonnet[1m]`
- **超时设置**: 3000秒

---

## 一键安装

### 方式1: 使用安装脚本 (推荐)

```bash
# 克隆本仓库
git clone https://github.com/wcy8822/claude-code-setup.git
cd claude-code-setup

# 运行安装脚本
chmod +x install.sh
./install.sh
```

### 方式2: 手动安装

```bash
# 1. 安装依赖
npm install -g openclaw@latest

# 2. 复制规则
cp -r rules ~/.claude/

# 3. 复制技能
cp -r skills ~/.claude/agents/

# 4. 配置 settings.json
cp settings.json ~/.claude/

# 5. 设置API Token（需要替换成你自己的）
claude config set auth_token YOUR_TOKEN_HERE
```

---

## 配置说明

### ⚠️ API Token 配置

**重要：仓库中的 `settings.json` 不包含 API token，需要自行配置！**

运行安装脚本后，需要配置你的 API token：

```bash
# 方式1: 使用命令行配置
claude config set auth_token YOUR_TOKEN_HERE

# 方式2: 直接编辑配置文件
nano ~/.claude/settings.json
```

在 `~/.claude/settings.json` 中添加：

```json
{
  "model": "sonnet[1m]",
  "env": {
    "ANTHROPIC_AUTH_TOKEN": "你的_API_Token",
    "ANTHROPIC_BASE_URL": "你的_API_Endpoint"
  },
  ...
}
```

#### 获取 API Token

| 服务商 | 获取地址 |
|--------|---------|
| Anthropic 官方 | https://console.anthropic.com/settings/keys |
| 智谱 GLM | 咨询智谱服务商 |

#### 安全提醒
- ❌ 不要将 API token 提交到 Git
- ❌ 不要在公开仓库中分享
- ✅ 使用环境变量存储敏感信息
- ✅ 定期轮换 token

### 插件安装

插件需要通过 `claude` CLI 安装：

```bash
# 安装 everything-claude-code
claude plugin install everything-claude-code@everything-claude-code

# 安装 claude-hud
claude plugin install claude-hud@claude-hud
```

---

## 使用指南

### 常用代理

| 命令 | 功能 |
|-------|------|
| `/agent planner` | 创建实施计划 |
| `/agent code-reviewer` | 代码审查 |
| `/agent tdd-guide` | TDD指导 |
| `/gstack` | 浏览器测试 |
| `/agent office-hours` | 产品头脑风暴 |

### 常用技能

```
/everything-claude-code:plan        # 创建实施计划
/everything-claude-code:tdd         # TDD开发
/everything-claude-code:code-review  # 代码审查
```

---

## 文件结构

```
claude-setup/
├── README.md           # 本文档
├── install.sh          # 一键安装脚本
├── rules/             # 自定义规则
│   ├── common/        # 通用规则
│   ├── python/        # Python规则
│   ├── typescript/    # TypeScript规则
│   └── golang/       # Go规则
├── skills/            # 自定义代理/技能
│   └── gstack/       # gstack技能
└── settings.json      # Claude配置模板
```

---

## 更新日志

- **2026-03-26**: 初始版本备份
  - everything-claude-code v1.9.0
  - claude-hud v0.0.11
  - gstack 完整技能包
  - 自定义规则集 (common/python/typescript/golang)

---

## 许可证

MIT License
