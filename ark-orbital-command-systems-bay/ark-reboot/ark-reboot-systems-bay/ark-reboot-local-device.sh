#!/usr/bin/env bash
# 🛸 ARK Reboot Submodule: Local Device Reboot

ark_reboot_local_reboot() {
    local ARK_COLOR_YELLOW="\033[1;33m"
    local ARK_COLOR_GREEN="\033[1;32m"
    local ARK_COLOR_RESET="\033[0m"
    local ARK_WARN="⚠️"
    local ARK_OK="✅"
    echo -e "${ARK_COLOR_YELLOW}${ARK_WARN} You are about to reboot this device.${ARK_COLOR_RESET}"
    read -rp "Are you sure? [y/N]: " confirm
    if [[ "$confirm" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        echo "[ARK-REBOOT:LOCAL] $(date '+%Y-%m-%d %H:%M:%S') - Commander: $USER - System: $(hostname)" >> ~/ark_orbital_restart.log
        sudo reboot
    else
        echo -e "${ARK_COLOR_GREEN}${ARK_OK} Local reboot cancelled.${ARK_COLOR_RESET}"
        sleep 1
    fi
}