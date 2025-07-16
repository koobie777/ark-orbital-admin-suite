#!/usr/bin/env bash
# ✏️  ARK Config Edit Utility – ARK-Ecosystem protocol

ark_config_edit() {
    echo -e "${ARK_COLOR_CYAN}✏️  ARK CONFIG EDITOR${ARK_COLOR_RESET}"
    if [[ -z "$EDITOR" ]]; then
        export EDITOR=nano
    fi
    "$EDITOR" "$HOME/.ark_config"
    echo -e "${ARK_COLOR_GREEN}✅ ~/.ark_config saved.${ARK_COLOR_RESET}"
    read -rp "Press [Enter] to continue, Commander..."
}

# ====== ENTRY POINT ======
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    ark_config_edit
fi
