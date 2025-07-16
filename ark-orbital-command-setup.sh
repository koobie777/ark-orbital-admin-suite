#!/usr/bin/env bash
# 🛰️ ARK-Orbital-Command Setup/Launcher Installer – The ARK Ecosystem v2.4 (Mission-LT Protocol)
# Updated: 2025-07-16 – Fully ARK/Ecosystem Modular

# ========== ARK THEME CONSTANTS ==========
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
ARK_INSTALL="🛠️"
ARK_UNINSTALL="❌"

# ========== USER & PATH DETECTION ==========
CURRENT_USER="$(id -un)"
USER_HOME="$(eval echo ~$CURRENT_USER)"
DESKTOP_DIR="$USER_HOME/Desktop"
MENU_DIR="$USER_HOME/.local/share/applications/The-ARK"
DESKTOP_FILE="$DESKTOP_DIR/ARK-Orbital-Command.desktop"
MENU_DESKTOP="$MENU_DIR/ARK-Orbital-Command.desktop"
README_DESKTOP="$MENU_DIR/ARK-Orbital-Command-README.desktop"
ARK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MAIN_SCRIPT="$ARK_ROOT/ark-orbital-command.sh"
ICON_PATH="$ARK_ROOT/assets/icons/ark-orbital-command-icon.png"
README_PATH="$ARK_ROOT/README.md"

# ========== ARK UI HELPERS ==========
ark_separator() { echo -e "${ARK_COLOR_CYAN}╔═══════════════════════════════════════════════════════════════════════════╗${ARK_COLOR_RESET}"; }
ark_status() { local icon="$1"; local msg="$2"; local color="$3"; printf "  ${color}%s %s${ARK_COLOR_RESET}\n" "$icon" "$msg"; }
ark_banner() {
    ark_separator
    printf "${ARK_COLOR_CYAN}║${ARK_COLOR_PURPLE}   🛰️  ARK-Orbital-Command Setup UI${ARK_COLOR_CYAN}                             ║${ARK_COLOR_RESET}\n"
    printf "${ARK_COLOR_CYAN}║${ARK_COLOR_MAGENTA}   Install, update, or remove ARK launchers & menu entries          ${ARK_COLOR_CYAN}║${ARK_COLOR_RESET}\n"
    ark_separator
}
ark_themed_title() {
    echo -e "${ARK_COLOR_PURPLE}${ARK_SHIP} ${ARK_COLOR_CYAN}ARK-Orbital-Command Setup • ${ARK_COLOR_MAGENTA}The ARK Ecosystem${ARK_COLOR_RESET}"
}

ark_create_desktop_dir() {
    if [ ! -d "$DESKTOP_DIR" ]; then
        mkdir -p "$DESKTOP_DIR" && ark_status "$ARK_OK" "Created Desktop directory: $DESKTOP_DIR" "$ARK_COLOR_GREEN"
    fi
}

ark_make_executable() {
    if [ -f "$MAIN_SCRIPT" ]; then
        chmod +x "$MAIN_SCRIPT"
        ark_status "$ARK_OK" "ARK main script made executable at $MAIN_SCRIPT" "$ARK_COLOR_GREEN"
    fi
}

ark_check_requirements() {
    if [ ! -f "$MAIN_SCRIPT" ]; then
        ark_status "$ARK_FAIL" "Main ARK script not found: $MAIN_SCRIPT" "$ARK_COLOR_RED"
        echo -e "${ARK_COLOR_YELLOW}Please ensure you run this script from ARK root directory.${ARK_COLOR_RESET}"
        exit 1
    fi
    if [ ! -f "$ICON_PATH" ]; then
        ark_status "$ARK_WARN" "Icon not found: $ICON_PATH" "$ARK_COLOR_YELLOW"
        echo -e "${ARK_COLOR_YELLOW}Continuing, but menu entry will lack ARK icon.${ARK_COLOR_RESET}"
    fi
}

