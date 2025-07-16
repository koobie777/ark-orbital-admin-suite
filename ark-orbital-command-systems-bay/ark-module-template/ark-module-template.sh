#!/usr/bin/env bash
# 🛰️ ARK Module Template – For ARK Ecosystem Developers
# Copy, customize, and expand this template to create your own ARK module.
# Place this file in the root of your module repo (e.g. modules/ark-foo/)

# ========== ARK THEME CONSTANTS ==========
ARK_COLOR_CYAN="\033[1;36m"
ARK_COLOR_PURPLE="\033[1;35m"
ARK_COLOR_GREEN="\033[1;32m"
ARK_COLOR_RESET="\033[0m"
ARK_SHIP="🛸"
ARK_OK="✅"
ARK_WARN="⚠️"
ARK_FAIL="❌"

# ========== MODULE MAIN FUNCTION ==========
ark_module_template() {
    ark_module_banner
    echo -e "${ARK_COLOR_CYAN}${ARK_SHIP} Welcome to your new ARK Module, Commander!${ARK_COLOR_RESET}"
    echo -e "${ARK_COLOR_GREEN}This is a template. Copy this file, rename functions and variables, and expand as needed.${ARK_COLOR_RESET}"
    echo
    echo -e "${ARK_COLOR_PURPLE}Recommended Practices:${ARK_COLOR_RESET}"
    echo "  • Use ARK color and icon protocol for all output."
    echo "  • Accept parameters if needed."
    echo "  • Always return to main menu or calling function after completion."
    echo "  • Never exit the ARK main process or tmux session."
    echo "  • Support both Expert (minimal) and Cadet (step-by-step) modes if needed."
    echo "  • Use robust error handling with ARK-styled prompts."
    echo "  • Modularize your code for future extension."
    echo
    echo -e "${ARK_COLOR_YELLOW}Example Function Call:${ARK_COLOR_RESET}"
    echo "  ark_module_template"
    echo
    echo -e "${ARK_COLOR_GREEN}May The ARK be with you!${ARK_COLOR_RESET}"
    read -rp "Press [Enter] to return, Commander..."
}

ark_module_banner() {
    echo -e "${ARK_COLOR_CYAN}╔══════════════════════════════════════════════════════╗${ARK_COLOR_RESET}"
    printf "${ARK_COLOR_CYAN}║${ARK_COLOR_PURPLE}   🛸  ARK MODULE TEMPLATE FOR DEVELOPERS      ${ARK_COLOR_CYAN}║${ARK_COLOR_RESET}\n"
    echo -e "${ARK_COLOR_CYAN}╚══════════════════════════════════════════════════════╝${ARK_COLOR_RESET}"
}

# ========== END OF MODULE TEMPLATE ==========
