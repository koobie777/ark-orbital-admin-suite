#!/usr/bin/env bash
# 🧭 ARK Config Guided Setup Utility

ark_config_setup() {
    echo -e "${ARK_COLOR_CYAN}🧭 Guided ARK Config Setup${ARK_COLOR_RESET}"
    local cfg="$HOME/.ark_config"
    echo -e "${ARK_COLOR_BLUE}Let's configure your ARK environment, Commander!${ARK_COLOR_RESET}"
    read -rp "Commander Name: " ARK_COMMANDER_NAME
    read -rp "System Name: " ARK_SYSTEM_NAME
    read -rp "Custom Greeting: " ARK_CUSTOM_MESSAGE
    read -rp "ARK Ecosystem Version: " ARK_VERSION
    read -rp "SSH Auto Setup (true/false): " ARK_SSH_AUTO_SETUP
    read -rp "SSH Passwordless (true/false): " ARK_SSH_PASSWORDLESS
    read -rp "Dev Mode (true/false): " ARK_DEV_MODE
    read -rp "Auto Update (true/false): " ARK_AUTO_UPDATE
    read -rp "GitHub Email: " ARK_GITHUB_EMAIL
    read -rp "GitHub User: " ARK_GITHUB_USER
    read -rp "Local SSH Key Comment: " ARK_LOCAL_SSH_COMMENT
    read -rp "Local SSH Key Path: " ARK_LOCAL_SSH_KEY
    read -rp "Remote User: " ARK_REMOTE_USER
    read -rp "Remote Host: " ARK_REMOTE_HOST

    cat > "$cfg" <<EOF
ARK_GREETING_ENABLED=true
ARK_GREETING_STYLE="full"
ARK_COMMANDER_NAME="$ARK_COMMANDER_NAME"
ARK_SYSTEM_NAME="$ARK_SYSTEM_NAME"
ARK_CUSTOM_MESSAGE="$ARK_CUSTOM_MESSAGE"
ARK_VERSION="$ARK_VERSION"
ARK_SSH_AUTO_SETUP=$ARK_SSH_AUTO_SETUP
ARK_SSH_PASSWORDLESS=$ARK_SSH_PASSWORDLESS
ARK_DEV_MODE=$ARK_DEV_MODE
ARK_AUTO_UPDATE=$ARK_AUTO_UPDATE
ARK_GITHUB_EMAIL="$ARK_GITHUB_EMAIL"
ARK_GITHUB_USER="$ARK_GITHUB_USER"
ARK_LOCAL_SSH_COMMENT="$ARK_LOCAL_SSH_COMMENT"
ARK_LOCAL_SSH_KEY="$ARK_LOCAL_SSH_KEY"
ARK_REMOTE_USER="$ARK_REMOTE_USER"
ARK_REMOTE_HOST="$ARK_REMOTE_HOST"
EOF
    echo -e "${ARK_COLOR_GREEN}✅ ~/.ark_config created.${ARK_COLOR_RESET}"
    read -rp "Press [Enter] to continue, Commander..."
}

# ====== ENTRY POINT ======
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    ark_config_setup
fi
