#!/usr/bin/env bash
# 🛰️ ARK-Forge Launcher Module for The ARK Ecosystem (v2.2.0 Fleet Renaissance)
# Modular, robust, ARK-themed, now with submodule support for discovery, status, config, and recovery

# =========================
# 🌌 ARK THEME CONSTANTS 🌌
# =========================
ARK_COLOR_CYAN="\033[1;36m"
ARK_COLOR_PURPLE="\033[1;35m"
ARK_COLOR_GREEN="\033[1;32m"
ARK_COLOR_RESET="\033[0m"
ARK_COLOR_YELLOW="\033[1;33m"
ARK_COLOR_RED="\033[1;31m"
ARK_SHIP="🛸"
ARK_OK="✅"
ARK_WARN="⚠️"
ARK_FAIL="❌"
ARK_FORGE_VERSION="2.2.0"
ARK_SYSTEMS_BAY="$(dirname "${BASH_SOURCE[0]}")/ark-forge-launcher-systems-bay"

ark_forge_banner() {
    echo -e "${ARK_COLOR_CYAN}╔════════════════════════════════════════════════════════════════╗${ARK_COLOR_RESET}"
    printf "${ARK_COLOR_CYAN}║${ARK_COLOR_PURPLE}   🚀  ARK-FORGE LAUNCHER MODULE               %-12s${ARK_COLOR_CYAN}║${ARK_COLOR_RESET}\n" "v$ARK_FORGE_VERSION"
    printf "${ARK_COLOR_CYAN}║${ARK_COLOR_GREEN}   Launch and manage ARK-Forge in The ARK Fleet          ${ARK_COLOR_CYAN}║${ARK_COLOR_RESET}\n"
    echo -e "${ARK_COLOR_CYAN}╚════════════════════════════════════════════════════════════════╝${ARK_COLOR_RESET}"
}

# Submodule: Discovery
ark_forge_discovery() {
    local script="$ARK_SYSTEMS_BAY/ark-forge-discovery.sh"
    [[ -x "$script" ]] && "$script"
}

# Submodule: Status
ark_forge_status() {
    local script="$ARK_SYSTEMS_BAY/ark-forge-status.sh"
    [[ -x "$script" ]] && "$script"
}

# Submodule: Config
ark_forge_config() {
    local script="$ARK_SYSTEMS_BAY/ark-forge-config.sh"
    [[ -x "$script" ]] && "$script"
}

# Submodule: Recovery
ark_forge_recovery() {
    local script="$ARK_SYSTEMS_BAY/ark-forge-recovery.sh"
    [[ -x "$script" ]] && "$script"
}

# Find ARK-Forge launcher (meta-repo and systems bay protocol)
ark_forge_find_launcher() {
    local candidates=(
        "$ARK_DOCK_PATH/../ARK-Forge/ark-forge.sh"
        "$HOME/ARK-Forge/ark-forge.sh"
        "$PWD/ARK-Forge/ark-forge.sh"
        "$PWD/ark-forge.sh"
        "/usr/local/bin/ark-forge"
    )
    for path in "${candidates[@]}"; do
        if [[ -x "$path" ]]; then
            echo "$path"
            return 0
        fi
    done
    return 1
}

ark_forge_launcher_menu() {
    ark_forge_banner
    echo -e "${ARK_COLOR_PURPLE}ARK-Forge Systems Bay Options:${ARK_COLOR_RESET}"
    echo "  1) Launch ARK-Forge"
    echo "  2) ARK-Forge Discovery"
    echo "  3) ARK-Forge Status"
    echo "  4) ARK-Forge Config"
    echo "  5) ARK-Forge Recovery"
    echo "  0) Return to main menu"
    echo
    read -rp "Choose an option [1-5,0]: " choice
    case "$choice" in
        1) ark_forge_launcher ;;
        2) ark_forge_discovery ;;
        3) ark_forge_status ;;
        4) ark_forge_config ;;
        5) ark_forge_recovery ;;
        0) return ;;
        *) echo -e "${ARK_COLOR_WARN}Invalid option, Commander.${ARK_COLOR_RESET}" ;;
    esac
}

ark_forge_launcher() {
    clear
    ark_forge_banner
    local launcher
    launcher="$(ark_forge_find_launcher)"
    if [[ -n "$launcher" ]]; then
        echo -e "${ARK_COLOR_GREEN}${ARK_OK} Found ARK-Forge launcher at: $launcher${ARK_COLOR_RESET}"
        echo -e "${ARK_COLOR_CYAN}Launching ARK-Forge...${ARK_COLOR_RESET}"
        sleep 1
        # Always launch in the same tmux session as ARK-Orbital-Command
        if [[ -n "$TMUX" ]]; then
            bash "$launcher"
        else
            echo -e "${ARK_COLOR_YELLOW}${ARK_WARN} Not running inside tmux! For ARK protocol, you should use tmux for session management.${ARK_COLOR_RESET}"
            bash "$launcher"
        fi
    else
        echo -e "${ARK_COLOR_RED}${ARK_FAIL} ARK-Forge launcher not found in standard fleet locations.${ARK_COLOR_RESET}"
        echo -e "${ARK_COLOR_YELLOW}Please ensure ARK-Forge is initialized as a submodule or installed."
        echo "Searched locations:"
        for loc in "${candidates[@]}"; do
            echo "  $loc"
        done
        echo -e "\"I'll guide you, Commander.\"${ARK_COLOR_RESET}"
        ark_forge_recovery
        read -rp "Press [Enter] to return to the main menu, Commander..."
    fi
}

# ====== ARK MODULE ENTRY POINT ======
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    ark_forge_launcher_menu
fi
