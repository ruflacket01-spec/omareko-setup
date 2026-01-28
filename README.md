# 🤖 Omareko AI Assistant

Your own AI assistant, running on **free models** via OpenRouter.

Powered by [Moltbot](https://docs.molt.bot) — the same framework behind Alfred and other AI butlers.

## ⚡ One-Line Install

```bash
curl -fsSL https://raw.githubusercontent.com/ruflacket01-spec/omareko-setup/main/install.sh | bash
```

## 📋 What You Need

1. **Node.js 22+** — [Install guide](https://nodejs.org/)
2. **OpenRouter API key** (FREE) — Get one at [openrouter.ai/keys](https://openrouter.ai/keys)

That's it!

## 🎁 What's Included

### Persona Files
- `SOUL.md` — Omareko's personality and values
- `IDENTITY.md` — Name, emoji, vibe
- `USER.md` — Info about you (edit this!)
- `AGENTS.md` — Operating instructions
- `HEARTBEAT.md` — Background task checklist

### Free Skills
- 🌤️ **Weather** — Get forecasts (no API key needed)
- ✨ **Gamma** — Generate professional presentations
- 🐦 **Twitter** — Post and read tweets
- 🔍 **Serper** — Google search (add key later if needed)

## 🚀 Quick Start

After install:

```bash
# Open web chat
moltbot dashboard

# Check status
moltbot gateway status

# Add Telegram/WhatsApp
moltbot configure --section channels
```

## 💰 Free Models on OpenRouter

The installer defaults to **Llama 3.3 8B** (free). Other free options:

| Model | Command |
|-------|---------|
| Llama 3.3 8B | `openrouter/meta-llama/llama-3.3-8b-instruct:free` |
| Gemma 2 9B | `openrouter/google/gemma-2-9b-it:free` |
| Mistral 7B | `openrouter/mistralai/mistral-7b-instruct:free` |
| Qwen 2.5 7B | `openrouter/qwen/qwen2.5-7b-instruct:free` |

Switch models:
```bash
moltbot configure --set agents.defaults.model.primary=openrouter/google/gemma-2-9b-it:free
```

## 📁 Workspace Structure

```
~/omareko/
├── AGENTS.md       # Operating instructions
├── SOUL.md         # Personality
├── USER.md         # About you
├── IDENTITY.md     # Name & vibe
├── TOOLS.md        # Local tool notes
├── HEARTBEAT.md    # Background tasks
├── memory/         # Daily memory logs
│   └── 2026-01-28.md
└── skills/         # Bundled skills
    ├── weather/
    ├── gamma/
    ├── twitter/
    └── serper/
```

## 🔧 Customization

### Change Personality
Edit `~/omareko/SOUL.md` to change how Omareko behaves.

### Tell Omareko About You
Edit `~/omareko/USER.md` with your name, timezone, preferences.

### Add More Skills
Drop a `SKILL.md` file into `~/omareko/skills/your-skill/`

## 📚 Documentation

- [Moltbot Docs](https://docs.molt.bot)
- [Getting Started](https://docs.molt.bot/start/getting-started)
- [OpenRouter](https://docs.molt.bot/providers/openrouter)

## 🙏 Credits

- [Moltbot](https://github.com/moltbot/moltbot) — AI assistant framework
- [OpenRouter](https://openrouter.ai) — Multi-model API with free tier
- Created with ❤️ by Alfred ([@MrPix](https://github.com/ruflacket01-spec))

## License

MIT
