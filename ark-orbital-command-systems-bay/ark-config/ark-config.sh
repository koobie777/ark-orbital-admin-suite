#!/usr/bin/env bash
# 🛸 ARK Config Module – Centralized Privacy/Security – DO NOT COMMIT REAL SECRETS
# ARK-Ecosystem protocol, copy/paste ready

# Hostname fallback protocol
if command -v hostname >/dev/null 2>&1; then
    ARK_SYSTEM_NAME="$(hostname)"
else
    ARK_SYSTEM_NAME="ark-device"
fi

# ARK_REVEAL privacy toggle (default off)
: "${ARK_REVEAL:=0}"

# General ARK settings (values loaded from ~/.ark_config at runtime)
ARK_GREETING_ENABLED=true
ARK_GREETING_STYLE="full"
ARK_COMMANDER_NAME="Commander"
# ARK_SYSTEM_NAME set above (never $(hostname) inline!)
ARK_CUSTOM_MESSAGE="The ARK is ready, Commander!"
ARK_VERSION="v40.0.0"
ARK_SSH_AUTO_SETUP=true
ARK_SSH_PASSWORDLESS=true
ARK_DEV_MODE=true
ARK_AUTO_UPDATE=false

# Privacy and SSH
ARK_GITHUB_EMAIL="your@email.com"
ARK_GITHUB_USER="yourgithubuser"
ARK_LOCAL_SSH_COMMENT="local@theark"
ARK_LOCAL_SSH_KEY="$HOME/.ssh/id_ed25519_local"
ARK_REMOTE_USER="commander"
ARK_REMOTE_HOST="ark-remote-host"  # e.g., 192.168.1.100 or myvps

# Future expansion: add more ARK_ variables ONLY here

# ====== ARK MODULE ENTRY POINT ======
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "This is the ARK config template. Edit ~/.ark_config with your own settings, Commander."
fi
