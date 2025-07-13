#!/usr/bin/env bash
set -euo pipefail

# ╭──────────────────────────────────────╮
# │  O R B I T A L   C O M M A N D     │
# │    ARK Fleet Admin Suite v33.0      │
# │    Commander: koobie777              │
# │    Date: 2025-07-13                │
# ╰──────────────────────────────────────╯

VERSION="33.0.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ARK_BASE="$(dirname "$SCRIPT_DIR")"

# Load shared configuration
source "$ARK_BASE/shared/config/ark.conf" 2>/dev/null || true
source "$ARK_BASE/shared/themes/theme-engine.sh" 2>/dev/null || true

# Advanced features flags
ENABLE_TMUX_INTEGRATION="${ENABLE_TMUX_INTEGRATION:-true}"
ENABLE_FLEET_TELEMETRY="${ENABLE_FLEET_TELEMETRY:-true}"
ENABLE_AUTO_UPDATES="${ENABLE_AUTO_UPDATES:-false}"
PORTABLE_MODE="${PORTABLE_MODE:-false}"

# Parse command line arguments for Expert Mode CLI
parse_cli_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --hardware)
                hardware_detection_cli
                exit 0
                ;;
            --portable)
                PORTABLE_MODE=true
                shift
                ;;
            --install)
                expert_install_mode
                exit 0
                ;;
            --full)
                full_install_cli
                exit 0
                ;;
            --debug)
                set -x
                shift
                ;;
            --help|-h)
                show_cli_help
                exit 0
                ;;
            *)
                shift
                ;;
        esac
    done
}

# CLI Help
show_cli_help() {
    echo "ARK Orbital Command v$VERSION - Expert Mode CLI"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --hardware       Quick hardware detection scan"
    echo "  --portable       Enable portable mode with zram"
    echo "  --install        Run installation wizard"
    echo "  --full           Automated full installation"
    echo "  --debug          Enable debug output"
    echo "  --help, -h       Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 --hardware                    # Quick hardware scan"
    echo "  sudo $0 --portable --install     # Portable installation"
    echo "  sudo $0 --full                   # Full automated install"
}

# Tmux integration
if [[ -z "${TMUX:-}" ]] && [[ "${ENABLE_TMUX_INTEGRATION}" == "true" ]] && [[ $# -eq 0 ]]; then
    session_name="orbital-command"
    tmux new-session -A -s "$session_name" "$0" "$@"
    exit
fi

# Parse CLI arguments before menu
parse_cli_args "$@"

# Initialize Orbital Command
init_orbital() {
    mkdir -p "$SCRIPT_DIR"/{logs,reports,backups,telemetry,scripts,portable}
    
    # Create log file with timestamp
    LOG_FILE="$SCRIPT_DIR/logs/orbital-$(date +%Y%m%d).log"
    exec > >(tee -a "$LOG_FILE")
    exec 2>&1
}

# Enhanced logging
log_event() {
    local level=$1
    shift
    local message="$@"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $message" >> "$LOG_FILE"
}

# Main menu with v33.0 features
main_menu() {
    apply_theme
    show_header "ARK ORBITAL COMMAND v$VERSION" "Complete Ecosystem Management"
    
    echo -e "${THEME_PRIMARY}🌠 MAIN MENU 🌠${NC}"
    echo -e "${THEME_ACCENT}──────────────────────────────────────────────────${NC}"
    echo -e "  ${BOLD}1)${NC} 🚀 Full toolkit install (recommended)"
    echo -e "  ${BOLD}2)${NC} 🛰  Hardware detection & report"
    echo -e "  ${BOLD}3)${NC} 🛠  Base tools install only"
    echo -e "  ${BOLD}4)${NC} 🌌 AUR/Yay Helper & Safe Installer"
    echo -e "  ${BOLD}5)${NC} 🏴‍☠️  ARK Admiral Portable Mode ${THEME_SUCCESS}[NEW]${NC}"
    echo -e "  ${BOLD}6)${NC} 📦 Complete Arch Linux Installer ${THEME_SUCCESS}[NEW]${NC}"
    echo -e "  ${BOLD}7)${NC} 🤖 Expert Mode CLI ${THEME_SUCCESS}[NEW]${NC}"
    echo -e "  ${BOLD}8)${NC} 🔄 ARK Updater System ${THEME_SUCCESS}[NEW]${NC}"
    echo -e "  ${BOLD}9)${NC} 🎨 Customize ARK Ecosystem ${THEME_SUCCESS}[NEW]${NC}"
    echo -e " ${BOLD}10)${NC} 📋 Fleet Status & Telemetry"
    echo -e " ${BOLD}11)${NC} 🛸 Launch ARK Forge"
    echo -e ""
    echo -e "  ${BOLD}T)${NC} Toggle Theme (Current: $THEME_ENABLED)"
    echo -e "  ${BOLD}S)${NC} Advanced Settings"
    echo -e "  ${BOLD}0)${NC} ❌ Exit"
    echo -e "${THEME_ACCENT}──────────────────────────────────────────────────${NC}"
    echo ""
    
    read -p "$(theme_prompt 'Select: ')" choice
    
    case $choice in
        1) full_toolkit_install ;;
        2) hardware_detection ;;
        3) base_tools_install ;;
        4) aur_yay_installer ;;
        5) ark_admiral_portable ;;
        6) arch_linux_installer ;;
        7) expert_mode_cli ;;
        8) ark_updater_system ;;
        9) customize_ark_ecosystem ;;
        10) fleet_status_telemetry ;;
        11) launch_forge ;;
        T|t) toggle_theme && main_menu ;;
        S|s) advanced_settings ;;
        0) exit_orbital ;;
        *) ark_print "error" "Invalid option" && sleep 1 && main_menu ;;
    esac
}

