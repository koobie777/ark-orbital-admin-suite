#!/usr/bin/env bash
# 🛰️ ARK Essentials Installer Module for The ARK Ecosystem
# v2.1.0 Fleet Renaissance – Modular, ARK-themed, updated for new directory protocol

# =========================
# 🌌 ARK THEME CONSTANTS 🌌
# =========================
ARK_COLOR_CYAN="\033[1;36m"
ARK_COLOR_PURPLE="\033[1;35m"
ARK_COLOR_RESET="\033[0m"
ARK_COLOR_YELLOW="\033[1;33m"
ARK_COLOR_GREEN="\033[1;32m"
ARK_COLOR_RED="\033[1;31m"
ARK_COLOR_BLUE="\033[1;34m"
ARK_COLOR_MAGENTA="\033[1;35m"
ARK_SHIP="🛸"
ARK_OK="✅"
ARK_WARN="⚠️"
ARK_FAIL="❌"
ARK_UPDATE="🔄"
ARK_ESSENTIALS_VERSION="2.1.0"  # Fleet Renaissance

# ======================
# ARK THEMED FUNCTIONS
# ======================
ark_separator() {
    echo -e "${ARK_COLOR_CYAN}╔═══════════════════════════════════════════════════════════════╗${ARK_COLOR_RESET}"
}
ark_banner() {
    ark_separator
    printf "${ARK_COLOR_CYAN}║${ARK_COLOR_PURPLE}   🛰️  ARK ESSENTIALS INSTALLER MODULE          %-12s${ARK_COLOR_CYAN}║${ARK_COLOR_RESET}\n" "v$ARK_ESSENTIALS_VERSION"
    printf "${ARK_COLOR_CYAN}║${ARK_COLOR_MAGENTA}   Modular, Fleet-Ready, ARK-Ecosystem Directory Protocol        ${ARK_COLOR_CYAN}║${ARK_COLOR_RESET}\n"
    ark_separator
}
ark_status() {
    local status_icon="$1"
    local msg="$2"
    local color="$3"
    printf "${color}%s ${msg}${ARK_COLOR_RESET}\n" "$status_icon"
}
ark_error() {
    local msg="$1"
    local location="$2"
    local fix="$3"
    echo -e "\n${ARK_COLOR_RED}${ARK_FAIL} ⚠️ [ERROR: $msg]"
    echo -e "Location: $location"
    echo -e "Fix: $fix"
    echo -e "\"I'll guide you, Commander.\"${ARK_COLOR_RESET}"
    echo -e "${ARK_COLOR_MAGENTA}Press [Enter] to attempt fix or abort, Commander.${ARK_COLOR_RESET}"
    read -r
}
ark_require_root() {
    if ! command -v sudo &>/dev/null; then
        ark_error "sudo not found" "ark_require_root" "Please install sudo and re-run as a user with sudo."
        return 1
    fi
}
ark_check_pacman() {
    if ! command -v pacman &>/dev/null; then
        ark_error "pacman not found" "ark_check_pacman" "This installer is for Arch-based systems only."
        return 1
    fi
}
ark_switch_display_manager() {
    local desired_dm="$1"
    local desired_unit="/usr/lib/systemd/system/${desired_dm}.service"
    local current_link="/etc/systemd/system/display-manager.service"
    if [ -L "$current_link" ] && [ "$(readlink "$current_link")" != "$desired_unit" ]; then
        ark_status "$ARK_WARN" "Display manager conflict detected! Switching to $desired_dm..." "$ARK_COLOR_YELLOW"
        sudo ln -sf "$desired_unit" "$current_link" || { ark_error "Failed to switch display manager" "ark_switch_display_manager" "Check permissions and systemd state"; return 1; }
        sudo systemctl daemon-reload
        ark_status "$ARK_OK" "$desired_dm is now active." "$ARK_COLOR_GREEN"
    elif [ ! -e "$current_link" ]; then
        sudo ln -s "$desired_unit" "$current_link" || { ark_error "Failed to set display manager" "ark_switch_display_manager" "Check permissions and systemd state"; return 1; }
        sudo systemctl daemon-reload
        ark_status "$ARK_OK" "$desired_dm set as display manager." "$ARK_COLOR_GREEN"
    else
        ark_status "$ARK_OK" "$desired_dm already active or no change needed." "$ARK_COLOR_GREEN"
    fi
}

