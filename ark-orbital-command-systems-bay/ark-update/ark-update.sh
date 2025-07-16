#!/usr/bin/env bash
# 🛰️ ADMIRAL A.R.K. – ARK UPDATE MODULE (Pause-On-Error, Enhanced Edition)

#==================#
#  ARK THEME VARS  #
#==================#
ARK_COLOR_CYAN="\033[1;36m"
ARK_COLOR_WHITE="\033[1;37m"
ARK_COLOR_YELLOW="\033[1;33m"
ARK_COLOR_GREEN="\033[1;32m"
ARK_COLOR_RED="\033[1;31m"
ARK_COLOR_MAGENTA="\033[1;35m"
ARK_COLOR_BG_DARK="\033[48;5;236m"
ARK_COLOR_RESET="\033[0m"
ARK_ICON_UPDATE="🔄"
ARK_ICON_PACKAGE="📦"
ARK_ICON_SHIELD="🛡"
ARK_ICON_MENU="📋"
ARK_ICON_GIT="🌐"
ARK_ICON_PYPI="🐍"
ARK_ICON_FLATPAK="📦"
ARK_ICON_SNAP="🧲"
ARK_ICON_NODE="🟩"
ARK_ICON_ANDROID="🤖"
ARK_ICON_OK="✅"
ARK_ICON_WARN="⚠️"
ARK_ICON_INFO="ℹ️"
ARK_ICON_ERROR="❌"

#=================#
#   ARK BANNER    #
#=================#
ark_banner() {
    echo -e "${ARK_COLOR_MAGENTA}${ARK_COLOR_BG_DARK}"
    echo -e "╔══════════════════════════════════════════════════════════════════════════════╗"
    echo -e "║        ${ARK_ICON_UPDATE}${ARK_COLOR_WHITE}  ARK SYSTEM UPDATE PANEL  ${ARK_ICON_UPDATE}        ${ARK_COLOR_MAGENTA}"
    echo -e "╚══════════════════════════════════════════════════════════════════════════════╝"
    echo -e "${ARK_COLOR_RESET}"
}

#=================#
#  ERROR HANDLER  #
#=================#
ark_error() {
    echo -e "\n${ARK_COLOR_RED}${ARK_ICON_ERROR} ⚠ [ERROR: $1]"
    echo -e "Location: $2"
    echo -e "Fix: $3"
    echo -e "\"I'll guide you, Commander.\"${ARK_COLOR_RESET}"
    echo -e "${ARK_COLOR_MAGENTA}Press [Enter] to attempt fix or abort, Commander${ARK_COLOR_RESET}"
    read -r
    ARK_FORCE_PAUSE=1
}

#=================#
#   ARK PAUSE     #
#=================#
ark_pause() {
    # Always pause on error or if not in batch mode
    if [[ "$ARK_FORCE_PAUSE" == "1" || "$ARK_BATCH" != "1" ]]; then
        echo -e "\n${ARK_COLOR_MAGENTA}Press [Enter] to return to menu, Commander.${ARK_COLOR_RESET}"
        read -r
        ARK_FORCE_PAUSE=0
    fi
}

#=================#
#   ARK MENU      #
#=================#
ark_update_menu() {
    while true; do
        clear
        ark_banner
        echo -e "${ARK_COLOR_CYAN}Choose an update operation, Commander:${ARK_COLOR_RESET}\n"
        echo -e "${ARK_COLOR_YELLOW} 1) ${ARK_ICON_UPDATE} Full Update (All)"
        echo -e " 2) ${ARK_ICON_PACKAGE} System Packages"
        echo -e " 3) ${ARK_ICON_PACKAGE} AUR Packages"
        echo -e " 4) ${ARK_ICON_PYPI} Python (pip/pipx)"
        echo -e " 5) ${ARK_ICON_FLATPAK} Flatpak"
        echo -e " 6) ${ARK_ICON_SNAP} Snap"
        echo -e " 7) ${ARK_ICON_NODE} Node (npm/yarn/pnpm)"
        echo -e " 8) ${ARK_ICON_GIT} Git Submodules"
        echo -e " 9) ${ARK_ICON_ANDROID} Android SDK/NDK/Repo"
        echo -e "${ARK_COLOR_GREEN}10) ${ARK_ICON_SHIELD} Update Report"
        echo -e "${ARK_COLOR_RED} 0) ${ARK_ICON_MENU} Return to Main Menu${ARK_COLOR_RESET}"
        echo -e "${ARK_COLOR_CYAN}──────────────────────────────────────────────────────────────────────────────${ARK_COLOR_RESET}"
        echo -en "${ARK_COLOR_WHITE}➤ Selection, Commander: ${ARK_COLOR_RESET}"
        read sel
        case "$sel" in
            1) ARK_BATCH=1; ark_update_full; ARK_BATCH=0 ;;
            2) ARK_BATCH=0; ark_update_system ;;
            3) ARK_BATCH=0; ark_update_aur ;;
            4) ARK_BATCH=0; ark_update_pip ;;
            5) ARK_BATCH=0; ark_update_flatpak ;;
            6) ARK_BATCH=0; ark_update_snap ;;
            7) ARK_BATCH=0; ark_update_node ;;
            8) ARK_BATCH=0; ark_update_git ;;
            9) ARK_BATCH=0; ark_update_android ;;
            10) ARK_BATCH=0; ark_update_report ;;
            0) break ;;
            *) echo -e "${ARK_COLOR_RED}Invalid selection, Commander.${ARK_COLOR_RESET}"; sleep 1 ;;
        esac
    done
}

