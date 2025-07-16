#!/usr/bin/env bash
# 🛸 ARK Reboot Submodule: Orbital UI Restart

ark_reboot_orbital_ui() {
    local ARK_COLOR_CYAN="\033[1;36m"
    local ARK_COLOR_RED="\033[1;31m"
    local ARK_COLOR_RESET="\033[0m"
    local ARK_SHIP="🛸"
    local ARK_FAIL="❌"
    echo -e "${ARK_COLOR_CYAN}${ARK_SHIP} Restarting ARK-Orbital-Command UI...${ARK_COLOR_RESET}"
    echo "[ARK-REBOOT:UI] $(date '+%Y-%m-%d %H:%M:%S') - Commander: $USER - System: $(hostname)" >> ~/ark_orbital_restart.log
    sleep 1
    if [[ -x "${SCRIPT_DIR:-.}/ark-orbital-command.sh" ]]; then
        exec "${SCRIPT_DIR:-.}/ark-orbital-command.sh"
    else
        echo -e "${ARK_COLOR_RED}${ARK_FAIL} [RESTART ERROR]\nLocation: Orbital UI\nFix: ${SCRIPT_DIR:-.}/ark-orbital-command.sh not found or not executable.\n\"I'll guide you, Commander.\"${ARK_COLOR_RESET}"
        sleep 2
    fi
}