ark_notify_menu_reload() {
    # KDE/Plasma
    if command -v kbuildsycoca5 &>/dev/null; then
        kbuildsycoca5 --noincremental && ark_status "$ARK_OK" "KDE menu cache rebuilt." "$ARK_COLOR_GREEN"
    fi
    # XFCE
    if command -v xfdesktop &>/dev/null; then
        xfdesktop --reload && ark_status "$ARK_OK" "XFCE desktop menu reloaded." "$ARK_COLOR_GREEN"
    fi
    # Cinnamon or GNOME
    if command -v cinnamon-menu-editor &>/dev/null; then
        cinnamon-menu-editor --reload && ark_status "$ARK_OK" "Cinnamon menu reloaded." "$ARK_COLOR_GREEN"
    fi
    if pgrep -x "gnome-shell" > /dev/null && command -v gnome-shell &>/dev/null; then
        echo -e "${ARK_COLOR_YELLOW}If using GNOME, you may need to log out/in or restart the shell to see changes.${ARK_COLOR_RESET}"
    fi
}

ark_open_readme() {
    if command -v xdg-open &>/dev/null; then
        xdg-open "$README_PATH" &
    else
        ark_status "$ARK_WARN" "xdg-open not found, cannot auto-open README." "$ARK_COLOR_YELLOW"
    fi
}

# ========== INSTALLER (also used for update) ==========
ark_install_launcher() {
    ark_check_requirements
    mkdir -p "$MENU_DIR"
    ark_create_desktop_dir

    # Desktop shortcut
    if [ -d "$DESKTOP_DIR" ]; then
        cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=ARK Orbital Command
Comment=Launch The ARK Ecosystem Orbital Command Admin Suite
Exec=$MAIN_SCRIPT
Icon=$ICON_PATH
Terminal=true
Categories=Development;Utility;The-ARK;
StartupWMClass=Ark-Orbital-Command
EOF
        chmod +x "$DESKTOP_FILE"
        ark_status "$ARK_OK" "Desktop launcher created at $DESKTOP_FILE" "$ARK_COLOR_GREEN"
    else
        ark_status "$ARK_WARN" "Desktop directory $DESKTOP_DIR does not exist, skipping desktop shortcut." "$ARK_COLOR_YELLOW"
    fi

    # Main menu entry
    cat > "$MENU_DESKTOP" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=ARK Orbital Command
Comment=Launch The ARK Ecosystem Orbital Command Admin Suite
Exec=$MAIN_SCRIPT
Icon=$ICON_PATH
Terminal=true
Categories=Development;Utility;The-ARK;
StartupWMClass=Ark-Orbital-Command
EOF
    chmod +x "$MENU_DESKTOP"
    ark_status "$ARK_OK" "Start menu entry created at $MENU_DESKTOP" "$ARK_COLOR_GREEN"

    # README menu entry (opens README in default viewer)
    cat > "$README_DESKTOP" <<EOF
[Desktop Entry]
Version=1.0
Type=Link
Name=ARK-Orbital-Command README
Comment=Open ARK-Orbital-Command README
Icon=help-browser
URL=file://$README_PATH
Categories=Documentation;The-ARK;
EOF
    chmod +x "$README_DESKTOP"
    ark_status "$ARK_OK" "ARK README menu link created at $README_DESKTOP" "$ARK_COLOR_GREEN"

    ark_make_executable
    ark_notify_menu_reload

    echo -e "${ARK_COLOR_YELLOW}All icons and menu entries installed under 'The ARK' menu/category.${ARK_COLOR_RESET}"
    echo -e "${ARK_COLOR_CYAN}To launch The ARK, use your application menu or the desktop shortcut.${ARK_COLOR_RESET}"
}

# ========== UPDATER ==========
ark_update_launcher() {
    ark_status "$ARK_UPDATE" "Updating ARK-Orbital-Command setup and menu entries..." "$ARK_COLOR_BLUE"
    ark_install_launcher
    ark_status "$ARK_OK" "ARK-Orbital-Command setup/menu entries updated for The ARK Ecosystem." "$ARK_COLOR_GREEN"
}

