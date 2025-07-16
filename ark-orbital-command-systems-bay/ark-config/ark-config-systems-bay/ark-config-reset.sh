#!/usr/bin/env bash
# ♻️  ARK Config Reset Utility – Restore defaults

ark_config_reset() {
    echo -e "${ARK_COLOR_CYAN}♻️  Resetting ~/.ark_config to defaults...${ARK_COLOR_RESET}"
    cp "${BASH_SOURCE[0]%/*}/../ark-config.sh" "$HOME/.ark_config"
    echo -e "${ARK_COLOR_GREEN}✅ ~/.ark_config reset to defaults.${ARK_COLOR_RESET}"
    read -rp "Press [Enter] to continue, Commander..."
}

# ====== ENTRY POINT ======
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    ark_config_reset
fi
