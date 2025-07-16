#!/usr/bin/env bash
# 🛸 ARK Reboot Submodule: Fleet Reboot

ark_reboot_fleet() {
    local ARK_COLOR_YELLOW="\033[1;33m"
    local ARK_COLOR_CYAN="\033[1;36m"
    local ARK_COLOR_GREEN="\033[1;32m"
    local ARK_COLOR_RED="\033[1;31m"
    local ARK_COLOR_RESET="\033[0m"
    local ARK_SHIP="🛸"
    local ARK_OK="✅"
    local ARK_WARN="⚠️"
    local ARK_FAIL="❌"
    echo -e "${ARK_COLOR_YELLOW}${ARK_WARN} This will reboot ALL devices in your ARK fleet!${ARK_COLOR_RESET}"
    echo "Fleet device list is read from ~/.ark_fleet (one hostname or IP per line)."
    read -rp "Are you sure you want to reboot all fleet devices? [y/N]: " confirm
    if [[ ! "$confirm" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        echo -e "${ARK_COLOR_GREEN}${ARK_OK} Fleet reboot cancelled.${ARK_COLOR_RESET}"
        sleep 1
        return
    fi
    if [[ ! -f "$HOME/.ark_fleet" ]]; then
        echo -e "${ARK_COLOR_RED}${ARK_FAIL} No ~/.ark_fleet file found. Cannot reboot fleet.${ARK_COLOR_RESET}"
        sleep 2
        return
    fi
    while IFS= read -r host; do
        [[ -z "$host" || "$host" =~ ^# ]] && continue
        echo -e "${ARK_COLOR_CYAN}${ARK_SHIP} Rebooting $host...${ARK_COLOR_RESET}"
        ssh -o BatchMode=yes "$host" 'sudo reboot' && \
            echo -e "${ARK_COLOR_GREEN}${ARK_OK} Reboot command sent to $host${ARK_COLOR_RESET}" || \
            echo -e "${ARK_COLOR_RED}${ARK_FAIL} Failed to reboot $host${ARK_COLOR_RESET}"
        echo "[ARK-REBOOT:FLEET] $(date '+%Y-%m-%d %H:%M:%S') - Rebooted: $host" >> ~/ark_orbital_restart.log
    done < "$HOME/.ark_fleet"
    echo -e "${ARK_COLOR_GREEN}${ARK_OK} Fleet reboot complete. Devices will come back online shortly.${ARK_COLOR_RESET}"
    sleep 2
}