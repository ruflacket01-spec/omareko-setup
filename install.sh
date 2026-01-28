#!/bin/bash
#
# 🤖 Omareko AI Assistant Setup
# One-liner setup for your own AI butler using Moltbot + OpenRouter free models
# 
# Usage: curl -fsSL https://raw.githubusercontent.com/ruflacket01-spec/omareko-setup/main/install.sh | bash
#
# Supports: Linux, macOS, Windows (via WSL2)
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

# Detect OS
IS_WSL=false
if grep -qEi "(Microsoft|WSL)" /proc/version 2>/dev/null; then
    IS_WSL=true
fi

# Banner
echo ""
echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}  ${BOLD}🤵 Welcome to the Omareko AI Assistant Setup!${NC}                 ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}     Your personal AI butler, powered by free models           ${CYAN}║${NC}"
if $IS_WSL; then
echo -e "${CYAN}║${NC}     ${GREEN}✓ WSL2 detected - Windows compatible mode${NC}                 ${CYAN}║${NC}"
fi
echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check if running on Windows without WSL
if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
    echo -e "${RED}❌ Native Windows detected. Please use WSL2 instead:${NC}"
    echo ""
    echo "   1. Open PowerShell as Administrator"
    echo "   2. Run: wsl --install"
    echo "   3. Restart your computer"
    echo "   4. Open Ubuntu from Start Menu"
    echo "   5. Run this script again inside WSL2"
    echo ""
    exit 1
fi

# Check Node.js
echo -e "${BLUE}[1/8]${NC} Checking prerequisites..."
if ! command -v node &> /dev/null; then
    echo -e "${YELLOW}⚠️  Node.js not found. Installing...${NC}"
    if $IS_WSL || [[ -f /etc/debian_version ]]; then
        # Debian/Ubuntu/WSL
        curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
        sudo apt-get install -y nodejs
    elif [[ -f /etc/redhat-release ]]; then
        # RHEL/CentOS/Fedora
        curl -fsSL https://rpm.nodesource.com/setup_22.x | sudo bash -
        sudo yum install -y nodejs
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if command -v brew &> /dev/null; then
            brew install node@22
        else
            echo -e "${RED}Please install Homebrew first: https://brew.sh${NC}"
            exit 1
        fi
    else
        echo -e "${RED}❌ Please install Node.js 22+ manually: https://nodejs.org${NC}"
        exit 1
    fi
fi

NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 22 ]; then
    echo -e "${YELLOW}⚠️  Node.js version $NODE_VERSION detected. Upgrading to 22+...${NC}"
    if $IS_WSL || [[ -f /etc/debian_version ]]; then
        curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
        sudo apt-get install -y nodejs
    fi
fi
echo -e "${GREEN}✓${NC} Node.js $(node -v) found"

# Ask for OpenRouter API Key
echo ""
echo -e "${BLUE}[2/8]${NC} OpenRouter API Key Setup"
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
echo -e "${BLUE}[3/8]${NC} Installing Moltbot CLI..."
curl -fsSL https://molt.bot/install.sh | bash

# Ensure moltbot is in PATH for this script
export PATH="$HOME/.npm-global/bin:$HOME/.local/bin:$PATH"

# Source bashrc to get moltbot in path
if [ -f "$HOME/.bashrc" ]; then
    source "$HOME/.bashrc" 2>/dev/null || true
fi

# Wait a moment for install to settle
sleep 2

# Verify moltbot is available
if ! command -v moltbot &> /dev/null; then
    echo -e "${YELLOW}Adding moltbot to PATH...${NC}"
    export PATH="$HOME/.npm-global/bin:$PATH"
fi

# Configure workspace
WORKSPACE="$HOME/omareko"
echo ""
echo -e "${BLUE}[4/8]${NC} Setting up workspace at ${CYAN}$WORKSPACE${NC}..."
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
- Connected via WhatsApp

## Notes
First day in the world. Ready to help!
MEMORY_EOF

# Download free skills
echo ""
echo -e "${BLUE}[5/8]${NC} Installing free skills..."

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
echo -e "${BLUE}[6/8]${NC} Configuring Moltbot with OpenRouter..."

# Non-interactive onboard (without WhatsApp first)
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

# Set a free model as default
echo ""
echo -e "${BLUE}[7/8]${NC} Setting up free model defaults..."
moltbot configure --set "agents.defaults.model.primary=openrouter/meta-llama/llama-3.3-8b-instruct:free" 2>/dev/null || true

# WhatsApp Setup
echo ""
echo -e "${BLUE}[8/8]${NC} WhatsApp Setup"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "Now let's connect your WhatsApp!"
echo ""
echo -e "${YELLOW}Instructions:${NC}"
echo "  1. A QR code will appear in your terminal"
echo "  2. Open WhatsApp on your phone"
echo "  3. Go to Settings → Linked Devices → Link a Device"
echo "  4. Scan the QR code"
echo ""
read -p "Press ENTER when ready to scan QR code..."

# Start gateway if not running
moltbot gateway start 2>/dev/null || true
sleep 3

# WhatsApp login
echo ""
echo -e "${CYAN}Scan this QR code with WhatsApp:${NC}"
echo ""
moltbot channels login whatsapp 2>&1 || {
    echo ""
    echo -e "${YELLOW}If QR didn't appear, run manually later:${NC}"
    echo -e "  ${CYAN}moltbot channels login whatsapp${NC}"
}

# Final output
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}${BOLD}✅ Omareko is ready!${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${BOLD}🎉 You can now chat with Omareko on WhatsApp!${NC}"
echo ""
echo -e "Just send a message to yourself (or the linked number)."
echo ""
echo -e "${BOLD}Useful commands:${NC}"
echo ""
echo -e "  ${CYAN}moltbot dashboard${NC}          # Open web chat UI"
echo -e "  ${CYAN}moltbot gateway status${NC}     # Check if running"
echo -e "  ${CYAN}moltbot gateway start${NC}      # Start the assistant"
echo -e "  ${CYAN}moltbot gateway stop${NC}       # Stop the assistant"
echo -e "  ${CYAN}moltbot channels login whatsapp${NC}  # Re-link WhatsApp"
echo ""
echo -e "${BOLD}Workspace:${NC} $WORKSPACE"
echo ""
if $IS_WSL; then
echo -e "${BOLD}Windows Tips:${NC}"
echo -e "  • Keep this WSL terminal open (or run as service)"
echo -e "  • Access from Windows: ${CYAN}\\\\wsl$\\Ubuntu\\home\\$USER\\omareko${NC}"
echo ""
fi
echo -e "${BOLD}Free Models Available:${NC}"
echo -e "  • meta-llama/llama-3.3-8b-instruct:free (default)"
echo -e "  • google/gemma-2-9b-it:free"
echo -e "  • mistralai/mistral-7b-instruct:free"
echo ""
echo -e "${YELLOW}Tip:${NC} Edit ${CYAN}$WORKSPACE/USER.md${NC} to tell Omareko about yourself!"
echo ""
echo -e "🤖 ${BOLD}Say hi on WhatsApp!${NC}"
echo ""