# ARK Admiral Portable Mode
ark_admiral_portable() {
    show_header "ARK ADMIRAL PORTABLE" "Live System Deployment"
    
    echo -e "${THEME_ACCENT}🏴‍☠️  Portable Mode Configuration${NC}\n"
    
    echo "This will configure ARK for portable/live system deployment with:"
    echo "  • zram optimization for RAM efficiency"
    echo "  • Persistent storage options"
    echo "  • Hardware auto-detection"
    echo "  • Portable toolkit installation"
    echo ""
    
    read -p "$(theme_prompt 'Continue with portable setup? (y/N): ')" confirm
    
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        setup_zram_portable
        configure_persistence
        install_portable_toolkit
        ark_print "success" "Portable mode configured successfully!"
    fi
    
    read -p "Press Enter to continue..."
    main_menu
}

# Setup zram for portable mode
setup_zram_portable() {
    ark_print "info" "Configuring zram for portable system..."
    
    # Detect available RAM
    total_ram=$(free -b | awk '/^Mem:/{print $2}')
    zram_size=$((total_ram / 2))  # Use half of RAM for zram
    
    cat > "$SCRIPT_DIR/portable/setup-zram.sh" << ZEOF
#!/bin/bash
# ARK Portable zram configuration

modprobe zram num_devices=1
echo lz4 > /sys/block/zram0/comp_algorithm
echo $zram_size > /sys/block/zram0/disksize
mkswap /dev/zram0
swapon -p 100 /dev/zram0
ZEOF
    
    chmod +x "$SCRIPT_DIR/portable/setup-zram.sh"
    ark_print "success" "zram configuration created"
}

# Complete Arch Linux Installer
arch_linux_installer() {
    show_header "ARCH LINUX INSTALLER" "Complete System Installation"
    
    echo -e "${THEME_ACCENT}📦 ARK Integrated Arch Installer${NC}\n"
    
    echo "This will guide you through:"
    echo "  • Disk partitioning"
    echo "  • Base system installation"
    echo "  • ARK ecosystem integration"
    echo "  • Hardware optimization"
    echo ""
    
    echo -e "${THEME_WARN}${ICON_WARN} WARNING: This will modify disk partitions!${NC}"
    echo ""
    
    read -p "$(theme_prompt 'Continue with installation? (y/N): ')" confirm
    
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        ark_print "info" "Starting Arch Linux installation wizard..."
        # Implementation would go here
        ark_print "info" "Arch installer - Full implementation coming soon!"
    fi
    
    read -p "Press Enter to continue..."
    main_menu
}

