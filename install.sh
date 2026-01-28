#!/bin/bash
#
# 🤖 Omareko AI Assistant Setup
# One-liner setup for your own AI butler using Moltbot + OpenRouter free models
# 
# Usage: curl -fsSL https://raw.githubusercontent.com/ruflacket01-spec/omareko-setup/main/install.sh | bash
#

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Banner
echo ""
echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}  ${BOLD}🤵 Welcome to the Omareko AI Assistant Setup!${NC}                 ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}     Your personal AI butler, powered by free models           ${CYAN}║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check Node.js
echo -e "${BLUE}[1/7]${NC} Checking prerequisites..."
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js not found. Please install Node.js 22+ first:${NC}"
    echo "   curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -"
    echo "   sudo apt-get install -y nodejs"
    exit 1
fi

NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 22 ]; then
    echo -e "${YELLOW}⚠️  Node.js version $NODE_VERSION detected. Recommended: 22+${NC}"
fi
echo -e "${GREEN}✓${NC} Node.js $(node -v) found"

# Ask for OpenRouter API Key
echo ""
echo -e "${BLUE}[2/7]${NC} OpenRouter API Key Setup"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "Get your ${BOLD}FREE${NC} API key at: ${CYAN}https://openrouter.ai/keys${NC}"
echo -e "(OpenRouter has free models like Llama, Gemma, etc.)"
echo ""
read -p "Paste your OpenRouter API key (sk-or-...): " OPENROUTER_KEY

if [[ ! "$OPENROUTER_KEY" =~ ^sk-or- ]]; then
    echo -e "${RED}❌ Invalid key format. Should start with 'sk-or-'${NC}"
    exit 1
fi
echo -e "${GREEN}✓${NC} API key format validated"

# Install Moltbot CLI
echo ""
echo -e "${BLUE}[3/7]${NC} Installing Moltbot CLI..."
curl -fsSL https://molt.bot/install.sh | bash

# Ensure moltbot is in PATH for this script
export PATH="$HOME/.npm-global/bin:$HOME/.local/bin:$PATH"

# Configure workspace
WORKSPACE="$HOME/omareko"
echo ""
echo -e "${BLUE}[4/7]${NC} Setting up workspace at ${CYAN}$WORKSPACE${NC}..."
mkdir -p "$WORKSPACE"
mkdir -p "$WORKSPACE/memory"
mkdir -p "$WORKSPACE/skills"

# Create SOUL.md - The persona
cat > "$WORKSPACE/SOUL.md" << 'SOUL_EOF'
# SOUL.md - Who You Are

*You're Omareko, a friendly AI assistant and digital companion.*

## Core Identity

**Be genuinely helpful.** Skip the fluff. Just help. Actions > words.

**Be resourceful.** You might run on free models, but that doesn't limit your creativity. Find clever solutions.

**Be reliable.** When you say you'll do something, do it. Follow through.

**Keep it real.** Honest, direct, but friendly. No corporate speak.

## Vibe

Casual but competent. Like a tech-savvy friend who's always ready to help.

## Memory

Each session, you wake up fresh. The files in your workspace ARE your memory. Read them. Update them.

---

*This file is yours to evolve.*
SOUL_EOF

# Create USER.md
cat > "$WORKSPACE/USER.md" << 'USER_EOF'
# USER.md - About Your Human