#=================#
#   SYSTEM UPDATE #
#=================#
ark_update_system() {
    clear; ark_banner
    echo -e "${ARK_COLOR_YELLOW}${ARK_ICON_UPDATE} System packages...${ARK_COLOR_RESET}"
    if command -v pacman &>/dev/null; then
        sudo pacman -Syu --noconfirm || { ark_error "System update failed" "System Packages" "Check your internet or pacman configuration."; return 1; }
    elif command -v apt &>/dev/null; then
        sudo apt update && sudo apt upgrade -y || { ark_error "System update failed" "System Packages" "Check your internet or apt configuration."; return 1; }
    elif command -v dnf &>/dev/null; then
        sudo dnf upgrade -y || { ark_error "System update failed" "System Packages" "Check your internet or dnf configuration."; return 1; }
    elif command -v zypper &>/dev/null; then
        sudo zypper update -y || { ark_error "System update failed" "System Packages" "Check your internet or zypper configuration."; return 1; }
    elif command -v yum &>/dev/null; then
        sudo yum update -y || { ark_error "System update failed" "System Packages" "Check your internet or yum configuration."; return 1; }
    else
        ark_error "No supported package manager found" "System Packages" "Install pacman, apt, dnf, zypper, or yum."
        return 1
    fi
    echo -e "${ARK_COLOR_GREEN}${ARK_ICON_OK} System packages updated.${ARK_COLOR_RESET}"
    ark_pause
}

#=================#
#   AUR UPDATE    #
#=================#
ark_update_aur() {
    clear; ark_banner
    echo -e "${ARK_COLOR_YELLOW}${ARK_ICON_UPDATE} AUR packages...${ARK_COLOR_RESET}"
    if command -v yay &>/dev/null; then
        yay -Syu --noconfirm || { ark_error "AUR update failed" "AUR Packages" "Check yay logs or internet connection."; return 1; }
    elif command -v paru &>/dev/null; then
        paru -Syu --noconfirm || { ark_error "AUR update failed" "AUR Packages" "Check paru logs or internet connection."; return 1; }
    else
        ark_error "No AUR helper (yay/paru) detected" "AUR Packages" "Install yay or paru for AUR support."
        return 1
    fi
    echo -e "${ARK_COLOR_GREEN}${ARK_ICON_OK} AUR packages updated.${ARK_COLOR_RESET}"
    ark_pause
}

#=================#
#   PIP/PIPX      #
#=================#
ark_update_pip() {
    clear; ark_banner
    echo -e "${ARK_COLOR_YELLOW}${ARK_ICON_PYPI} Python (pip/pipx) packages...${ARK_COLOR_RESET}"
    local pip_error=0
    if command -v pipx &>/dev/null; then
        echo -e "${ARK_COLOR_CYAN}${ARK_ICON_INFO} Upgrading all pipx applications...${ARK_COLOR_RESET}"
        pipx upgrade-all || { ark_error "pipx upgrade failed" "Python (pipx)" "Check pipx installation or logs."; pip_error=1; }
    else
        echo -e "${ARK_COLOR_YELLOW}${ARK_ICON_WARN} pipx not installed. Recommended for safe Python app management."
        echo -e "${ARK_COLOR_CYAN}    Install with: sudo pacman -S python-pipx${ARK_COLOR_RESET}"
    fi
    if command -v pip3 &>/dev/null; then
        echo -e "${ARK_COLOR_CYAN}${ARK_ICON_INFO} Outdated user pip packages:${ARK_COLOR_RESET}"
        pip3 list --user --outdated --format=columns 2>/dev/null || echo -e "${ARK_COLOR_GREEN}- No outdated user packages.${ARK_COLOR_RESET}"
        echo -e "${ARK_COLOR_YELLOW}To upgrade: pip3 install --user -U <package>${ARK_COLOR_RESET}"
    fi
    echo -e "${ARK_COLOR_YELLOW}For system Python packages, use your package manager! (e.g., pacman -S python-foo).${ARK_COLOR_RESET}"
    if [[ $pip_error -eq 1 ]]; then ARK_FORCE_PAUSE=1; fi
    echo -e "${ARK_COLOR_GREEN}${ARK_ICON_OK} pip/pipx check complete.${ARK_COLOR_RESET}"
    ark_pause
}

