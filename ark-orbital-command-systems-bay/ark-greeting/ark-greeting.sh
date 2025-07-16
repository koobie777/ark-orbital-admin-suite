#!/usr/bin/env bash
# 🛰️ ARK Greeting Module – The ARK Ecosystem (v2.1.0 Fleet Renaissance)
# Robust, ARK-themed, modular, enhanced for ARK-Ecosystem and config protocol

ark_greeting() {
    ark_show_greeting
}

ark_show_greeting() {
    # Load config, support fallback and ARK theming
    local ark_config="${ARK_CONFIG_PATH:-$HOME/.ark_config}"
    if [[ ! -f "$ark_config" ]]; then
        echo -e "\033[1;31m❌ ARK config not found at $ark_config – skipping greeting.\033[0m"
        return 0
    fi
    # shellcheck disable=SC1090
    source "$ark_config" 2>/dev/null

    # ARK theme constants
    local ARK_COLOR_CYAN="\033[1;36m"
    local ARK_COLOR_PURPLE="\033[1;35m"
    local ARK_COLOR_GREEN="\033[1;32m"
    local ARK_COLOR_YELLOW="\033[1;33m"
    local ARK_COLOR_MAGENTA="\033[1;35m"
    local ARK_COLOR_RESET="\033[0m"
    local ARK_ICON_SHIP="🚀"
    local ARK_ICON_STAR="🌟"
    local ARK_ICON_WAVE="👋"
    local ARK_ICON_MOON="🌙"

    # Greeting logic
    if [[ "${ARK_GREETING_ENABLED,,}" == "true" ]]; then
        case "$ARK_GREETING_STYLE" in
            "full")
                echo -e "${ARK_COLOR_CYAN}${ARK_ICON_SHIP} Welcome to The ARK Ecosystem v${ARK_VERSION}${ARK_COLOR_RESET}"
                echo -e "${ARK_COLOR_PURPLE}Commander:${ARK_COLOR_GREEN} $ARK_COMMANDER_NAME ${ARK_COLOR_CYAN}|${ARK_COLOR_PURPLE} System:${ARK_COLOR_GREEN} $ARK_SYSTEM_NAME${ARK_COLOR_RESET}"
                echo -e "${ARK_COLOR_YELLOW}${ARK_ICON_STAR} $ARK_CUSTOM_MESSAGE${ARK_COLOR_RESET}"
                ;;
            "minimal")
                echo -e "${ARK_COLOR_CYAN}${ARK_ICON_SHIP} ARK v${ARK_VERSION} ready, $ARK_COMMANDER_NAME${ARK_COLOR_RESET}"
                ;;
            "silent"|"off"|"none")
                # No greeting
                ;;
            *)
                echo -e "${ARK_COLOR_CYAN}${ARK_ICON_SHIP} ARK v${ARK_VERSION} ready, $ARK_COMMANDER_NAME${ARK_COLOR_RESET}"
                ;;
        esac
    fi
}

# ====== ARK MODULE ENTRY POINT ======
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    ark_greeting
fi