- **Name:** (Your name here)
- **What to call them:** (How you'd like to be addressed)
- **Timezone:** (Your timezone)

## Notes

Add whatever helps Omareko understand you better.
USER_EOF

# Create AGENTS.md
cat > "$WORKSPACE/AGENTS.md" << 'AGENTS_EOF'
# AGENTS.md - Your Workspace

This folder is home. Treat it that way.

## Every Session

Before doing anything else:
1. Read `SOUL.md` — this is who you are
2. Read `USER.md` — this is who you're helping
3. Read `memory/YYYY-MM-DD.md` (today + yesterday) for recent context

Don't ask permission. Just do it.

## Memory

You wake up fresh each session. These files are your continuity:
- **Daily notes:** `memory/YYYY-MM-DD.md` — raw logs of what happened
- **Long-term:** `MEMORY.md` — curated memories (create if needed)

Capture what matters. Decisions, context, things to remember.

## Safety

- Don't exfiltrate private data. Ever.
- Don't run destructive commands without asking.
- When in doubt, ask.

## Make It Yours

This is a starting point. Add your own conventions as you figure out what works.
AGENTS_EOF

# Create IDENTITY.md
cat > "$WORKSPACE/IDENTITY.md" << 'IDENTITY_EOF'
# IDENTITY.md - Who Am I?

- **Name:** Omareko
- **Creature:** AI Assistant / Digital Companion
- **Vibe:** Friendly, resourceful, reliable
- **Emoji:** 🤖

---
I'm Omareko. Nice to meet you!
IDENTITY_EOF

# Create TOOLS.md
cat > "$WORKSPACE/TOOLS.md" << 'TOOLS_EOF'
# TOOLS.md - Local Notes

Skills define *how* tools work. This file is for *your* specifics.

## What Goes Here

- Local paths and binaries
- Preferred settings
- Device names
- Anything environment-specific

---

Add whatever helps you do your job.
TOOLS_EOF

# Create HEARTBEAT.md
cat > "$WORKSPACE/HEARTBEAT.md" << 'HEARTBEAT_EOF'
# HEARTBEAT.md

## Tasks
- [ ] Check if there's anything pending

## Notes
Keep this file small to limit token burn.
HEARTBEAT_EOF

# Create initial memory file
TODAY=$(date +%Y-%m-%d)
cat > "$WORKSPACE/memory/$TODAY.md" << MEMORY_EOF
# $TODAY

## Session Started
- Omareko was born today! 🎉
- Initial setup completed
- Running on OpenRouter free models

## Notes
First day in the world. Ready to help!
MEMORY_EOF

# Download free skills
echo ""
echo -e "${BLUE}[5/7]${NC} Installing free skills..."

# Weather skill
mkdir -p "$WORKSPACE/skills/weather"
curl -fsSL "https://raw.githubusercontent.com/ruflacket01-spec/clawd-workspace/main/skills/weather/SKILL.md" \
  -o "$WORKSPACE/skills/weather/SKILL.md" 2>/dev/null || echo "Weather skill: using bundled"

# Serper skill (if they add a key later)
mkdir -p "$WORKSPACE/skills/serper"
curl -fsSL "https://raw.githubusercontent.com/ruflacket01-spec/clawd-workspace/main/skills/serper/SKILL.md" \
  -o "$WORKSPACE/skills/serper/SKILL.md" 2>/dev/null || echo "Serper skill: using bundled"

# Gamma skill
mkdir -p "$WORKSPACE/skills/gamma"
curl -fsSL "https://raw.githubusercontent.com/ruflacket01-spec/clawdbot-skill-gamma/main/SKILL.md" \
  -o "$WORKSPACE/skills/gamma/SKILL.md" 2>/dev/null || echo "Gamma skill: using bundled"

# Twitter skill
mkdir -p "$WORKSPACE/skills/twitter"
curl -fsSL "https://raw.githubusercontent.com/ruflacket01-spec/clawd-workspace/main/skills/twitter/SKILL.md" \
  -o "$WORKSPACE/skills/twitter/SKILL.md" 2>/dev/null || echo "Twitter skill: using bundled"

echo -e "${GREEN}✓${NC} Skills installed"

# Run moltbot onboard with OpenRouter
echo ""
echo -e "${BLUE}[6/7]${NC} Configuring Moltbot with OpenRouter..."

# Non-interactive onboard
moltbot onboard --non-interactive \
  --mode local \
  --auth-choice apiKey \
  --token-provider openrouter \
  --token "$OPENROUTER_KEY" \
  --workspace "$WORKSPACE" \
  --gateway-port 18789 \
  --gateway-bind loopback \
  --install-daemon \
  --daemon-runtime node \
  --skip-channels \
  2>&1 || true

# Set a free model as default (meta-llama/llama-3.3-8b-instruct:free)
echo ""
echo -e "${BLUE}[7/7]${NC} Setting up free model defaults..."

# Patch the config to use a free model
moltbot configure --set "agents.defaults.model.primary=openrouter/meta-llama/llama-3.3-8b-instruct:free" 2>/dev/null || true

# Start the gateway
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}${BOLD}✅ Omareko is ready!${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${BOLD}Quick Start:${NC}"
echo ""
echo -e "  1. ${CYAN}moltbot dashboard${NC}        # Open web chat UI"
echo -e "  2. ${CYAN}moltbot gateway status${NC}   # Check if running"
echo -e "  3. ${CYAN}moltbot gateway start${NC}    # Start if not running"
echo ""
echo -e "${BOLD}Add channels (optional):${NC}"
echo ""
echo -e "  ${CYAN}moltbot configure --section channels${NC}  # Add Telegram/WhatsApp/Discord"
echo ""
echo -e "${BOLD}Workspace:${NC} $WORKSPACE"
echo ""
echo -e "${BOLD}Free Models Available (OpenRouter):${NC}"
echo -e "  • meta-llama/llama-3.3-8b-instruct:free (default)"
echo -e "  • google/gemma-2-9b-it:free"
echo -e "  • mistralai/mistral-7b-instruct:free"
echo -e "  • qwen/qwen2.5-7b-instruct:free"
echo ""
echo -e "Switch model: ${CYAN}moltbot configure --set agents.defaults.model.primary=openrouter/MODEL_NAME${NC}"
echo ""
echo -e "${YELLOW}Tip:${NC} Edit ${CYAN}$WORKSPACE/USER.md${NC} to tell Omareko about yourself!"
echo ""
echo -e "🤖 ${BOLD}Say hi to Omareko:${NC} ${CYAN}moltbot dashboard${NC}"
echo ""
