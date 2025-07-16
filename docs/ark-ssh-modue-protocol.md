# 🗝️ ARK SSH Suite Protocol

**Centralized, modular SSH management for The ARK fleet.**

---

## Structure

```plaintext
ark-ssh/
├── ark-ssh.sh                # Main SSH manager
└── submodules/
    ├── ark-ssh-git.sh        # GitHub SSH onboarding & test
    ├── ark-ssh-local.sh      # Local key management
    ├── ark-ssh-remote.sh     # Fleet SSH setup & hardening
    ├── ark-ssh-utils.sh      # Shared helpers
    └── ark-ssh-help.sh       # Protocol help panel
```
- Loader in `ark-ssh.sh` sources all from `submodules/` (preferred)
- If `submodules/` missing, falls back to root

---

## Protocols

- **All SSH actions return to the ARK SSH menu, never exit tmux**
- **All errors use ARK formatting**
- **All scripts are modular, ready for copy/paste or promotion to full module**
- **Fleet onboarding and hardening supported**

---

## Example Loader

```bash
# In ark-ssh.sh
ARK_MODULE_DIR="$(dirname "$0")"
ARK_SUBMODULES_DIR="$ARK_MODULE_DIR/submodules"
if [[ -d "$ARK_SUBMODULES_DIR" ]]; then
    for f in "$ARK_SUBMODULES_DIR"/*.sh; do [[ -f "$f" ]] && source "$f"; done
else
    for f in "$ARK_MODULE_DIR"/*.sh; do [[ "$f" == "$0" ]] && continue; [[ -f "$f" ]] && source "$f"; done
fi
```

---

May The ARK be with you!
