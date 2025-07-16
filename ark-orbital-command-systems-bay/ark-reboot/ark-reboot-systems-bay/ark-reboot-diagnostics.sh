#!/usr/bin/env bash
# 🛸 ARK Reboot Submodule: Diagnostics – ARK Ecosystem

ark_reboot_diagnostics() {
    local ARK_COLOR_YELLOW="\033[1;33m"
    local ARK_COLOR_GREEN="\033[1;32m"
    local ARK_COLOR_CYAN="\033[1;36m"
    local ARK_COLOR_RESET="\033[0m"
    local ARK_OK="✅"
    local ARK_WARN="⚠️"

    echo -e "${ARK_COLOR_CYAN}🧭 Running ARK Reboot Diagnostics...${ARK_COLOR_RESET}"
    echo "[ARK-REBOOT:DIAGNOSTICS] $(date '+%Y-%m-%d %H:%M:%S') - Commander: $USER - System: $(hostname)" >> ~/ark_orbital_restart.log

    # Basic checks
    echo -e "${ARK_COLOR_YELLOW}Checking ARK-Orbital-Command script...${ARK_COLOR_RESET}"
    if [[ -x "${SCRIPT_DIR:-.}/ark-orbital-command.sh" ]]; then
        echo -e "${ARK_COLOR_GREEN}${ARK_OK} ARK-Orbital-Command.sh is present and executable.${ARK_COLOR_RESET}"
    else
        echo -e "${ARK_COLOR_WARN} ARK-Orbital-Command.sh missing or not executable!${ARK_COLOR_RESET}"
    fi

    echo -e "${ARK_COLOR_YELLOW}Checking last 10 entries in reboot log...${ARK_COLOR_RESET}"
    if [[ -f ~/ark_orbital_restart.log ]]; then
        tail -n 10 ~/ark_orbital_restart.log
    else
        echo -e "${ARK_COLOR_WARN} No reboot log found.${ARK_COLOR_RESET}"
    fi

    echo -e "${ARK_COLOR_YELLOW}Checking fleet config...${ARK_COLOR_RESET}"
    if [[ -f "$HOME/.ark_fleet" ]]; then
        echo -e "${ARK_COLOR_GREEN}${ARK_OK} Fleet config found.${ARK_COLOR_RESET}"
        head -n 5 "$HOME/.ark_fleet"
    else
        echo -e "${ARK_COLOR_WARN} No .ark_fleet file found.${ARK_COLOR_RESET}"
    fi

    echo -e "${ARK_COLOR_CYAN}Diagnostics complete. Review any warnings above.${ARK_COLOR_RESET}"
    read -rp "Press [Enter] to return to the ARK Reboot menu..."
}