#=================#
#   FLATPAK       #
#=================#
ark_update_flatpak() {
    clear; ark_banner
    echo -e "${ARK_COLOR_YELLOW}${ARK_ICON_FLATPAK} Flatpak apps...${ARK_COLOR_RESET}"
    if command -v flatpak &>/dev/null; then
        flatpak update -y || { ark_error "Flatpak update failed" "Flatpak" "Check flatpak installation or logs."; return 1; }
    else
        ark_error "Flatpak not installed" "Flatpak" "Install flatpak for app sandboxing support."
        return 1
    fi
    echo -e "${ARK_COLOR_GREEN}${ARK_ICON_OK} Flatpak updated.${ARK_COLOR_RESET}"
    ark_pause
}

#=================#
#   SNAP          #
#=================#
ark_update_snap() {
    clear; ark_banner
    echo -e "${ARK_COLOR_YELLOW}${ARK_ICON_SNAP} Snap packages...${ARK_COLOR_RESET}"
    if command -v snap &>/dev/null; then
        sudo snap refresh || { ark_error "Snap update failed" "Snap" "Check snap installation or logs."; return 1; }
    else
        ark_error "Snap not installed" "Snap" "Install snapd for Snap package support."; return 1
    fi
    echo -e "${ARK_COLOR_GREEN}${ARK_ICON_OK} Snap updated.${ARK_COLOR_RESET}"
    ark_pause
}

#=================#
#   NODE.JS       #
#=================#
ark_update_node() {
    clear; ark_banner
    echo -e "${ARK_COLOR_YELLOW}${ARK_ICON_NODE} Node.js global packages...${ARK_COLOR_RESET}"
    local node_updated=0
    if command -v npm &>/dev/null; then
        npm update -g || { ark_error "npm global update failed" "Node.js" "Check npm installation or logs."; return 1; }
        node_updated=1
    fi
    if command -v yarn &>/dev/null; then
        yarn global upgrade || { ark_error "yarn global upgrade failed" "Node.js" "Check yarn installation or logs."; return 1; }
        node_updated=1
    fi
    if command -v pnpm &>/dev/null; then
        pnpm update -g || { ark_error "pnpm global update failed" "Node.js" "Check pnpm installation or logs."; return 1; }
        node_updated=1
    fi
    if [[ "$node_updated" -eq 0 ]]; then
        ark_error "No global Node.js package manager detected" "Node.js" "Install npm, yarn, or pnpm for Node.js support."
        return 1
    fi
    echo -e "${ARK_COLOR_GREEN}${ARK_ICON_OK} Node.js packages updated.${ARK_COLOR_RESET}"
    ark_pause
}

#=================#
#   GIT SUBMODULES#
#=================#
ark_update_git() {
    clear; ark_banner
    echo -e "${ARK_COLOR_YELLOW}${ARK_ICON_GIT} Git submodules...${ARK_COLOR_RESET}"
    if [ -f .gitmodules ]; then
        git submodule sync || { ark_error "Submodule sync failed" "Git Submodules" "Check .gitmodules or git status."; return 1; }
        git submodule update --init --recursive --remote || { ark_error "Submodule update failed" "Git Submodules" "Check submodule URLs or access permissions."; return 1; }
        echo -e "${ARK_COLOR_GREEN}- Submodules updated.${ARK_COLOR_RESET}"
    else
        echo -e "${ARK_COLOR_YELLOW}${ARK_ICON_WARN} No git submodules detected.${ARK_COLOR_RESET}"
    fi
    echo -e "${ARK_COLOR_GREEN}${ARK_ICON_OK} Git submodules check complete.${ARK_COLOR_RESET}"
    ark_pause
}

