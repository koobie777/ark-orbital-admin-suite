#!/usr/bin/env bash
# 🛰️ ARK SSH Help Panel v2.0.0 – Protocol Reference for The ARK

ARK_COLOR_CYAN="\033[1;36m"
ARK_COLOR_PURPLE="\033[1;35m"
ARK_COLOR_RESET="\033[0m"
ARK_COLOR_BLUE="\033[1;34m"
ARK_COLOR_YELLOW="\033[1;33m"
ARK_COLOR_GREEN="\033[1;32m"

ark_ssh_help_panel() {
    echo -e "${ARK_COLOR_CYAN}╔══════════════════════════════════════════════════╗${ARK_COLOR_RESET}"
    echo -e "${ARK_COLOR_CYAN}║${ARK_COLOR_PURPLE}   🛰️  ARK SSH Universal Help Panel         ${ARK_COLOR_CYAN}║${ARK_COLOR_RESET}"
    echo -e "${ARK_COLOR_CYAN}╚══════════════════════════════════════════════════╝${ARK_COLOR_RESET}"
    echo -e "${ARK_COLOR_YELLOW}This panel covers:${ARK_COLOR_RESET}"
    echo -e "${ARK_COLOR_GREEN}  - SSH key management (local, GitHub, remote)"
    echo -e "  - Secure onboarding of ARK devices"
    echo -e "  - Passwordless login setup & hardening"
    echo -e "  - How to copy, test, or rotate keys"
    echo -e "  - ARK protocol: Always return to main menu, never exit tmux"
    echo -e ""
    echo -e "${ARK_COLOR_BLUE}Tips:${ARK_COLOR_RESET}"
    echo -e "  • Use 'ssh-add -l' to list loaded keys"
    echo -e "  • Use 'ssh-keygen -R host' to remove old host keys"
    echo -e "  • For GitHub: Add new SSH keys at github.com > Settings > SSH and GPG keys"
    echo -e "  • For remote: Use 'ssh-copy-id' to deploy public keys to new ARK fleet members"
    echo -e ""
    echo -e "${ARK_COLOR_YELLOW}Press [Enter] to return, Commander.${ARK_COLOR_RESET}"
    read
}
