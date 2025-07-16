#!/usr/bin/env bash
# 👁️  ARK Config View Utility

ark_config_view() {
    echo -e "${ARK_COLOR_CYAN}👁️  Viewing ~/.ark_config:${ARK_COLOR_RESET}"
    cat "$HOME/.ark_config"
    read -rp "Press [Enter] to continue, Commander..."
}

# ====== ENTRY POINT ======
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    ark_config_view
fi