#=================#
#   ANDROID STUFF #
#=================#
ark_update_android() {
    clear; ark_banner
    echo -e "${ARK_COLOR_YELLOW}${ARK_ICON_ANDROID} Android SDK/NDK & repo...${ARK_COLOR_RESET}"
    local sdkmanager=""
    if [[ -n "$ANDROID_SDK_ROOT" && -x "$ANDROID_SDK_ROOT/cmdline-tools/latest/bin/sdkmanager" ]]; then
        sdkmanager="$ANDROID_SDK_ROOT/cmdline-tools/latest/bin/sdkmanager"
    elif [[ -n "$ANDROID_SDK_ROOT" && -x "$ANDROID_SDK_ROOT/tools/bin/sdkmanager" ]]; then
        sdkmanager="$ANDROID_SDK_ROOT/tools/bin/sdkmanager"
    elif command -v sdkmanager &>/dev/null; then
        sdkmanager="$(command -v sdkmanager)"
    fi

    if [[ -n "$sdkmanager" ]]; then
        yes | "$sdkmanager" --update || { ark_error "Android SDK update failed" "Android SDK/NDK" "Check sdkmanager logs, ANDROID_SDK_ROOT, and network."; return 1; }
        yes | "$sdkmanager" --licenses
        echo -e "${ARK_COLOR_GREEN}- Android SDK/NDK/tools updated.${ARK_COLOR_RESET}"
    else
        ark_error "Android sdkmanager not found" "Android SDK/NDK" "Set ANDROID_SDK_ROOT or ANDROID_HOME and ensure sdkmanager is installed.\nDownload: https://developer.android.com/studio#command-tools"
        return 1
    fi

    if command -v repo &>/dev/null; then
        if [[ -d .repo ]]; then
            repo sync || { ark_error "Android repo sync failed" "Android repo" "Check repo logs and manifest configuration."; return 1; }
            echo -e "${ARK_COLOR_GREEN}- Android repo manifests synced.${ARK_COLOR_RESET}"
        else
            ark_error "No .repo directory detected" "Android repo" "Run 'repo init' first if needed."
            return 1
        fi
    else
        ark_error "'repo' not installed or not in PATH" "Android repo" "Get it: https://android.googlesource.com/tools/repo"
        return 1
    fi
    echo -e "${ARK_COLOR_GREEN}${ARK_ICON_OK} Android check complete.${ARK_COLOR_RESET}"
    ark_pause
}

