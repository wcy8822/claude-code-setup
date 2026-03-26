#!/bin/bash
# Claude Code 一键安装脚本
# 用于在其他机器上快速部署 Claude Code 配置

set -e

echo "🚀 Claude Code 配置一键安装脚本"
echo "================================"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查是否在正确的目录
if [ ! -f "settings.json" ]; then
    echo -e "${RED}错误: 请在 claude-setup 目录下运行此脚本${NC}"
    exit 1
fi

# 1. 备份现有配置
echo ""
echo "📦 步骤 1/6: 备份现有配置..."
CLAUDE_DIR="$HOME/.claude"
BACKUP_DIR="$HOME/.claude-backup-$(date +%Y%m%d-%H%M%S)"

if [ -d "$CLAUDE_DIR" ]; then
    echo "备份现有配置到: $BACKUP_DIR"
    cp -r "$CLAUDE_DIR" "$BACKUP_DIR" || {
        echo -e "${YELLOW}警告: 无法备份配置，继续安装...${NC}"
    }
fi

# 2. 创建必要的目录
echo ""
echo "📁 步骤 2/6: 创建目录结构..."
mkdir -p "$CLAUDE_DIR/rules"
mkdir -p "$CLAUDE_DIR/agents/skills"
mkdir -p "$CLAUDE_DIR/plugins/cache"

# 3. 复制自定义规则
echo ""
echo "📋 步骤 3/6: 安装自定义规则..."
cp -r rules/* "$CLAUDE_DIR/rules/"
echo -e "${GREEN}✓ 规则安装完成${NC}"

# 4. 复制自定义技能/代理
echo ""
echo "🤖 步骤 4/6: 安装自定义技能/代理..."
if [ -d "skills" ]; then
    cp -r skills/* "$CLAUDE_DIR/agents/skills/"
    echo -e "${GREEN}✓ 技能安装完成${NC}"
else
    echo -e "${YELLOW}未找到 skills 目录，跳过...${NC}"
fi

# 5. 配置 settings.json
echo ""
echo "⚙️  步骤 5/6: 配置 Claude..."
if [ -f "settings.json" ]; then
    # 保留现有的 auth_token（如果存在）
    if [ -f "$CLAUDE_DIR/settings.json" ]; then
        EXISTING_TOKEN=$(python3 -c "import json; print(json.load(open('$CLAUDE_DIR/settings.json')).get('env', {}).get('ANTHROPIC_AUTH_TOKEN', ''))" 2>/dev/null || echo "")
    fi

    cp settings.json "$CLAUDE_DIR/settings.json"

    # 如果有现有 token，保留它
    if [ -n "$EXISTING_TOKEN" ]; then
        echo -e "${GREEN}✓ 保留现有 API Token${NC}"
        echo "你的 token 仍然有效，无需重新配置"
    else
        echo -e "${YELLOW}⚠️  需要配置 API Token${NC}"
        echo ""
        echo "请在 $CLAUDE_DIR/settings.json 中设置你的 ANTHROPIC_AUTH_TOKEN"
        echo ""
        echo "或者运行: claude config set auth_token YOUR_TOKEN_HERE"
    fi

    echo -e "${GREEN}✓ 配置文件安装完成${NC}"
else
    echo -e "${YELLOW}未找到 settings.json，跳过...${NC}"
fi

# 6. 检查并安装插件
echo ""
echo "🔌 步骤 6/6: 检查插件..."
if command -v claude &> /dev/null; then
    echo -e "${GREEN}✓ Claude CLI 已安装${NC}"

    # 检查并提示安装插件
    echo ""
    echo "请手动安装以下插件（如果尚未安装）："
    echo ""
    echo "  claude plugin install everything-claude-code@everything-claude-code"
    echo "  claude plugin install claude-hud@claude-hud"
    echo ""
else
    echo -e "${YELLOW}⚠️  Claude CLI 未安装${NC}"
    echo "请先安装 Claude Code: https://docs.anthropic.com/claude-code/getting-started"
fi

# 完成
echo ""
echo "================================"
echo -e "${GREEN}✅ 安装完成！${NC}"
echo ""
echo "📌 下一步："
echo "  1. 配置 API Token（如果尚未配置）"
echo "  2. 安装插件：claude plugin install <插件名>"
echo "  3. 重启 Claude Code"
echo ""
echo "📚 使用文档: 请查看 README.md"
echo ""
