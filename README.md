# 🛰️ ARK-Orbital-Command – The ARK Ecosystem Central Hub

**Version v42.1.0 (Fleet Renaissance+)**  
**The ARK Ecosystem** | **Commander: koobie777**

---

> **ADMIRAL'S LOG:**  
> **ARK-Orbital-Command is the command center of The ARK—your modular, tmux-powered, multi-device build fleet and admin system.**  
> All modules, tools, and scripts are managed and launched from here, with every menu, tool, and script presenting a detailed status report before returning—never flashes or terminates instantly.

---

## ✨ Central Fleet Features

- **Centralized Hub:** All orchestration, diagnostics, and launches flow through ARK-Orbital-Command.
- **Unified Modular Ecosystem:** Every module is docked as a submodule, auto-loaded at boot, and managed via the ARK-Ecosystem meta-repo.
- **Automated Android & DevOps Setup:** Full toolchain, dependencies, and system tuning for builds.
- **Hardware Optimization & Monitoring:** Performance/powersave profiles, live fleet status, and system info panel at menu top.
- **GitHub/SSH Integration & Security:** Passwordless SSH, GitHub key management, and agent automation.
- **Personalized ARK Greeting:** Commander, system, and fleet identity at every ARK launch.
- **Effortless Module Expansion:** Drop-in protocol—add your tool to the dock, update the menu, and you're go for launch.
- **Unified ARK Theming:** Consistent colors, icons, status, and ARK-styled error handling across all modules.
- **Debug/Testing Protocol:** Every script pauses and shows a detailed summary/report before returning for review.
- **Full Change Tracking:** All updates logged for meta-repo and main branch merge/replace protocol.
- **Test Branches Protocol:** *Test branches allow Commander and community members to experiment, self-improve, or run community-contributed tests without impacting the main fleet (coming soon).*
- **Detailed Versioning:**  
  - Every script and module is versioned independently in its header (vX.Y.Z)
  - The ARK-Orbital-Command hub version is updated in both this README and `ark-orbital-command.sh`
  - Version changes and protocol upgrades are logged in the [Changelog](docs/changelog.md)
- **User-Friendly, Modular, and Fast:**  
  - Intuitive menu engine, built-in top panel with system info, and auto-detected submodules for rapid expansion and maintenance.
  - All scripts run in the same tmux session—never exit, always return to menu.
- **Systems-Bay Protocol:**  
  - All ARK menu submodules (mini-features, panels, diagnostics, extra menus) are stored in the `ark-menu/ark-menu-systems-bay/` directory.
  - These are auto-detected and sourced at menu launch—just drop a `.sh` file in the systems-bay to add features.
  - ARK-Orbital-Command and future ARK-Ecosystem-Essentials engines treat systems-bay directories as modular feature pools for each main module.

---

## 🚀 Installation & Launch

```bash
git clone https://github.com/koobie777/ARK-Orbital-Command.git
cd ARK-Orbital-Command
chmod +x ark-orbital-command.sh
./ark-orbital-command.sh
```

### 🛸 Install/Update/Remove Launcher & Menu Entries

To add, update, or remove ARK-Orbital-Command launchers and menu entries for your device and fleet, use:

```bash
chmod +x ark-orbital-command-setup.sh
./ark-orbital-command-setup.sh
```
- Run with no arguments for an interactive menu.
- Or use flags: `install`, `update`, `uninstall`, `help`

For launcher and menu integration details, see [`docs/INSTALL-INSTRUCTIONS.md`](docs/INSTALL-INSTRUCTIONS.md).

---

## 🛸 ARK Protocol: Main Menu (Sample)

```
🛰️  ARK-Orbital-Command – The ARK Fleet Hub
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🛰️  ARK SYSTEM PANEL v5.4.0
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  1) 🛠️  Install ARK Essentials
  2) ⚡  Optimize System Hardware
  3) 🔑  GitHub/SSH Key Manager
  4) 📊  Fleet Status Dashboard
  5) ⚙️  Config Manager
  6) 🔄  System & Ecosystem Update
  7) 🧪  Diagnostics & Test Suite
  8) 🚀  Launch ARK-Forge
  9) 🛰️  System Information Panel
 10) 🎨  ARK Themes (coming soon)
 11) 🔄  Restart ARK Orbital Command
  0) 🌌  Exit to the Cosmos

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
All tools present a detailed report before returning.
May The ARK be with you, Commander!
```

---

## 🛰️ Modular Expansion & Systems-Bay Protocol

