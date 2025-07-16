#!/usr/bin/env bash
# 🗝️ ARK SSH Manager v2.0.0 – Modular SSH Suite for The ARK

# ========== ARK PROTOCOL CONSTANTS ==========
ARK_SSH_MANAGER_VERSION="2.0.0"
ARK_COLOR_CYAN="\033[1;36m"
ARK_COLOR_PURPLE="\033[1;35m"
ARK_COLOR_RESET="\033[0m"
ARK_COLOR_BLUE="\033[1;34m"
ARK_COLOR_RED="\033[1;31m"

source "${ARK_CONFIG_PATH:-$HOME/.ark_config}"

# Import SSH submodules if present
SSH_GIT_MOD="${ARK_DOCK_PATH:-.}/ark-ssh-git.sh"
SSH_LOCAL_MOD="${ARK_DOCK_PATH:-.}/ark-ssh-local.sh"
SSH_REMOTE_MOD="${ARK_DOCK_PATH:-.}/ark-ssh-remote.sh"
SSH_HELP_MOD="${ARK_DOCK_PATH:-.}/ark-ssh-help.sh"
if [[ -r "$SSH_GIT_MOD" ]]; then source "$SSH_GIT_MOD"; fi
if [[ -r "$SSH_LOCAL_MOD" ]]; then source "$SSH_LOCAL_MOD"; fi
if [[ -r "$SSH_REMOTE_MOD" ]]; then source "$SSH_REMOTE_MOD"; fi
if [[ -r "$SSH_HELP_MOD" ]]; then source "$SSH_HELP_MOD"; fi

ark_ssh_manager_banner() {
    echo -e "${ARK_COLOR_CYAN}╔════════════════════════════════════════════════════════════════╗${ARK_COLOR_RESET}"
    printf "${ARK_COLOR_CYAN}║${ARK_COLOR_PURPLE}   🗝️  ARK SSH MANAGER – CENTRALIZED SSH CONTROL      %-6s${ARK_COLOR_CYAN}║${ARK_COLOR_RESET}\n" "v$ARK_SSH_MANAGER_VERSION"
    echo -e "${ARK_COLOR_CYAN}╚════════════════════════════════════════════════════════════════╝${ARK_COLOR_RESET}"
}

ark_ssh_manager_menu() {
    while true; do
        clear
        ark_ssh_manager_banner
        echo -e "${ARK_COLOR_BLUE} 1) 🔑 GitHub SSH Setup & Test"
        echo -e " 2) 🛡️  Local Terminal SSH Setup"
        echo -e " 3) 🛰️  Remote SSH Setup"
        echo -e " h) 🛰️  SSH Help Panel"
        echo -e " 0) Return to Main Menu${ARK_COLOR_RESET}"
        echo -e "${ARK_COLOR_BLUE}==============================================================${ARK_COLOR_RESET}"
        read -rp "➤ Select SSH module, Commander: " sshsel
        case "$sshsel" in
            1) ark_ssh_git_menu ;;
            2) ark_ssh_local_menu ;;
            3) ark_ssh_remote_menu ;;
            h|H) ark_ssh_help_panel ;;
            0) break ;;
            *)
                echo -e "${ARK_COLOR_RED}⚠️ Invalid selection, Commander.${ARK_COLOR_RESET}"
                sleep 1
                ;;
        esac
    done
}

# ====== ARK MODULE ENTRY POINT ======
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    ark_ssh_manager_menu
fi
