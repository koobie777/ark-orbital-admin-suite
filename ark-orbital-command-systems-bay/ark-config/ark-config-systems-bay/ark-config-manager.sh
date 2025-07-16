#!/usr/bin/env bash
# ⚙️  ARK Config Manager Module – ARK-Ecosystem protocol

# Theme constants (ensure available for all submodules)
ARK_COLOR_CYAN="\033[1;36m"
ARK_COLOR_BLUE="\033[1;34m"
ARK_COLOR_GREEN="\033[1;32m"
ARK_COLOR_RED="\033[1;31m"
ARK_COLOR_RESET="\033[0m"

# Source config
source "${ARK_CONFIG_PATH:-$HOME/.ark_config}"

# Import submodules
ARK_CFG_SETUP="${BASH_SOURCE[0]%/*}/ark-config-setup.sh"
ARK_CFG_EDIT="${BASH_SOURCE[0]%/*}/ark-config-edit.sh"
ARK_CFG_SCRUB="${BASH_SOURCE[0]%/*}/ark-config-scrub.sh"
ARK_CFG_VIEW="${BASH_SOURCE[0]%/*}/ark-config-view.sh"
ARK_CFG_RESET="${BASH_SOURCE[0]%/*}/ark-config-reset.sh"

[[ -r "$ARK_CFG_SETUP" ]] && source "$ARK_CFG_SETUP"
[[ -r "$ARK_CFG_EDIT"  ]] && source "$ARK_CFG_EDIT"
[[ -r "$ARK_CFG_SCRUB" ]] && source "$ARK_CFG_SCRUB"
[[ -r "$ARK_CFG_VIEW"  ]] && source "$ARK_CFG_VIEW"
[[ -r "$ARK_CFG_RESET" ]] && source "$ARK_CFG_RESET"

# Main manager menu
ark_config_manager() {
    while true; do
        clear
        echo -e "${ARK_COLOR_CYAN}⚙️  ARK CONFIG MANAGER${ARK_COLOR_RESET}"
        echo -e "${ARK_COLOR_BLUE}====================================${ARK_COLOR_RESET}"
        echo -e " 1) 🧭 Guided Setup"
        echo -e " 2) ✏️  Edit Config"
        echo -e " 3) 🫧 Scrub Personal Data"
        echo -e " 4) 👁️  View Config"
        echo -e " 5) ♻️  Reset to Defaults"
        echo -e " 0) Return to Main Menu"
        echo -e "${ARK_COLOR_BLUE}====================================${ARK_COLOR_RESET}"
        read -rp "➤ Select option, Commander: " opt
        case "$opt" in
            1) ark_config_setup ;;
            2) ark_config_edit ;;
            3) ark_config_scrub ;;
            4) ark_config_view ;;
            5) ark_config_reset ;;
            0) break ;;
            *) echo -e "${ARK_COLOR_RED}Invalid option, Commander.${ARK_COLOR_RESET}"; sleep 1 ;;
        esac
    done
}

# ====== ENTRY POINT ======
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    ark_config_manager
fi
