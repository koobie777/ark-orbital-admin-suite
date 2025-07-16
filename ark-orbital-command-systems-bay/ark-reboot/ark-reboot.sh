#!/usr/bin/env bash
# 🛸 ARK Reboot Module – Fleet Renaissance Edition (Commander koobie777, The ARK Ecosystem)
# Modular ARK Reboot handler with submodules for orbital UI, local, fleet, menu, diagnostics, and more.

ARK_REBOOT_VERSION="v4.0.0"

# ====== THEME CONSTANTS ======
ARK_COLOR_CYAN="\033[1;36m"
ARK_COLOR_PURPLE="\033[1;35m"
ARK_COLOR_GREEN="\033[1;32m"
ARK_COLOR_YELLOW="\033[1;33m"
ARK_COLOR_RED="\033[1;31m"
ARK_COLOR_RESET="\033[0m"
ARK_SHIP="🛸"
ARK_OK="✅"
ARK_WARN="⚠️"
ARK_FAIL="❌"

# ====== SUBMODULE SOURCING ======
REBOOT_BAY="${SCRIPT_DIR:-.}/ark-reboot/ark-reboot-systems-bay"
[[ -f "$REBOOT_BAY/ark-reboot-orbital-ui.sh" ]] && source "$REBOOT_BAY/ark-reboot-orbital-ui.sh"
[[ -f "$REBOOT_BAY/ark-reboot-local-device.sh" ]] && source "$REBOOT_BAY/ark-reboot-local-device.sh"
[[ -f "$REBOOT_BAY/ark-reboot-fleet.sh" ]] && source "$REBOOT_BAY/ark-reboot-fleet.sh"
[[ -f "$REBOOT_BAY/ark-reboot-help.sh" ]] && source "$REBOOT_BAY/ark-reboot-help.sh"
[[ -f "$REBOOT_BAY/ark-reboot-diagnostics.sh" ]] && source "$REBOOT_BAY/ark-reboot-diagnostics.sh"
[[ -f "$REBOOT_BAY/ark-reboot-menu.sh" ]] && source "$REBOOT_BAY/ark-reboot-menu.sh"
[[ -f "$REBOOT_BAY/ark-reboot-log-view.sh" ]] && source "$REBOOT_BAY/ark-reboot-log-view.sh"

# ====== MAIN MENU ======
ark_reboot_menu() {
    clear
    ark_reboot_banner
    echo -e "${ARK_COLOR_CYAN}Choose ARK reboot operation, Commander:${ARK_COLOR_RESET}"
    echo "  1) 🔄 Restart ARK-Orbital-Command UI (current device)"
    echo "  2) 🖥️  Reboot this device"
    echo "  3) 🚀 Reboot entire ARK fleet (requires SSH config)"
    echo "  4) 🔁 Refresh ARK UI (reload menu/modules)"
    echo "  5) 🧭 Diagnostics"
    echo "  6) 📄 View ARK Reboot Logs"
    echo "  h) 🛰️  Help"
    echo "  0) 🌌  Return to ARK Main Menu"
    echo -n "${ARK_COLOR_YELLOW}Enter selection: ${ARK_COLOR_RESET}"
    read -r choice
    case "$choice" in
        1) type ark_reboot_orbital_ui &>/dev/null && ark_reboot_orbital_ui || ark_reboot_error "orbital-ui" ;;
        2) type ark_reboot_local_reboot &>/dev/null && ark_reboot_local_reboot || ark_reboot_error "local-reboot" ;;
        3) type ark_reboot_fleet &>/dev/null && ark_reboot_fleet || ark_reboot_error "fleet-reboot" ;;
        4) type ark_reboot_refresh_orbital &>/dev/null && ark_reboot_refresh_orbital || ark_reboot_error "refresh-orbital" ;;
        5) type ark_reboot_diagnostics &>/dev/null && ark_reboot_diagnostics || ark_reboot_error "diagnostics" ;;
        6) type ark_reboot_log_view &>/dev/null && ark_reboot_log_view || ark_reboot_error "log-view" ;;
        h|H) type ark_reboot_help &>/dev/null && ark_reboot_help || ark_reboot_error "help" ; ark_reboot_menu ;;
        0) return ;;
        *) echo -e "${ARK_COLOR_RED}${ARK_FAIL} Invalid selection. Try again.${ARK_COLOR_RESET}"; sleep 1; ark_reboot_menu ;;
    esac
}