# ========== UNINSTALLER ==========
ark_uninstall_launcher() {
    local removed=0
    local desktop_patterns=("ARK-Orbital-Command.desktop" "ARK-Orbital-Command-README.desktop")
    local search_dirs=("$DESKTOP_DIR" "$USER_HOME/.local/share/applications" "/usr/share/applications" "$MENU_DIR")
    for pat in "${desktop_patterns[@]}"; do
        for dir in "${search_dirs[@]}"; do
            local f="$dir/$pat"
            if [ -e "$f" ]; then
                rm -f "$f" && ark_status "$ARK_OK" "Removed $f" "$ARK_COLOR_GREEN"
                removed=1
            fi
        done
    done
    # Remove the ARK menu directory if empty
    if [ -d "$MENU_DIR" ] && [ -z "$(ls -A "$MENU_DIR")" ]; then
        rmdir "$MENU_DIR"
        ark_status "$ARK_OK" "Removed empty menu directory $MENU_DIR" "$ARK_COLOR_GREEN"
    fi
    # Remove desktop icon if present
    if [ -f "$DESKTOP_FILE" ]; then
        rm -f "$DESKTOP_FILE"
        ark_status "$ARK_OK" "Removed desktop icon $DESKTOP_FILE" "$ARK_COLOR_GREEN"
    fi
    ark_notify_menu_reload
    if [[ $removed -eq 0 ]]; then
        ark_status "$ARK_WARN" "No ARK desktop/menu entries found to remove." "$ARK_COLOR_YELLOW"
    else
        ark_status "$ARK_UNINSTALL" "Uninstall complete. The ARK launchers are removed from your device fleet." "$ARK_COLOR_MAGENTA"
    fi
}

# ========== COMMAND-LINE FLAGS ==========
show_help() {
    ark_banner
    echo -e "${ARK_COLOR_CYAN}Usage:${ARK_COLOR_RESET} $0 [install|update|uninstall|help|menu]"
    echo -e "  ${ARK_COLOR_GREEN}install${ARK_COLOR_RESET}   – Install launcher/menu entries"
    echo -e "  ${ARK_COLOR_YELLOW}update${ARK_COLOR_RESET}    – Update/refresh all entries"
    echo -e "  ${ARK_COLOR_RED}uninstall${ARK_COLOR_RESET} – Remove all ARK launchers/menu entries"
    echo -e "  ${ARK_COLOR_MAGENTA}menu${ARK_COLOR_RESET}      – Run interactive setup menu (default)"
    echo -e "  ${ARK_COLOR_BLUE}help${ARK_COLOR_RESET}      – Show this help"
    exit 0
}

# ========== INTERACTIVE UI MENU ==========
ark_launcher_menu() {
    while true; do
        clear
        ark_banner
        ark_themed_title
        echo -e "${ARK_COLOR_BLUE}What would you like to do, Commander?${ARK_COLOR_RESET}"
        echo "  1) ${ARK_INSTALL} Install ARK-Orbital-Command launcher"
        echo "  2) ${ARK_UPDATE} Update ARK-Orbital-Command launcher (refresh all entries)"
        echo "  3) ${ARK_UNINSTALL} Uninstall ARK-Orbital-Command launcher (full removal)"
        echo "  4) 📄 Open ARK README"
        echo "  0) 🌌 Exit setup"
        ark_separator
        read -rp "➤ Enter selection [1-4,0]: " sel
        case "$sel" in
            1)
                ark_install_launcher
                read -rp "Press [Enter] to return to menu..." ;;
            2)
                ark_update_launcher
                read -rp "Press [Enter] to return to menu..." ;;
            3)
                echo -e "${ARK_COLOR_YELLOW}Uninstall will remove all ARK-Orbital-Command launchers & menu entries.${ARK_COLOR_RESET}"
                read -rp "Are you sure? (y/N): " confirm
                if [[ "$confirm" =~ ^[Yy]$ ]]; then
                    ark_uninstall_launcher
                else
                    ark_status "$ARK_WARN" "Uninstall cancelled." "$ARK_COLOR_YELLOW"
                fi
                read -rp "Press [Enter] to return to menu..." ;;
            4)
                ark_open_readme
                read -rp "Press [Enter] to return to menu..." ;;
            0)
                echo -e "${ARK_COLOR_MAGENTA}${ARK_SHIP} May The ARK be with you, Commander!${ARK_COLOR_RESET}"; exit 0 ;;
            *)
                ark_status "$ARK_WARN" "Invalid selection, try again." "$ARK_COLOR_YELLOW"
                sleep 1 ;;
        esac
    done
}

# ========== MAIN ==========
case "$1" in
    install)   ark_install_launcher ;;
    update)    ark_update_launcher ;;
    uninstall) ark_uninstall_launcher ;;
    help|-h|--help) show_help ;;
    menu|"")   ark_launcher_menu ;;
    *)         show_help ;;
esac
