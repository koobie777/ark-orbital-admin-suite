#!/usr/bin/env bash
# 🛸 ARK Reboot Submodule: Log View – ARK Ecosystem

ark_reboot_log_view() {
    local ARK_COLOR_GREEN="\033[1;32m"
    local ARK_COLOR_RED="\033[1;31m"
    local ARK_COLOR_RESET="\033[0m"
    local ARK_OK="✅"
    local ARK_FAIL="❌"

    local LOG=~/ark_orbital_restart.log

    if [[ -f "$LOG" ]]; then
        echo -e "${ARK_COLOR_GREEN}${ARK_OK} Showing last 30 entries from ARK Reboot Log:${ARK_COLOR_RESET}"
        tail -n 30 "$LOG" | less
    else
        echo -e "${ARK_COLOR_RED}${ARK_FAIL} No reboot log found.${ARK_COLOR_RESET}"
        sleep 1
    fi
}