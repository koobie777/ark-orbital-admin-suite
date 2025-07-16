#!/usr/bin/env bash
# 🛸 ARK Reboot Submodule: Help Panel

ark_reboot_help() {
    local ARK_COLOR_PURPLE="\033[1;35m"
    local ARK_COLOR_YELLOW="\033[1;33m"
    local ARK_COLOR_CYAN="\033[1;36m"
    local ARK_COLOR_RESET="\033[0m"
    echo -e "${ARK_COLOR_PURPLE}🛰️  ARK Reboot Help Panel${ARK_COLOR_RESET}"
    echo -e "${ARK_COLOR_YELLOW}Reboot Options:${ARK_COLOR_RESET}"
    echo "  1) Restarts only the ARK-Orbital-Command interface on this device (no full reboot)"
    echo "  2) Reboots this device (asks for confirmation)"
    echo "  3) Connects to all devices in your ARK fleet (from ~/.ark_fleet) and reboots them via SSH"
    echo "  4) Reloads ARK main menu and all modules (soft refresh, no session disruption)"
    echo -e "${ARK_COLOR_CYAN}All actions are logged to ~/ark_orbital_restart.log for fleet diagnostics.${ARK_COLOR_RESET}"
}