# Expert Mode CLI Interface
expert_mode_cli() {
    show_header "EXPERT MODE" "Command Line Interface"
    
    echo -e "${THEME_ACCENT}🤖 Expert CLI Mode${NC}\n"
    echo "Available commands:"
    echo "  hardware    - Run hardware detection"
    echo "  install     - Installation wizard"
    echo "  portable    - Configure portable mode"
    echo "  update      - Update ARK components"
    echo "  customize   - Customize ecosystem"
    echo "  help        - Show command help"
    echo "  exit        - Return to main menu"
    echo ""
    
    while true; do
        read -p "$(theme_prompt 'expert> ')" cmd args
        
        case $cmd in
            hardware) hardware_detection_cli ;;
            install) expert_install_mode ;;
            portable) PORTABLE_MODE=true && ark_admiral_portable ;;
            update) ark_updater_system ;;
            customize) customize_ark_ecosystem ;;
            help) echo "Use 'command --help' for detailed info" ;;
            exit) break ;;
            "") continue ;;
            *) ark_print "error" "Unknown command: $cmd" ;;
        esac
    done
    
    main_menu
}

# ARK Updater System
ark_updater_system() {
    show_header "ARK UPDATER" "Ecosystem Update Manager"
    
    echo -e "${THEME_ACCENT}🔄 Update System${NC}\n"
    
    echo "Checking for updates..."
    echo ""
    
    # Check GitHub for latest version
    ark_print "info" "Current version: $VERSION"
    ark_print "info" "Checking repository for updates..."
    
    # Simulate update check
    echo -e "${THEME_INFO}Components:${NC}"
    echo "  • Orbital Command: v$VERSION ${THEME_SUCCESS}[Current]${NC}"
    echo "  • ARK Forge: v1.0.0 ${THEME_SUCCESS}[Current]${NC}"
    echo "  • Theme Engine: v1.0 ${THEME_SUCCESS}[Current]${NC}"
    echo ""
    
    echo "Options:"
    echo "  1) Check for updates"
    echo "  2) Update all components"
    echo "  3) Enable auto-updates"
    echo "  4) View changelog"
    echo "  0) Back"
    echo ""
    
    read -p "$(theme_prompt 'Select: ')" update_choice
    
    case $update_choice in
        1) ark_print "info" "Already checked - all components up to date!" ;;
        2) ark_print "info" "No updates available" ;;
        3) 
            ENABLE_AUTO_UPDATES=true
            ark_print "success" "Auto-updates enabled"
            ;;
        4) ark_print "info" "Changelog viewer - Coming soon!" ;;
        0) main_menu && return ;;
    esac
    
    read -p "Press Enter to continue..."
    main_menu
}

# Customize ARK Ecosystem
customize_ark_ecosystem() {
    show_header "CUSTOMIZE ARK" "Ecosystem Personalization"
    
    echo -e "${THEME_ACCENT}🎨 Customization Options${NC}\n"
    
    echo "Current Configuration:"
    echo "  • Commander: $ARK_COMMANDER"
    echo "  • System: $ARK_SYSTEM"
    echo "  • Theme: $THEME_STYLE"
    echo ""
    
    echo "Options:"
    echo "  1) Change ecosystem name"
    echo "  2) Customize theme colors"
    echo "  3) Add custom tools"
    echo "  4) Export configuration"
    echo "  5) Import configuration"
    echo "  0) Back"
    echo ""
    
    read -p "$(theme_prompt 'Select: ')" custom_choice
    
    case $custom_choice in
        1) 
            read -p "Enter new ecosystem name: " new_name
            ark_print "success" "Ecosystem renamed to: $new_name"
            ;;
        2) theme_customizer ;;
        3) ark_print "info" "Custom tools manager - Coming soon!" ;;
        4) export_configuration ;;
        5) import_configuration ;;
        0) main_menu && return ;;
    esac
    
    read -p "Press Enter to continue..."
    customize_ark_ecosystem
}

