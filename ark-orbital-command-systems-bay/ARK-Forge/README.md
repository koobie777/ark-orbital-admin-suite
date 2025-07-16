# 🛰️ ARK-Forge – The ARK Ecosystem Android Development Module

<div align="center">
  
  ```
  ╭─────────────────────────────────────────────╮
  │       🛰️ THE ARK ECOSYSTEM SUPREME         │
  │           ARK-Forge Android Builder         │
  │           Commander: koobie777              │
  │              Version: 1.1.4                 │
  ╰─────────────────────────────────────────────╯
  ```

  **The ARK Ecosystem** – Modular homelab command center  
  **ARK-Forge** – Android development and ROM building orchestrator

</div>

---

## 🌌 Overview

**ARK-Forge** is the Android development module of The ARK Ecosystem:  
A tmux-powered, modular fleet for ROM, recovery, and device management.

Built with a space-themed interface and persistent tmux session management, ARK-Forge makes Android development accessible for both veteran Commanders and Cadets (newcomers). The ARK unifies all your development devices and modules into a single, cohesive ecosystem.

### The ARK Ecosystem Modules:
- **ARK-Forge** (This Module) – Android ROM/Recovery building
- **Orbital Command** – System management & monitoring
- Additional modules: Device sync, automation, and more (in active development)

---

## 🚀 Features

### Core Capabilities
- 🔧 **Smart Build System** – Device discovery → repo selection → build
- 📱 **Multi-Device Fleet** – Manage all your Android devices within The ARK
- 🔄 **Persistent Sessions** – tmux-powered builds, survive disconnects or restarts
- 🛠️ **Modular Architecture** – Add, extend, or compose new modules easily
- 🎨 **Unified ARK Theming** – Consistent, immersive space UI across modules

### Current Modules
1. **Smart Build** – Intelligent device/repo/build automation
2. **Recovery Build** – TWRP/OrangeFox builder (In Development)
3. **ROM Build** – Full ROM compilation for any device
4. **Boot/Recovery Images** – Kernel/recovery extraction & building
5. **Resume Build** – Continue interrupted builds
6. **Repo Sync Only** – Smart repository sync
7. **Device Manager** – Fleet device database (In Development)
8. **Repository Manager** – ROM source management
9. **Directory Manager** – Build/cache/output organization
10. **Configuration Manager** – ARK settings & customization
11. **Fleet Status** – View all ARK devices
12. **Tmux Manager** – Session management

---

## 📋 Requirements

- **OS**: Linux (Tested on Arch Linux)
- **Shell**: Bash 4.0+
- **Dependencies**:
  - `tmux` – Persistent terminal multiplexer
  - `git` – Version control
  - `repo` – Android repo tool
  - Android build environment packages
- **Storage**: 200GB+ recommended for ROM building
- **RAM**: 16GB+ recommended

---

## 🛸 Installation

```bash
# Clone ARK-Forge module
git clone https://github.com/koobie777/Ark-Forge.git ~/ARK-Ecosystem/modules/Ark-Forge
cd ~/ARK-Ecosystem/modules/Ark-Forge

# Make scripts executable
chmod +x arkforge-launcher arkforge.sh
chmod +x modules/*.sh

# Create config directory if needed
mkdir -p config

# Launch The ARK
./arkforge-launcher
```

---

## 🎮 Usage

### Quick Start

```bash
# Launch with tmux management (Recommended)
./arkforge-launcher

# Or run directly outside tmux
./arkforge.sh
```

### ARK Fleet Devices (Example)
- **Primary:** OnePlus 12 "waffle"
- **Secondary:** OnePlus 10 Pro "op515dl1"

### tmux Session Management

When using `arkforge-launcher`, all operations run in a persistent `ark-forge` tmux session:
- **Detach:** `Ctrl-B`, then `D`
- **Reattach:** `./arkforge-launcher` and select "Attach"
- **List Windows:** `Ctrl-B`, then `W`
- **Switch Windows:** `Ctrl-B`, then window number

### Build Directory Structure

```
/home/koobie777/android/
├── lineageos-waffle/        # LineageOS for OnePlus 12
├── evolution-op515dl1/      # Evolution X for OnePlus 10 Pro
└── twrp-waffle/             # TWRP recovery for OnePlus 12
```

---

## 🛰️ ARK Modes

### Expert Mode (Default)
- Minimal prompts
- Fast operations
- Assumes familiarity with Android building

### Cadet Mode (Coming Soon)
- Guided experience
- Detailed explanations
- Step-by-step assistance

---

## 🔧 Configuration

ARK-Forge settings are in `config/ark-settings.conf`:
```bash
# The ARK Configuration
ARK_THEME_ENABLED=true
ARK_MODE="expert"  # or "cadet"
ARK_BUILD_DIR="/home/koobie777/android"
ARK_DEFAULT_JOBS=$(nproc --all)
```

---

## 📚 Module Development

Create new ARK modules easily with the template below:

```bash
cat > modules/ark-new-module.sh << 'EOF'
#!/usr/bin/env bash
# ╭─────────────────────────────────────────────╮
# │         ARK MODULE NAME                     │
# │              Description                    │
# │           Commander: koobie777              │
# ╰─────────────────────────────────────────────╯

source "$ARK_CONFIG_DIR/ark-settings.conf"

# Your module code here
EOF
```

---

## 🐛 Troubleshooting

### Common Issues

**tmux sessions persisting:**
```bash
# List all tmux sessions
tmux ls

# Kill specific session
tmux kill-session -t ark-forge
```

**Module not loading:**
- Check permissions: `chmod +x modules/*.sh`
- Verify path in `arkforge.sh`

**Build failures:**
- Attach to session: `tmux attach -t ark-forge`
- Review logs in build directory

---

## 🚀 Roadmap

### Version 1.2.0 (Planned)
- [ ] Complete Recovery Build module
- [ ] Implement Cadet Mode
- [ ] Add build statistics/logging
- [ ] Device tree automation

### Version 2.0.0 (Future)
- [ ] Integration with Orbital Command
- [ ] Fleet-wide build orchestration
- [ ] Cloud backup integration
- [ ] AI-assisted troubleshooting

---

## 🤝 Contributing

The ARK Ecosystem welcomes contributions!
- Maintain ARK theming and style
- Test modules thoroughly
- Update documentation
- Follow the modular architecture

---

## 📜 License

This project is part of The ARK Ecosystem  
Commander: koobie777  
System: arksupreme-mk1

---

<div align="center">
  
  **🛰️ May The ARK be with you! 🛰️**
  
  Built with ❤️ for the Android development community

</div>