1. **Add a new module to `ark-orbital-command-dock/`** (see [`docs/MODULE-CREATION.md`](docs/MODULE-CREATION.md)).
2. **Add a menu entry in `ark-menu.sh` if needed.**  
   All submodules in `ark-menu/ark-menu-systems-bay/` are auto-sourced at menu launch.
3. **Systems-Bay Protocol:**  
   - Drop any `.sh` script in `ark-menu/ark-menu-systems-bay/` to add features, diagnostics, or panels.
   - No need to edit the main menu for systems-bay features—auto-detection and sourcing handled by ARK protocol.
   - Future ARK-Ecosystem-Essentials modules will use this protocol for easy modular expansion across The ARK.
4. **All tools must present a debug/status report before exit.**
5. **Future:** ARK-Orbital-Command will prompt Commander to add/remove newly detected modules and manage the menu from within the menu engine.

---

## 🌌 Debug, Testing & Error Protocol (MANDATORY)

- **No tool or menu "flashes" or exits instantly.**  
  Every script displays a detailed status report and prompts before returning.
- **All errors follow ARK-styled format:**
    ```
    ⚠️ [ERROR TYPE]
    Location: [component]
    Fix: [solution]
    "I'll guide you, Commander."
    ```
- **Full logs/summaries provided for Commander review and ecosystem diagnostics.**
- **Never exits tmux or ARK-Forge on error—always returns to menu.**

---

## 🛠️ Documentation

- **Install:** [`docs/INSTALL-INSTRUCTIONS.md`](docs/INSTALL-INSTRUCTIONS.md)
- **Module Creation:** [`docs/MODULE-CREATION.md`](docs/MODULE-CREATION.md)
- **Module Uninstall:** [`docs/MODULE-UNINSTALL.md`](docs/MODULE-UNINSTALL.md)
- **Changelog:** [`docs/changelog.md`](docs/changelog.md)
- **SSH Protocol:** [`ark-ssh-module-protocol.md`](ark-ssh-module-protocol.md)

---

## 🛰️ Ecosystem & Modular Protocol

- **Meta-repo:** [`@koobie777/ARK-Ecosystem`](https://github.com/koobie777/ARK-Ecosystem)
- **All modules are submodules:**  
  Update each in its own repo, then update the pointer in the meta-repo and commit.
- **Main branches are replaced with validated local changes at merge protocol.**
- **All changes are tracked for ARK-wide deployment and history.**
- **Test Branches (Coming Soon):**  
  Test branches will allow experimentation, rapid self-improvement for Commander, and safe execution of community-contributed protocols.
- **Future Protocols:**
  - ARK-Ecosystem-Essentials will unify menu, theme, and module management across all modules.
  - ARK theme engine will serve all modules, with dynamic theme switching and menu theming.
  - Systems-bay protocol will be core to modular expansion, letting Commanders add or remove features without touching core code.

---

## 📂 Directory Structure (as of v42.1.0)

```
ARK-Orbital-Command/
├── README.md
├── ark-diagnostic.sh
├── ark-orbital-command-setup.sh
├── ark-orbital-command.sh
├── ark-orbital-command-dock/
│   ├── ark-config/
│   ├── ark-essentials/
│   ├── ark-fleet/
│   ├── ark-forge-launcher/
│   ├── ark-greeting/
│   ├── ark-menu/
│   │   └── ark-menu-systems-bay/
│   │        ├── [submodules: .sh files]  # systems-bay, auto-sourced
│   ├── ark-module-template/
│   ├── ark-optimize/
│   ├── ark-restart-orbital-command/
│   ├── ark-ssh/
│   ├── ark-system-info/
│   ├── ark-test/
│   ├── ark-themes/
│   └── ark-update/
├── assets/
│   └── icons/
├── docs/
│   ├── INSTALL-INSTRUCTIONS.md
│   ├── MODULE-CREATION.md
│   ├── MODULE-UNINSTALL.md
│   └── changelog.md
├── logs/
└── reports/
```

**Launcher/Setup Script:**  
- The launcher/install script is named: `ark-orbital-command-setup.sh`
- Use this to install, update, or remove ARK-Orbital-Command menu/desktop entries for your device and fleet.

---

## 📊 Version History

See full [Changelog](docs/changelog.md) for all historic and current changes.

---

## 🤝 Contributing

- Fork, branch, PR—see ARK protocol in docs.
- Test branches (coming soon) will allow safe experimentation and feature submission.

---

## 📄 License

MIT License | The ARK Ecosystem

---

## 🌌 Support

- [GitHub Issues](https://github.com/koobie777/ARK-Ecosystem/issues)
- ARK Discord & Fleet Channels

---

**ARK-Orbital-Command: The command center for The ARK.  
May The ARK be with you, Commander!**