#=================#
#   UPDATE REPORT #
#=================#
ark_update_report() {
    clear; ark_banner
    echo -e "${ARK_COLOR_CYAN}ARK UPDATE REPORT${ARK_COLOR_RESET}"
    # System packages
    if command -v pacman &>/dev/null; then
        echo -e "${ARK_COLOR_WHITE}${ARK_ICON_PACKAGE} System:"
        pacman -Qu || echo -e "${ARK_COLOR_GREEN}- System up-to-date.${ARK_COLOR_RESET}"
        if command -v yay &>/dev/null; then
            echo -e "${ARK_COLOR_WHITE}${ARK_ICON_PACKAGE} AUR:"
            yay -Qu || echo -e "${ARK_COLOR_GREEN}- AUR up-to-date.${ARK_COLOR_RESET}"
        fi
    elif command -v apt &>/dev/null; then
        echo -e "${ARK_COLOR_WHITE}${ARK_ICON_PACKAGE} System:"
        apt list --upgradable 2>/dev/null | grep -Ev 'Listing...' || echo -e "${ARK_COLOR_GREEN}- System up-to-date.${ARK_COLOR_RESET}"
    fi

    # Python
    if command -v pipx &>/dev/null; then
        echo -e "${ARK_COLOR_WHITE}${ARK_ICON_PYPI} pipx apps:"
        pipx list | grep package || echo -e "${ARK_COLOR_GREEN}- No pipx apps detected.${ARK_COLOR_RESET}"
    fi
    if command -v pip3 &>/dev/null; then
        echo -e "${ARK_COLOR_WHITE}${ARK_ICON_PYPI} pip (user):"
        pip3 list --user --outdated --format=columns || echo -e "${ARK_COLOR_GREEN}- pip up-to-date.${ARK_COLOR_RESET}"
    fi

    # Flatpak
    if command -v flatpak &>/dev/null; then
        echo -e "${ARK_COLOR_WHITE}${ARK_ICON_FLATPAK} Flatpak:"
        flatpak remote-ls --updates flathub || echo -e "${ARK_COLOR_GREEN}- Flatpak up-to-date.${ARK_COLOR_RESET}"
    fi

    # Snap
    if command -v snap &>/dev/null; then
        echo -e "${ARK_COLOR_WHITE}${ARK_ICON_SNAP} Snap:"
        snap refresh --list || echo -e "${ARK_COLOR_GREEN}- Snap up-to-date.${ARK_COLOR_RESET}"
    fi

    # Node.js
    local node_shown=0
    if command -v npm &>/dev/null; then
        echo -e "${ARK_COLOR_WHITE}${ARK_ICON_NODE} npm (global):"
        npm outdated -g || echo -e "${ARK_COLOR_GREEN}- npm globals up-to-date.${ARK_COLOR_RESET}"
        node_shown=1
    fi
    if command -v yarn &>/dev/null; then
        echo -e "${ARK_COLOR_WHITE}${ARK_ICON_NODE} yarn (global):"
        yarn global outdated || echo -e "${ARK_COLOR_GREEN}- yarn globals up-to-date.${ARK_COLOR_RESET}"
        node_shown=1
    fi
    if command -v pnpm &>/dev/null; then
        echo -e "${ARK_COLOR_WHITE}${ARK_ICON_NODE} pnpm (global):"
        pnpm outdated -g || echo -e "${ARK_COLOR_GREEN}- pnpm globals up-to-date.${ARK_COLOR_RESET}"
        node_shown=1
    fi
    if [[ "$node_shown" -eq 0 ]]; then
        echo -e "${ARK_COLOR_YELLOW}- No Node.js package manager detected.${ARK_COLOR_RESET}"
    fi

    # Git submodules
    echo -e "${ARK_COLOR_WHITE}${ARK_ICON_GIT} Git Submodules:${ARK_COLOR_RESET}"
    if [ -f .gitmodules ]; then
        git submodule status
    else
        echo -e "${ARK_COLOR_GREEN}- No git submodules detected.${ARK_COLOR_RESET}"
    fi

    # Android SDK/NDK/Repo
    echo -e "${ARK_COLOR_WHITE}${ARK_ICON_ANDROID} Android SDK/NDK/Repo:${ARK_COLOR_RESET}"
    local sdkmanager=""
    if [[ -n "$ANDROID_SDK_ROOT" && -x "$ANDROID_SDK_ROOT/cmdline-tools/latest/bin/sdkmanager" ]]; then
        sdkmanager="$ANDROID_SDK_ROOT/cmdline-tools/latest/bin/sdkmanager"
    elif [[ -n "$ANDROID_SDK_ROOT" && -x "$ANDROID_SDK_ROOT/tools/bin/sdkmanager" ]]; then
        sdkmanager="$ANDROID_SDK_ROOT/tools/bin/sdkmanager"
    elif command -v sdkmanager &>/dev/null; then
        sdkmanager="$(command -v sdkmanager)"
    fi
    if [[ -n "$sdkmanager" ]]; then
        "$sdkmanager" --list | grep -E '^Available|^Installed|^Update' || echo -e "${ARK_COLOR_GREEN}- SDK status listed.${ARK_COLOR_RESET}"
    else
        echo -e "${ARK_COLOR_YELLOW}- Android sdkmanager not found or not configured.${ARK_COLOR_RESET}"
    fi
    if command -v repo &>/dev/null && [[ -d .repo ]]; then
        echo -e "${ARK_COLOR_WHITE}${ARK_ICON_ANDROID} Android repo:"
        repo status
    fi

    # System Health
    echo -e "${ARK_COLOR_WHITE}🗄 Disk Space:${ARK_COLOR_RESET}"
    df -h | grep -E '^/|Filesystem'
    echo -e "${ARK_COLOR_WHITE}🧠 Memory:${ARK_COLOR_RESET}"
    free -h
    echo -e "${ARK_COLOR_WHITE}⏱ Uptime:${ARK_COLOR_RESET}"
    uptime -p
    echo -e "${ARK_COLOR_WHITE}🧬 Kernel:${ARK_COLOR_RESET}"
    uname -r

    ark_pause
}

#=================#
#  FULL UPDATE    #
#=================#
ark_update_full() {
    clear; ark_banner
    echo -e "${ARK_COLOR_CYAN}${ARK_ICON_UPDATE} FULL SYSTEM UPDATE...${ARK_COLOR_RESET}"
    ARK_BATCH=1
    ark_update_system || return 1
    ark_update_aur || return 1
    ark_update_pip || return 1
    ark_update_flatpak || return 1
    ark_update_snap || return 1
    ark_update_node || return 1
    ark_update_git || return 1
    ark_update_android || return 1
    ARK_BATCH=0
    echo -e "${ARK_COLOR_GREEN}${ARK_ICON_OK} All updates complete.${ARK_COLOR_RESET}"
    ark_update_report
}

# Commander: To launch, call ark_update_menu from your main menu.
