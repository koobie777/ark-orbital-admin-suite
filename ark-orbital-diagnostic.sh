#!/usr/bin/env bash
# 🛰️ ARK Dock Diagnostics v2.3.0 – The ARK Ecosystem (Mission-LT Protocol, Advanced+)
# Updated: 2025-07-16

# ARK Color Protocol
ARK_COLOR_CYAN="\033[1;36m"
ARK_COLOR_PURPLE="\033[1;35m"
ARK_COLOR_RESET="\033[0m"
ARK_COLOR_YELLOW="\033[1;33m"
ARK_COLOR_GREEN="\033[1;32m"
ARK_COLOR_RED="\033[1;31m"
ARK_COLOR_BLUE="\033[1;34m"
ARK_OK="✅"
ARK_WARN="⚠️"
ARK_FAIL="❌"

echo -e "${ARK_COLOR_CYAN}╔════════════════════════════════════════════════════════════╗${ARK_COLOR_RESET}"
echo -e "${ARK_COLOR_CYAN}║${ARK_COLOR_PURPLE}   🛰️  ARK-Orbital-Command Dock Diagnostics (ADVANCED)${ARK_COLOR_CYAN} ║${ARK_COLOR_RESET}"
echo -e "${ARK_COLOR_CYAN}╚════════════════════════════════════════════════════════════╝${ARK_COLOR_RESET}"

echo
echo -e "${ARK_COLOR_BLUE}1.${ARK_COLOR_RESET} Checking ARK_DOCK_PATH/SCRIPT_DIR definitions & submodules..."
echo

grep -nE 'ARK_DOCK_PATH|SCRIPT_DIR' ark-orbital-command-systems-bay/*/*.sh | grep -v 'ark-orbital-command.sh' \
    && echo -e "${ARK_COLOR_WARN}${ARK_WARN} Found stray definitions above! Only set in ark-orbital-command.sh.${ARK_COLOR_RESET}" \
    || echo -e "${ARK_COLOR_GREEN}${ARK_OK} No unauthorized ARK_DOCK_PATH or SCRIPT_DIR definitions found.${ARK_COLOR_RESET}"

echo
echo -e "${ARK_COLOR_BLUE}2.${ARK_COLOR_RESET} Listing modules in $ARK_DOCK_PATH/ark-menu/ark-menu-systems-bay:"
ls -lh "$ARK_DOCK_PATH/ark-menu/ark-menu-systems-bay"

echo
echo -e "${ARK_COLOR_BLUE}3.${ARK_COLOR_RESET} Checking all scripts in $ARK_DOCK_PATH for readability and size:"
for mod in "$ARK_DOCK_PATH"/*/*.sh "$ARK_DOCK_PATH"/ark-menu/ark-menu-systems-bay/*.sh; do
    if [[ ! -r "$mod" ]]; then
        echo -e "${ARK_COLOR_RED}${ARK_FAIL} NOT READABLE: $mod${ARK_COLOR_RESET}"
    elif [[ ! -s "$mod" ]]; then
        echo -e "${ARK_COLOR_YELLOW}${ARK_WARN} EMPTY FILE: $mod${ARK_COLOR_RESET}"
    else
        echo -e "${ARK_COLOR_GREEN}${ARK_OK} OK: $(basename "$mod")${ARK_COLOR_RESET}"
    fi
done

echo
echo -e "${ARK_COLOR_BLUE}4.${ARK_COLOR_RESET} Sourcing test for ark-system-info-main-menu.sh..."
source "$ARK_DOCK_PATH/ark-menu/ark-menu-systems-bay/ark-system-info-main-menu.sh" 2>/dev/null \
    && type ark_system_info_main_menu \
    && echo -e "${ARK_COLOR_GREEN}${ARK_OK} ark_system_info_main_menu is loaded and available.${ARK_COLOR_RESET}" \
    || echo -e "${ARK_COLOR_RED}${ARK_FAIL} ark_system_info_main_menu NOT loaded! Check path, syntax, and function name.${ARK_COLOR_RESET}"

echo
echo -e "${ARK_COLOR_BLUE}5.${ARK_COLOR_RESET} Syntax check for all docked modules:"
errors=0
for mod in "$ARK_DOCK_PATH"/*/*.sh "$ARK_DOCK_PATH"/ark-menu/ark-menu-systems-bay/*.sh; do
    if ! bash -n "$mod" 2>/dev/null; then
        echo -e "${ARK_COLOR_RED}${ARK_FAIL} SYNTAX ERROR: $mod${ARK_COLOR_RESET}"
        errors=1
    fi
done
if [[ $errors -eq 0 ]]; then
    echo -e "${ARK_COLOR_GREEN}${ARK_OK} No syntax errors found in docked modules.${ARK_COLOR_RESET}"
fi

echo
echo -e "${ARK_COLOR_BLUE}6.${ARK_COLOR_RESET} Live sourcing emulation for ALL menu subsystems:"
for submod in "$ARK_DOCK_PATH"/ark-menu/ark-menu-systems-bay/*.sh; do
    echo -e "${ARK_COLOR_CYAN}Sourcing: $submod${ARK_COLOR_RESET}"
    source "$submod"
done
type ark_system_info_main_menu &>/dev/null \
    && echo -e "${ARK_COLOR_GREEN}${ARK_OK} ark_system_info_main_menu is available after emulation.${ARK_COLOR_RESET}" \
    || echo -e "${ARK_COLOR_RED}${ARK_FAIL} ark_system_info_main_menu still NOT loaded after emulation!${ARK_COLOR_RESET}"

echo
echo -e "${ARK_COLOR_CYAN}===== END OF ARK ADVANCED DOCK DIAGNOSTICS =====${ARK_COLOR_RESET}"

echo
echo -e "${ARK_COLOR_CYAN}May The ARK be with you, Commander!${ARK_COLOR_RESET}"
