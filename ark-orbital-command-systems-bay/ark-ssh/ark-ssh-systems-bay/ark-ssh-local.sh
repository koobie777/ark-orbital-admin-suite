#!/usr/bin/env bash
# 🛡️ ARK SSH Local Submodule v2.0.0 – Local Terminal SSH Setup for The ARK

# ========== ARK PROTOCOL CONSTANTS ==========
ARK_COLOR_CYAN="\033[1;36m"
ARK_COLOR_PURPLE="\033[1;35m"
ARK_COLOR_RESET="\033[0m"
ARK_COLOR_BLUE="\033[1;34m"
ARK_COLOR_YELLOW="\033[1;33m"
ARK_COLOR_GREEN="\033[1;32m"
ARK_COLOR_RED="\033[1;31m"
ARK_OK="✅"
ARK_WARN="⚠️"
ARK_FAIL="❌"

ark_ssh_local_menu() {
    while true; do
        clear
        echo -e "${ARK_COLOR_CYAN}🛡️  ARK Local Terminal SSH Setup${ARK_COLOR_RESET}"
        echo -e "${ARK_COLOR_BLUE}==============================================${ARK_COLOR_RESET}"
        echo -e " 1) Generate new local SSH key"
        echo -e " 2) List local SSH keys"
        echo -e " 3) Copy public key to clipboard"
        echo -e " 4) View ~/.ssh/config"
        echo -e " 0) Return to SSH Manager"
        echo -e "${ARK_COLOR_BLUE}==============================================${ARK_COLOR_RESET}"
        read -rp "➤ Select local SSH action, Commander: " loc_ssh_sel
        case "$loc_ssh_sel" in
            1) ark_local_generate_ssh_key ;;
            2) ark_local_list_ssh_keys ;;
            3) ark_local_copy_pubkey ;;
            4) ark_local_view_config ;;
            0) break ;;
            *) echo -e "${ARK_COLOR_RED}${ARK_WARN} Invalid selection, Commander.${ARK_COLOR_RESET}"; sleep 1 ;;
        esac
    done
}

ark_local_generate_ssh_key() {
    echo -e "${ARK_COLOR_BLUE}Generating a new SSH key for local use (ed25519 recommended)...${ARK_COLOR_RESET}"
    read -rp "Filename for key (default: ~/.ssh/id_ed25519_local): " keyfile
    keyfile="${keyfile:-$HOME/.ssh/id_ed25519_local}"
    if [[ -f "$keyfile" ]]; then
        echo -e "${ARK_COLOR_YELLOW}${ARK_WARN} Key already exists at $keyfile. Overwrite? [y/N]${ARK_COLOR_RESET}"
        read -r confirm
        [[ "$confirm" =~ ^[Yy]$ ]] || return
    fi
    ssh-keygen -t ed25519 -f "$keyfile"
    echo -e "${ARK_COLOR_GREEN}${ARK_OK} Local SSH key generated at $keyfile${ARK_COLOR_RESET}"
    read -rp "Press [Enter] to return to menu..."
}

ark_local_list_ssh_keys() {
    echo -e "${ARK_COLOR_PURPLE}Available SSH keys in ~/.ssh:${ARK_COLOR_RESET}"
    ls -l ~/.ssh/id_*.pub 2>/dev/null || echo "No keys found."
    read -rp "Press [Enter] to return to menu..."
}

ark_local_copy_pubkey() {
    read -rp "Filename of public key to copy (default: ~/.ssh/id_ed25519_local.pub): " pubkey
    pubkey="${pubkey:-$HOME/.ssh/id_ed25519_local.pub}"
    if [[ -f "$pubkey" ]]; then
        if command -v xclip >/dev/null 2>&1; then
            xclip -sel clip < "$pubkey"
            echo -e "${ARK_COLOR_GREEN}${ARK_OK} Public key copied to clipboard (X11/xclip).${ARK_COLOR_RESET}"
        elif command -v pbcopy >/dev/null 2>&1; then
            pbcopy < "$pubkey"
            echo -e "${ARK_COLOR_GREEN}${ARK_OK} Public key copied to clipboard (macOS/pbcopy).${ARK_COLOR_RESET}"
        else
            echo -e "${ARK_COLOR_RED}${ARK_WARN} No clipboard utility found. Install xclip or pbcopy.${ARK_COLOR_RESET}"
        fi
    else
        echo -e "${ARK_COLOR_RED}${ARK_FAIL} No public key found at $pubkey${ARK_COLOR_RESET}"
    fi
    read -rp "Press [Enter] to return to menu..."
}

ark_local_view_config() {
    if [[ -f "$HOME/.ssh/config" ]]; then
        echo -e "${ARK_COLOR_YELLOW}~/.ssh/config contents:${ARK_COLOR_RESET}"
        cat "$HOME/.ssh/config"
    else
        echo -e "${ARK_COLOR_RED}${ARK_FAIL} No ~/.ssh/config found.${ARK_COLOR_RESET}"
    fi
    read -rp "Press [Enter] to return to menu..."
}

# End of ARK SSH Local Submodule
