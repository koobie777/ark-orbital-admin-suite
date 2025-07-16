#!/usr/bin/env bash
# 🫧 ARK Config Scrub Utility – Remove sensitive/personal data

ark_config_scrub() {
    local cfg="$HOME/.ark_config"
    echo -e "${ARK_COLOR_CYAN}🫧 Scrubbing personal data from ~/.ark_config...${ARK_COLOR_RESET}"
    cp "$cfg" "$cfg.bak"
    sed -i 's/^\(ARK_GITHUB_EMAIL\|ARK_GITHUB_USER\|ARK_REMOTE_USER\|ARK_REMOTE_HOST\)=.*$/\1="REDACTED"/' "$cfg"
    echo -e "${ARK_COLOR_GREEN}✅ Personal data scrubbed (backup: ~/.ark_config.bak).${ARK_COLOR_RESET}"
    read -rp "Press [Enter] to continue, Commander..."
}

# ====== ENTRY POINT ======
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    ark_config_scrub
fi
