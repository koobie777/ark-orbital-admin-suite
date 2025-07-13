# 🚀 The ARK Orbital Command Admin Suite

**Version 34.2** | **The ARK Ecosystem** | **Commander: koobie777**

A comprehensive Android development environment setup and management tool for Arch Linux systems, designed specifically for The ARK ecosystem of Android devices.

## ✨ Features

### 🛰️ Core Capabilities
- **Automated Android Development Setup** - Complete toolchain installation
- **Hardware Optimization** - System tuning for Android compilation
- **GitHub Integration** - Passwordless SSH key management
- **Fleet Management** - Multi-device Android ecosystem support
- **Configurable ARK Greeting** - Personalized terminal experience

### 🔧 Development Tools
- **Essential Packages** - Base development tools and Android SDK
- **AUR Helper** - Automated yay installation and management
- **USB Rules** - Android device detection and access
- **ccache Setup** - Compilation caching for faster builds
- **System Optimization** - File watchers and performance tuning

### ⚙️ ARK Configuration System
- **Greeting Styles** - Full, minimal, or silent startup
- **Commander Personalization** - Custom names and messages
- **SSH Management** - Automated passwordless GitHub setup
- **Fleet Status** - Real-time device and tool monitoring

## 🚀 Quick Start

### Installation
```bash
# Clone The ARK Orbital Command Suite
git clone https://github.com/koobie777/ark-orbital-admin-suite.git
cd ark-orbital-admin-suite

# Make executable and run
chmod +x orbital-command-v34.2.sh
sudo ./orbital-command-v34.2.sh
```

### First Run Setup
1. **ARK Configuration** - Automatically creates `~/.ark_config`
2. **SSH Setup** - Generate passwordless keys for GitHub
3. **Essential Tools** - Install Android development packages
4. **System Optimization** - Configure for Android builds

## 📋 Menu Options

```
🚀 ARK Command Options:
  1) 🛠️  Install ARK Essential Tools
  2) ⚡ Optimize for Android Development  
  3) 🔑 Setup GitHub SSH (Passwordless)
  4) 📊 Show Fleet Status
  5) ⚙️  ARK Configuration Manager
  6) 🔄 Update System Packages
  7) 🧪 Test ARK Components
  0) 🌌 Exit ARK Orbital Command
```

## ⚙️ Configuration

The ARK ecosystem uses `~/.ark_config` for personalization:

```bash
# The ARK Ecosystem Configuration v34.2
ARK_GREETING_ENABLED=true
ARK_GREETING_STYLE="full"          # full, minimal, silent
ARK_COMMANDER_NAME="koobie777"
ARK_SYSTEM_NAME="arksupreme-mk1"
ARK_CUSTOM_MESSAGE="The ARK is ready, Commander!"
ARK_VERSION="v34.2"
ARK_SSH_AUTO_SETUP=true
ARK_SSH_PASSWORDLESS=true
ARK_DEV_MODE=true
```

### Greeting Styles
- **Full** - Complete ARK initialization display with version info
- **Minimal** - Brief "ARK ready" message
- **Silent** - No startup greeting (stealth mode)

## 🌌 The ARK Ecosystem

### Current Fleet
- **🛰️ Orbital Command** - Admin suite and system management
- **🔧 ARK Forge** - Android ROM building tool (in development)
- **📱 OnePlus 12 "Waffle"** - Primary development device
- **[CLASSIFIED DEVICES]** - Additional fleet members

### Integration Features
- **Passwordless Operations** - SSH keys without passphrases
- **Cross-Tool Communication** - Shared configurations
- **Fleet Status Monitoring** - Real-time device tracking
- **Automated Workflows** - Build and deployment pipelines

## 🛠️ Dependencies

### Required Packages
```bash
# Base system
base-devel git curl wget vim nano htop tree unzip zip p7zip rsync

# Android development
android-tools fastboot android-udev python python-pip java-openjdk
repo ccache schedtool squashfs-tools

# AUR helper
yay (automatically installed)
```

### System Requirements
- **OS** - Arch Linux (Manjaro, EndeavourOS supported)
- **Storage** - 50GB+ free space recommended
- **Memory** - 8GB+ RAM for Android compilation
- **Network** - Internet connection for package installation

## 🔧 Advanced Usage

### SSH Key Management
```bash
# The ARK automatically generates passwordless keys
ssh-keygen -t ed25519 -C "koobie777@arksupreme-mk1-ark-ecosystem" -f ~/.ssh/id_ed25519 -N ""

# Auto-configures GitHub connectivity
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519
    AddKeysToAgent yes
```

### Hardware Optimization
```bash
# File watcher limits for large Android projects
fs.inotify.max_user_watches=524288

# ccache configuration
export USE_CCACHE=1
export CCACHE_DIR="$HOME/.ccache"
ccache -M 50G
```

### USB Device Rules
```bash
# Android device access (/etc/udev/rules.d/51-android.rules)
SUBSYSTEM=="usb", ATTR{idVendor}=="22b8", MODE="0666", GROUP="plugdev"
SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", MODE="0666", GROUP="plugdev"
# ... additional vendor IDs
```

## 🧪 Testing

Use the built-in component tester:
```bash
# From the main menu, select option 7
🧪 Testing ARK Ecosystem Components
===================================
🔑 Testing GitHub SSH connection...
  ✅ GitHub SSH: OPERATIONAL
🛠️  Testing development tools...
  ✅ git: AVAILABLE
  ✅ fastboot: AVAILABLE
  ✅ adb: AVAILABLE
⚙️  Testing ARK configuration...
  ✅ ARK Config: LOADED
  ✅ Version: v34.2
```

## 📊 Version History

### v34.2 (2025-07-13)
- ✨ **NEW** - Configurable ARK greeting system
- ✨ **NEW** - Enhanced SSH key management (passwordless)
- ✨ **NEW** - ARK configuration manager
- ✨ **NEW** - Component testing suite
- 🔧 **IMPROVED** - Menu navigation and user experience
- 🔧 **IMPROVED** - Error handling and recovery
- 🐛 **FIXED** - SSH passphrase prompts eliminated

### v34.1 (Previous)
- Initial ARK ecosystem integration
- Basic Android development setup
- Fleet management foundation

## 🤝 Contributing

The ARK ecosystem welcomes contributions from fellow commanders:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/ark-enhancement`)
3. **Commit** your changes (`git commit -m 'Add ARK feature'`)
4. **Push** to the branch (`git push origin feature/ark-enhancement`)
5. **Open** a Pull Request

## 📄 License

This project is part of The ARK ecosystem and is available under the MIT License.

## 🌌 Support

- **Issues** - Report bugs and request features via GitHub Issues
- **Discussions** - Join The ARK community discussions
- **Documentation** - Comprehensive guides in the wiki

---

**May The ARK be with you!** 🚀

*The ARK Orbital Command Admin Suite - Powering Android development across the galaxy*
