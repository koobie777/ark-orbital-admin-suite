#!/usr/bin/env bash
# 🛰️ ARK Submodule Template – For ARK Module Internals
# Copy, customize, and expand this template for submodule scripts INSIDE a module.
# Place this in your module's modules/ folder (e.g. modules/ark-foo/modules/ark-bar.sh)
# In future, a dedicated submodule folder structure will be standardized.

# ========== ARK THEME CONSTANTS ==========
ARK_COLOR_CYAN="\033[1;36m"
ARK_COLOR_PURPLE="\033[1;35m"
ARK_COLOR_GREEN="\033[1;32m"
ARK_COLOR_RESET="\033[0m"
ARK_SHIP="🛸"
ARK_OK="✅"
ARK_WARN="⚠️"
ARK_FAIL="❌"

# ========== SUBMODULE MAIN FUNCTION ==========
ark_submodule_template() {
    ark_submodule_banner
    echo -e "${ARK_COLOR_CYAN}${ARK_SHIP} This is an ARK Submodule Template, Commander!${ARK_COLOR_RESET}"
    echo -e "${ARK_COLOR_GREEN}Copy, rename, and expand for submodules within a module.${ARK_COLOR_RESET}"
    echo
    echo -e "${ARK_COLOR_PURPLE}Usage:${ARK_COLOR_RESET}"
    echo "  • Place in: modules/<your-module>/modules/"
    echo "  • Source and call from main module script."
    echo "  • Follow ARK theming, error handling, and modularity practices."
    echo
    echo -e "${ARK_COLOR_YELLOW}Example Function Call:${ARK_COLOR_RESET}"
    echo "  ark_submodule_template"
    echo
    echo -e "${ARK_COLOR_GREEN}May The ARK be with you!${ARK_COLOR_RESET}"
    read -rp "Press [Enter] to return, Commander..."
}

ark_submodule_banner() {
    echo -e "${ARK_COLOR_CYAN}╔══════════════════════════════════════════════════════╗${ARK_COLOR_RESET}"
    printf "${ARK_COLOR_CYAN}║${ARK_COLOR_PURPLE}   🛸  ARK SUBMODULE TEMPLATE FOR MODULES      ${ARK_COLOR_CYAN}║${ARK_COLOR_RESET}\n"
    echo -e "${ARK_COLOR_CYAN}╚══════════════════════════════════════════════════════╝${ARK_COLOR_RESET}"
}

# ========== END OF SUBMODULE TEMPLATE ==========
