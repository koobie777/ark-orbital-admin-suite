#!/usr/bin/env bash
# 🛸 ARK SSH Utilities v2.0.0 – Shared SSH Functions for The ARK

# ARK color constants (shared, import in all SSH modules)
ARK_COLOR_CYAN="\033[1;36m"
ARK_COLOR_PURPLE="\033[1;35m"
ARK_COLOR_RESET="\033[0m"
ARK_COLOR_BLUE="\033[1;34m"
ARK_COLOR_YELLOW="\033[1;33m"
ARK_COLOR_GREEN="\033[1;32m"
ARK_COLOR_RED="\033[1;31m"
ARK_OK="✅"
ARK_WARN="⚠️"
ARK_FAIL="❌"

# ARK: Copy a file to clipboard, cross-platform
ark_copy_to_clipboard() {
    local file="$1"
    if [[ -f "$file" ]]; then
        if command -v xclip >/dev/null 2>&1; then
            xclip -sel clip < "$file"
            echo -e "${ARK_COLOR_GREEN}${ARK_OK} File copied to clipboard (X11/xclip).${ARK_COLOR_RESET}"
        elif command -v pbcopy >/dev/null 2>&1; then
            pbcopy < "$file"
            echo -e "${ARK_COLOR_GREEN}${ARK_OK} File copied to clipboard (macOS/pbcopy).${ARK_COLOR_RESET}"
        else
            echo -e "${ARK_COLOR_RED}${ARK_WARN} No clipboard utility found. Install xclip or pbcopy.${ARK_COLOR_RESET}"
        fi
    else
        echo -e "${ARK_COLOR_RED}${ARK_FAIL} File not found: $file${ARK_COLOR_RESET}"
    fi
}

# ARK: Print an ARK-styled error and suggest a fix
ark_error() {
    local type="$1"
    local location="$2"
    local solution="$3"
    echo -e "${ARK_COLOR_RED}⚠️ [$type]\nLocation: $location\nFix: $solution\n\"I'll guide you, Commander.\"${ARK_COLOR_RESET}"
}

# ARK: Print a themed banner (utility)
ark_banner() {
    local text="$1"
    local version="$2"
    echo -e "${ARK_COLOR_CYAN}╔════════════════════════════════════════════════════════╗${ARK_COLOR_RESET}"
    printf "${ARK_COLOR_CYAN}║${ARK_COLOR_PURPLE}   🛸  %s      %-8s${ARK_COLOR_CYAN}║${ARK_COLOR_RESET}\n" "$text" "$version"
    echo -e "${ARK_COLOR_CYAN}╚════════════════════════════════════════════════════════╝${ARK_COLOR_RESET}"
}

# End of ARK SSH Utilities