ark_modular_install() {
    local group_name="$1"
    shift
    local packages=("$@")
    echo -e "${ARK_COLOR_BLUE}📦 Installing $group_name...${ARK_COLOR_RESET}"
    for pkg in "${packages[@]}"; do
        if ! pacman -Q "$pkg" &>/dev/null; then
            ark_status "$ARK_SHIP" "Installing $pkg..." "$ARK_COLOR_BLUE"
            sudo pacman -S --noconfirm "$pkg" || { ark_error "Failed to install $pkg" "ark_modular_install: $group_name" "Check pacman logs and internet."; }
        else
            ark_status "$ARK_OK" "$pkg already installed" "$ARK_COLOR_GREEN"
        fi
    done
}

ark_install_java() {
    local java_package="jdk-openjdk"
    ark_status "$ARK_SHIP" "Ensuring OpenJDK (Java) for Android builds..." "$ARK_COLOR_BLUE"
    if ! pacman -Q "$java_package" &>/dev/null; then
        if pacman -Q jre-openjdk-headless &>/dev/null; then
            ark_status "$ARK_WARN" "Conflict: jdk-openjdk and jre-openjdk-headless cannot coexist.\nRemoving jre-openjdk-headless..." "$ARK_COLOR_YELLOW"
            sudo pacman -Rs --noconfirm jre-openjdk-headless || { ark_error "Failed to remove jre-openjdk-headless" "ark_install_java" "Remove manually using pacman."; return 1; }
        fi
        sudo pacman -S --noconfirm "$java_package" || { ark_error "Failed to install $java_package" "ark_install_java" "Check internet and pacman logs."; return 1; }
        ark_status "$ARK_OK" "$java_package installed" "$ARK_COLOR_GREEN"
    else
        ark_status "$ARK_OK" "$java_package already installed" "$ARK_COLOR_GREEN"
    fi
}

ark_prompt_gui() {
    echo ""
    echo -e "${ARK_COLOR_PURPLE}🎨 Commander, would you like to install a GUI environment on this ARK node?${ARK_COLOR_RESET}"
    echo -e "${ARK_COLOR_BLUE}Options:${ARK_COLOR_RESET}"
    echo "  1) None (default, headless/CLI only)"
    echo "  2) XFCE (ultra-lightweight, ARK recommended)"
    echo "  3) LXQt"
    echo "  4) i3 (Tiling WM, power user)"
    echo "  5) GNOME"
    echo "  6) KDE Plasma"
    echo "  7) Custom (enter your own package list)"
    read -p "Select GUI option [1-7]: " ark_gui_choice

    case "$ark_gui_choice" in
        2)
            ark_modular_install "XFCE Desktop" xorg-server xorg-xinit xfce4 xfce4-goodies lightdm lightdm-gtk-greeter
            ark_switch_display_manager "lightdm"
            ;;
        3)
            ark_modular_install "LXQt Desktop" xorg-server xorg-xinit lxqt sddm
            ark_switch_display_manager "sddm"
            ;;
        4)
            ark_modular_install "i3 WM" xorg-server xorg-xinit i3 dmenu
            ;;
        5)
            ark_modular_install "GNOME" xorg-server xorg-xinit gnome gdm
            ark_switch_display_manager "gdm"
            ;;
        6)
            ark_modular_install "KDE Plasma" xorg-server xorg-xinit plasma kde-applications sddm
            ark_switch_display_manager "sddm"
            ;;
        7)
            read -p "Enter space-separated package names for your custom GUI: " custom_gui_pkgs
            ark_modular_install "Custom GUI" $custom_gui_pkgs
            ;;
        *)
            ark_status "$ARK_SHIP" "ARK node will remain headless (CLI only)." "$ARK_COLOR_BLUE"
            ;;
    esac
}

