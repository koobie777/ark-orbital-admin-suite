#!/usr/bin/env bash
# 🛰️ ARK SYSTEM INFO – Modular Menu Wrapper – ADMIRAL A.R.K. Protocol

# ARK Theming
: "${ARK_COLOR_BLUE:=\033[1;34m}"
: "${ARK_COLOR_PURPLE:=\033[1;35m}"
: "${ARK_COLOR_CYAN:=\033[1;36m}"
: "${ARK_COLOR_YELLOW:=\033[1;33m}"
: "${ARK_COLOR_GREEN:=\033[1;32m}"
: "${ARK_COLOR_RED:=\033[1;31m}"
: "${ARK_COLOR_RESET:=\033[0m}"

# Source ARK config for privacy-aware info display
source "${ARK_CONFIG_PATH:-$HOME/.ark_config}"

# Attempt to source the main menu info module, fallback to ARK error if missing
ARK_SYSINFO_MAIN_MENU_PATH="$(dirname "${BASH_SOURCE[0]}")/ark-system-info-main-menu.sh"
if ! source "$ARK_SYSINFO_MAIN_MENU_PATH" 2>/dev/null; then
    echo -e "${ARK_COLOR_RED}⚠️ System Info Main Menu module not found at $ARK_SYSINFO_MAIN_MENU_PATH.${ARK_COLOR_RESET}"
    ark_system_info_main_menu() {
        echo -e "${ARK_COLOR_RED}⚠️ System status unavailable. No info module loaded.${ARK_COLOR_RESET}"
    }
fi

ark_system_info_pause() {
    echo
    read -rp "Press [Enter] to return to ARK System Info menu..."
}

ark_system_info_menu() {
    while true; do
        clear
        echo -e "${ARK_COLOR_BLUE}═ ${ARK_COLOR_PURPLE}ARK SYSTEM INFO${ARK_COLOR_BLUE} ═══════════════════════════════════════════════════════${ARK_COLOR_RESET}"
        if type ark_system_info_main_menu &>/dev/null; then
            ark_system_info_main_menu
        else
            echo -e "${ARK_COLOR_RED}⚠️ No system info module loaded.${ARK_COLOR_RESET}"
        fi
        echo -e "${ARK_COLOR_BLUE}───────────────────────────── ${ARK_COLOR_PURPLE}TOOLS${ARK_COLOR_BLUE} ──────────────────────────────${ARK_COLOR_RESET}"
        echo -e "${ARK_COLOR_GREEN} 1${ARK_COLOR_RESET}) ${ARK_COLOR_CYAN}Refresh Current Status"
        echo -e "${ARK_COLOR_GREEN} 2${ARK_COLOR_RESET}) ${ARK_COLOR_CYAN}System Tools (coming soon)"
        echo -e "${ARK_COLOR_GREEN} 3${ARK_COLOR_RESET}) ${ARK_COLOR_CYAN}Hardware Inventory (coming soon)"
        echo -e "${ARK_COLOR_GREEN} 4${ARK_COLOR_RESET}) ${ARK_COLOR_CYAN}Network Diagnostics (coming soon)"
        echo -e "${ARK_COLOR_GREEN} 5${ARK_COLOR_RESET}) ${ARK_COLOR_CYAN}Storage & Mounts (coming soon)"
        echo -e "${ARK_COLOR_GREEN} 6${ARK_COLOR_RESET}) ${ARK_COLOR_CYAN}[COMING SOON] Fleet Status"
        echo -e "${ARK_COLOR_GREEN} 0${ARK_COLOR_RESET}) ${ARK_COLOR_CYAN}Return to Main Menu"
        echo -e "${ARK_COLOR_BLUE}════════════════════════════════════════════════════════════════════════════${ARK_COLOR_RESET}"
        read -rp "➤ Enter selection, Commander: " sel
        case $sel in
            1)
                echo -e "${ARK_COLOR_YELLOW}Refreshing system status...${ARK_COLOR_RESET}"
                ark_system_info_main_menu
                ark_system_info_pause
                ;;
            2)
                echo -e "${ARK_COLOR_YELLOW}System Tools (coming soon):${ARK_COLOR_RESET}"
                ark_system_info_pause
                ;;
            3)
                echo -e "${ARK_COLOR_YELLOW}Hardware Inventory (coming soon):${ARK_COLOR_RESET}"
                ark_system_info_pause
                ;;
            4)
                echo -e "${ARK_COLOR_YELLOW}Network Diagnostics (coming soon):${ARK_COLOR_RESET}"
                ark_system_info_pause
                ;;
            5)
                echo -e "${ARK_COLOR_YELLOW}Storage & Mounts (coming soon):${ARK_COLOR_RESET}"
                ark_system_info_pause
                ;;
            6)
                echo -e "${ARK_COLOR_YELLOW}Fleet Status (coming soon):${ARK_COLOR_RESET}"
                ark_system_info_pause
                ;;
            0) break ;;
            *)
                echo -e "${ARK_COLOR_RED}Invalid option, Commander.${ARK_COLOR_RESET}"
                sleep 1
                ;;
        esac
    done
}
# DO NOT CALL ark_system_info_menu AT END
