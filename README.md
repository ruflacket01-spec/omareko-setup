# 🤖 Omareko AI Assistant

Your own AI assistant, running on **free models** via OpenRouter, chatting on **WhatsApp**.

Powered by [Moltbot](https://docs.molt.bot) — the same framework behind Alfred and other AI butlers.

## 🪟 Windows Users: Read This First!

Moltbot requires **WSL2** (Windows Subsystem for Linux). Here's how to set it up:

### Step 1: Install WSL2

Open **PowerShell as Administrator** and run:

```powershell
wsl --install
```

Restart your computer when prompted.

### Step 2: Open Ubuntu

After restart, open **Ubuntu** from the Start Menu. It will set up your Linux environment.

### Step 3: Run the Install Script

Inside the Ubuntu terminal:

```bash
curl -fsSL https://raw.githubusercontent.com/ruflacket01-spec/omareko-setup/main/install.sh | bash
```

---

## ⚡ One-Line Install (Linux/macOS/WSL2)

```bash
curl -fsSL https://raw.githubusercontent.com/ruflacket01-spec/omareko-setup/main/install.sh | bash
```

## 📋 What You Need

1. **WSL2** (Windows) or Linux/macOS
2. **OpenRouter API key** (FREE!) — Get one at [openrouter.ai/keys](https://openrouter.ai/keys)
3. **WhatsApp** on your phone

That's it!

## 🎬 What Happens During Install

1. ✅ Checks/installs Node.js 22+
2. ✅ Asks for your OpenRouter API key
3. ✅ Installs Moltbot CLI
4. ✅ Creates workspace with persona files
5. ✅ Downloads free skills (Weather, Gamma, Twitter, Serper)
6. ✅ Configures free model (Llama 3.3 8B)
7. ✅ Shows QR code to link WhatsApp
8. ✅ Done! Chat on WhatsApp

## 📱 WhatsApp Setup

During install, you'll see a QR code. Scan it with:

1. Open WhatsApp on your phone
2. Go to **Settings** → **Linked Devices**
3. Tap **Link a Device**
4. Scan the QR code in your terminal

Now send a message to yourself — Omareko will reply! 🎉

## 🎁 What's Included

### Persona Files
- `SOUL.md` — Omareko's personality and values
- `IDENTITY.md` — Name, emoji, vibe
- `USER.md` — Info about you (edit this!)
- `AGENTS.md` — Operating instructions

### Free Skills
- 🌤️ **Weather** — Get forecasts (no API key needed)
- ✨ **Gamma** — Generate professional presentations
- 🐦 **Twitter** — Post and read tweets
- 🔍 **Serper** — Google search (add key later)

## 💰 Free Models on OpenRouter

| Model | Best For |
|-------|----------|
| Llama 3.3 8B | General use (default) |
| Gemma 2 9B | Reasoning tasks |
| Mistral 7B | Fast responses |
| Qwen 2.5 7B | Multilingual |

Switch models:
```bash
moltbot configure --set agents.defaults.model.primary=openrouter/google/gemma-2-9b-it:free
```

## 🔧 Useful Commands

```bash
# Check status
moltbot gateway status

# Start/stop
moltbot gateway start
moltbot gateway stop

# Re-link WhatsApp
moltbot channels login whatsapp

# Web chat UI
moltbot dashboard

# Health check
moltbot health
```

## 📁 Workspace Location

- **Linux/macOS:** `~/omareko/`
- **Windows (WSL2):** `\\wsl$\Ubuntu\home\YOUR_USERNAME\omareko\`

## 🪟 Windows Tips

### Keep Omareko Running

Option 1: Keep the WSL terminal open

Option 2: Run as a background service (already configured during install)

### Access Files from Windows

Your workspace is accessible at:
```
\\wsl$\Ubuntu\home\YOUR_USERNAME\omareko\
```

Or use VS Code with the WSL extension.

## ❓ Troubleshooting

### WhatsApp QR code didn't appear
```bash
moltbot channels login whatsapp
```

### Gateway not running
```bash
moltbot gateway start
```

### Check what's wrong
```bash
moltbot status --all
moltbot health
```

## 📚 Documentation

- [Moltbot Docs](https://docs.molt.bot)
- [Getting Started](https://docs.molt.bot/start/getting-started)
- [WhatsApp Setup](https://docs.molt.bot/channels/whatsapp)
- [Windows/WSL2](https://docs.molt.bot/platforms/windows)

## 🙏 Credits

- [Moltbot](https://github.com/moltbot/moltbot) — AI assistant framework
- [OpenRouter](https://openrouter.ai) — Multi-model API with free tier
- Created with ❤️ by Alfred ([@MrPix](https://github.com/ruflacket01-spec))

## License

MIT
