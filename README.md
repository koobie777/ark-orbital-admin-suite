# 🪐 ARK ORBITAL ADMIN SUITE v33.0

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Last Commit](https://img.shields.io/github/last-commit/koobie777/ark-orbital-admin-suite)](https://github.com/koobie777/ark-orbital-admin-suite/commits/main)
[![Open Issues](https://img.shields.io/github/issues/koobie777/ark-orbital-admin-suite)](https://github.com/koobie777/ark-orbital-admin-suite/issues)
[![Pull Requests](https://img.shields.io/github/issues-pr/koobie777/ark-orbital-admin-suite)](https://github.com/koobie777/ark-orbital-admin-suite/pulls)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com)

**Complete Ecosystem Management Platform for Admin & Recovery Operations**  
Author: [koobie777](https://github.com/koobie777)

---

## 🚀 About

ARK Orbital Admin Suite is your complete ecosystem management platform for Linux system administration, recovery, and deployment operations. Version 33.0 transforms the suite from a toolkit into a comprehensive platform with portable mode, Arch Linux installer, expert CLI interface, update system, and customization framework. Built for sysadmins, tinkerers, rescue missions, and ecosystem deployment of all kinds.  
With robust hardware detection, guided toolkit installation, safe AUR package management, and cosmic style, it’s built for sysadmins, tinkerers, and rescue missions of all kinds.

---

## 🌠 Features

### Core Features
- **Interactive, Menu-Driven UI**  
  Easy full-screen terminal menus with clear options and emoji indicators.
- **Full Toolkit Install**  
  Installs essential packages for diagnostics, recovery, repair, and daily ops.
- **Advanced Hardware Detection**  
  Detects and reports on CPUs, GPUs, RAM, storage, network, peripherals & more.
- **Safe AUR/Yay Helper**  
  Switches to user context for AUR package install—never runs yay as root!

### 🆕 New in v33.0 - Complete Ecosystem Management
- **🏴‍☠️ ARK Admiral Portable Mode**  
  Portable/live system deployment with zram optimization and persistence management.
- **📦 Complete Arch Linux Installer**  
  Guided Arch installation with ARK ecosystem integration and safety checks.
- **🤖 Expert Mode CLI**  
  Command-line interface for power users with batch operations and debug mode.
- **🔄 ARK Updater System**  
  Auto-update mechanism with version management and rollback capability.
- **🎨 Generic Customization Framework**  
  Template system for creating personalized admin suites with modular components.

### Platform Features
- **Mission Debrief & Summary**  
  Prints a summary and inspirational space quotes at the end of your mission.
- **Cross-Platform Foundation**  
  Currently optimized for Arch Linux with plans for broader distribution support.

---

## ⚠️ Platform Recommendation

**This suite is currently recommended for Arch Linux and compatible distributions.**  
Support for Windows, macOS, and additional Linux distros is planned for future releases.

---

## 📝 Usage

### Interactive Mode (Recommended)
```bash
# Make executable
chmod +x install-admin-recovery-tools-v33.0.sh

# Run as root (for full toolkit and hardware detection)
sudo ./install-admin-recovery-tools-v33.0.sh

# Or as a regular user (for AUR/yay helper menu)
./install-admin-recovery-tools-v33.0.sh
```

### Expert CLI Mode
```bash
# Quick hardware scan
./install-admin-recovery-tools-v33.0.sh --hardware

# Automated full install
sudo ./install-admin-recovery-tools-v33.0.sh --full

# Portable mode setup
sudo ./install-admin-recovery-tools-v33.0.sh --portable

# Enable debug logging
./install-admin-recovery-tools-v33.0.sh --debug --install

# Show help
./install-admin-recovery-tools-v33.0.sh --help
```

### Enhanced Main Menu (v33.0)

#### Core Operations
- `1) 🚀 Full toolkit install` — Installs all base tools, runs hardware detection, and launches safe AUR helper.
- `2) 🛰️ Hardware detection & report` — Robust hardware and device scan.
- `3) 🛠️ Base tools install only` — Installs only core admin/recovery tools.
- `4) 🌌 AUR/Yay Helper & Safe Installer` — User-mode AUR management.

#### 🆕 New Ecosystem Features
- `5) 🏴‍☠️ ARK Admiral Portable Mode` — Configure portable/live system with zram optimization.
- `6) 📦 Complete Arch Linux Installer` — Guided Arch installation with safety checks.
- `7) 🤖 Expert Mode CLI` — Interactive CLI session with advanced commands.
- `8) 🔄 ARK Updater System` — Auto-update with version management and rollback.
- `9) 🎨 Customize ARK Ecosystem` — Personalize and create custom admin suites.

#### System
- `10) 📋 Print Mission Summary` — See what was detected and installed.
- `11) ❌ Abort/Exit` — End the session.

---

## 💫 Screenshots

![Main Menu](assets/menu-screenshot.png)
![Hardware Detection](assets/hardware-screenshot.png)

---

## 💡 Notes & Requirements

### System Requirements
- **Target OS:** Arch Linux and derivatives (optimized for v33.0)
- **Requires:** bash, sudo, standard GNU tools, yay (for AUR features)
- **Optional:** Many features will gracefully degrade if some commands are missing.

### New Feature Requirements (v33.0)
- **Portable Mode:** Requires root for zram configuration
- **Arch Installer:** Requires root and internet connectivity
- **Expert CLI:** Works with any user level
- **Updater System:** Requires internet connectivity
- **Customization:** Works with any user level

### Recommended Environment
- Fresh Arch Linux installation or live environment
- Minimum 2GB RAM (4GB+ recommended for portable mode)
- Internet connection for full functionality
- Root access for system-level operations

---

## 🛠️ Contributing

Pull requests welcome! Please report issues or suggest features.  
Cosmic quotes and menu ideas always appreciated.

---

## 📜 License

[MIT](LICENSE)

---

## 🌌 Space Quotes (a few included):

> "To confine our attention to terrestrial matters would be to limit the human spirit." – Stephen Hawking  
> "We are made of star-stuff." – Carl Sagan  
> "The sky is not the limit. Your mind is." – Marilyn Monroe  

---

**Happy hacking, and may your system always boot!**  
🪐