ark_reboot_banner() {
    echo -e "${ARK_COLOR_CYAN}╔══════════════════════════════════════════════════════════════╗${ARK_COLOR_RESET}"
    printf "${ARK_COLOR_CYAN}║${ARK_COLOR_PURPLE}   🔄  ARK REBOOT MODULE (ORBITAL COMMAND)      %-7s${ARK_COLOR_CYAN}║${ARK_COLOR_RESET}\n" "$ARK_REBOOT_VERSION"
    printf "${ARK_COLOR_CYAN}║${ARK_COLOR_GREEN}   Fleet-wide reboots & diagnostics for The ARK           ${ARK_COLOR_CYAN}║${ARK_COLOR_RESET}\n"
    echo -e "${ARK_COLOR_CYAN}╚══════════════════════════════════════════════════════════════╝${ARK_COLOR_RESET}"
}

ark_reboot_error() {
    local sub="$1"
    echo -e "${ARK_COLOR_RED}${ARK_FAIL} [MODULE ERROR]\nLocation: ARK Reboot ($sub)\nFix: Submodule not found or not loaded.\n\"I'll guide you, Commander.\"${ARK_COLOR_RESET}"
    read -rp "Press [Enter] to return to the ARK Reboot menu..."
}

# ====== REFRESH ORBITAL (soft reload) ======
ark_reboot_refresh_orbital() {
    echo -e "${ARK_COLOR_CYAN}${ARK_SHIP} Refreshing ARK-Orbital-Command UI (hot reload)...${ARK_COLOR_RESET}"
    echo "[ARK-REBOOT:REFRESH] $(date '+%Y-%m-%d %H:%M:%S') - Commander: $USER - System: $(hostname)" >> ~/ark_orbital_restart.log
    sleep 1
    if [[ -r "${SCRIPT_DIR:-.}/ark-orbital-command.sh" ]]; then
        source "${SCRIPT_DIR:-.}/ark-orbital-command.sh"
        echo -e "${ARK_COLOR_GREEN}${ARK_OK} ARK-Orbital-Command UI refreshed. Back to main menu.${ARK_COLOR_RESET}"
    else
        echo -e "${ARK_COLOR_RED}${ARK_FAIL} [REFRESH ERROR]\nLocation: ARK Reboot\nFix: ${SCRIPT_DIR:-.}/ark-orbital-command.sh not found.\n\"I'll guide you, Commander.\"${ARK_COLOR_RESET}"
        sleep 2
    fi
}

# ====== DIAGNOSTICS FALLBACK ======
ark_reboot_diagnostics() {
    echo -e "${ARK_COLOR_YELLOW}${ARK_WARN} Diagnostics module not yet implemented.${ARK_COLOR_RESET}"
    sleep 1
}

# ====== LOG VIEW FALLBACK ======
ark_reboot_log_view() {
    LOG=~/ark_orbital_restart.log
    if [[ -f "$LOG" ]]; then
        echo -e "${ARK_COLOR_GREEN}${ARK_OK} Showing ARK Reboot Log:${ARK_COLOR_RESET}"
        tail -n 30 "$LOG" | less
    else
        echo -e "${ARK_COLOR_RED}${ARK_FAIL} No reboot log found.${ARK_COLOR_RESET}"
        sleep 1
    fi
}

# ====== ENTRY POINT ======
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    ark_reboot_menu
fi

# End of ARK Reboot Module