ark_install_aur_helper() {
    if ! command -v yay &>/dev/null; then
        ark_status "$ARK_SHIP" "Installing yay AUR helper..." "$ARK_COLOR_BLUE"
        cd /tmp || { ark_error "Failed to cd /tmp" "yay install" "Check /tmp permissions"; return 1; }
        git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm && cd - && rm -rf /tmp/yay \
            || { ark_error "Failed to install yay" "yay install" "Check git, makepkg, and internet."; }
        ark_status "$ARK_OK" "yay installed successfully" "$ARK_COLOR_GREEN"
    else
        ark_status "$ARK_OK" "yay already available" "$ARK_COLOR_GREEN"
    fi
}

ark_optional_tools_menu() {
    echo ""
    echo -e "${ARK_COLOR_MAGENTA}🧩 Optional ARK Tools & Enhancements:${ARK_COLOR_RESET}"
    echo "  1) Install font/nerd-fonts for better CLI aesthetics"
    echo "  2) Install Android platform tools from AUR"
    echo "  3) Install Docker & Docker Compose"
    echo "  4) Install VS Code (community edition)"
    echo "  5) Skip optional tools"
    read -p "Choose extra tools to install [comma-separated, e.g. 1,3] (or 5 to skip): " extras
    IFS=',' read -ra extra_arr <<< "$extras"
    for choice in "${extra_arr[@]}"; do
        case "$choice" in
            1)
                ark_status "$ARK_SHIP" "Installing nerd-fonts..." "$ARK_COLOR_BLUE"
                yay -S --noconfirm nerd-fonts || ark_status "$ARK_WARN" "Could not install nerd-fonts." "$ARK_COLOR_YELLOW"
                ;;
            2)
                ark_status "$ARK_SHIP" "Installing android-platform-tools from AUR..." "$ARK_COLOR_BLUE"
                yay -S --noconfirm android-platform-tools || ark_status "$ARK_WARN" "Could not install android-platform-tools." "$ARK_COLOR_YELLOW"
                ;;
            3)
                ark_status "$ARK_SHIP" "Installing Docker & Compose..." "$ARK_COLOR_BLUE"
                sudo pacman -S --noconfirm docker docker-compose
                sudo systemctl enable --now docker
                ;;
            4)
                ark_status "$ARK_SHIP" "Installing VS Code (community edition)..." "$ARK_COLOR_BLUE"
                yay -S --noconfirm visual-studio-code-bin || ark_status "$ARK_WARN" "Could not install VS Code." "$ARK_COLOR_YELLOW"
                ;;
        esac
    done
}

ark_install_essentials() {
    ark_banner
    echo -e "${ARK_COLOR_PURPLE}🛠️  Installing ARK Essential Tools for The ARK Ecosystem (Essentials v$ARK_ESSENTIALS_VERSION)...${ARK_COLOR_RESET}"
    ark_require_root || return 1
    ark_check_pacman || return 1

    # Modular base essentials
    local base_packages=(
        base-devel git git-lfs repo curl wget vim nano htop btop tree unzip zip p7zip rsync
        screen tmux jq bc bat fd ripgrep fzf lsd aria2 shellcheck eza duf ncdu xclip xsel
        neovim micro starship zoxide bottom dust lazygit
    )
    ark_modular_install "Base Development Tools" "${base_packages[@]}"

    # Android essentials
    local android_packages=(android-tools python python-pip ccache schedtool squashfs-tools)
    ark_modular_install "Android Development Tools" "${android_packages[@]}"

    ark_install_java
    ark_install_aur_helper

    # GUI prompt
    ark_prompt_gui

    # Optional extras prompt
    ark_optional_tools_menu

    ark_separator
    echo -e "${ARK_COLOR_PURPLE}🌌 ARK Essentials installation complete. Your ARK fleet is fully operational, Commander!${ARK_COLOR_RESET}"
    ark_separator
}

ark_essentials_install() {
    ark_install_essentials
}

# ====== ARK MODULE ENTRY POINT ======
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    ark_essentials_install
fi