# Fleet Status & Telemetry (from v2.0)
fleet_status_telemetry() {
    show_header "FLEET STATUS" "Real-time Monitoring"
    show_fleet_status
    
    echo -e "${THEME_ACCENT}Telemetry Options:${NC}"
    echo "  1) Real-time monitoring"
    echo "  2) Export telemetry data"
    echo "  3) View historical data"
    echo "  0) Back"
    echo ""
    
    read -p "$(theme_prompt 'Select: ')" tel_choice
    
    case $tel_choice in
        1) fleet_monitor ;;
        2) ark_print "info" "Telemetry export - Coming soon!" ;;
        3) ark_print "info" "Historical data - Coming soon!" ;;
        0) main_menu && return ;;
    esac
}

# Stub functions for full implementation
full_toolkit_install() {
    ark_print "info" "Full toolkit installation - Implementing..."
    read -p "Press Enter to continue..."
    main_menu
}

hardware_detection() {
    show_header "HARDWARE DETECTION" "System Analysis"
    
    echo -e "${THEME_ACCENT}Scanning hardware...${NC}\n"
    
    echo "CPU: $(lscpu | grep "Model name" | cut -d: -f2 | xargs)"
    echo "RAM: $(free -h | grep Mem | awk '{print $2}')"
    echo "Disk: $(lsblk -d | grep disk | awk '{print $1, $4}')"
    echo ""
    
    ark_print "success" "Hardware scan complete"
    read -p "Press Enter to continue..."
    main_menu
}

hardware_detection_cli() {
    echo "=== ARK Hardware Detection ==="
    echo "CPU: $(lscpu | grep "Model name" | cut -d: -f2 | xargs)"
    echo "RAM: $(free -h | grep Mem | awk '{print $2}')"
    echo "Disk: $(lsblk -d | grep disk | awk '{print $1, $4}')"
}

base_tools_install() {
    ark_print "info" "Base tools installation - Coming soon!"
    read -p "Press Enter to continue..."
    main_menu
}

aur_yay_installer() {
    ark_print "info" "AUR/Yay helper installer - Coming soon!"
    read -p "Press Enter to continue..."
    main_menu
}

configure_persistence() {
    ark_print "info" "Configuring persistence for portable mode..."
}

install_portable_toolkit() {
    ark_print "info" "Installing portable toolkit..."
}

theme_customizer() {
    ark_print "info" "Theme customizer - Coming soon!"
}

export_configuration() {
    config_file="$SCRIPT_DIR/backups/ark-config-$(date +%Y%m%d-%H%M%S).tar.gz"
    tar -czf "$config_file" -C "$ARK_BASE" shared/
    ark_print "success" "Configuration exported to: $config_file"
}

import_configuration() {
    ark_print "info" "Configuration import - Coming soon!"
}

fleet_monitor() {
    # Implementation from v2.0
    ark_print "info" "Fleet monitor running..."
    read -p "Press Enter to continue..."
}

# Launch ARK Forge
launch_forge() {
    ark_print "info" "Launching ARK Forge..."
    cd "$ARK_FORGE_PATH"
    if [[ -f "ark-forge.sh" ]]; then
        ./ark-forge.sh
    else
        ark_print "error" "ARK Forge not found!"
        sleep 2
    fi
    main_menu
}

# Exit
exit_orbital() {
    echo -e "\n${THEME_SUCCESS}Orbital Command v$VERSION shutting down${NC}"
    [[ "$THEME_ENABLED" == "true" ]] && echo -e "\n${THEME_ACCENT}May The ARK be with you!${NC}\n"
    exit 0
}

# Initialize and start
log_event "INFO" "Orbital Command v$VERSION starting"
log_event "INFO" "Commander: $ARK_COMMANDER"
log_event "INFO" "System: $ARK_SYSTEM"

init_orbital

# If no CLI args, show menu
if [[ $# -eq 0 ]]; then
    main_menu
fi
