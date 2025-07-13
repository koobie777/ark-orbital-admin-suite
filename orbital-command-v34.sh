#!/usr/bin/env bash

# ╭──────────────────────────────────────╮
# │  O R B I T A L   C O M M A N D     │
# │    ARK Fleet Admin Suite v34.0      │
# │    Commander: koobie777              │
# │    Date: 2025-07-13                │
# ╰──────────────────────────────────────╯

VERSION="34.0.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ARK_BASE="$(dirname "$SCRIPT_DIR")"

# Essential variables with defaults
ARK_COMMANDER="${ARK_COMMANDER:-koobie777}"
ARK_SYSTEM="${ARK_SYSTEM:-arksupreme-mk1}"
THEME_ENABLED="${THEME_ENABLED:-true}"
THEME_STYLE="${THEME_STYLE:-dark}"

# Colors and theming
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

# Theme colors
THEME_PRIMARY="$CYAN"
THEME_SECONDARY="$BLUE"
THEME_SUCCESS="$GREEN"
THEME_WARN="$YELLOW"
THEME_ERROR="$RED"
THEME_INFO="$WHITE"
THEME_ACCENT="$PURPLE"

# Icons
ICON_CHECK="✓"
ICON_WARN="⚠"
ICON_ERROR="✗"
ICON_INFO="ℹ"
ICON_FLEET="🚀"

# GitHub Integration flags
GITHUB_CONFIGURED="${GITHUB_CONFIGURED:-false}"
SSH_AGENT_RUNNING="${SSH_AGENT_RUNNING:-false}"

# Basic functions
ark_print() {
    local type=$1
    shift
    local message="$@"
    
    case $type in
        "success") echo -e "${THEME_SUCCESS}${ICON_CHECK} $message${NC}" ;;
        "error") echo -e "${THEME_ERROR}${ICON_ERROR} $message${NC}" ;;
        "warn") echo -e "${THEME_WARN}${ICON_WARN} $message${NC}" ;;
        "info") echo -e "${THEME_INFO}${ICON_INFO} $message${NC}" ;;
        *) echo -e "$message" ;;
    esac
}

show_header() {
    local title="$1"
    local subtitle="${2:-}"
    
    echo -e "\n${THEME_ACCENT}╭──────────────────────────────────────╮${NC}"
    echo -e "${THEME_ACCENT}│  ${THEME_PRIMARY}$title${THEME_ACCENT}${NC}"
    [[ -n "$subtitle" ]] && echo -e "${THEME_ACCENT}│  ${THEME_INFO}$subtitle${NC}"
    echo -e "${THEME_ACCENT}╰──────────────────────────────────────╯${NC}\n"
}

theme_prompt() {
    echo -e "${THEME_ACCENT}$1${NC}"
}

apply_theme() {
    if [[ "$THEME_ENABLED" == "true" ]]; then
        clear
    fi
}

# Initialize function
init_orbital() {
    mkdir -p "$SCRIPT_DIR"/{logs,reports,backups,telemetry,scripts,portable} 2>/dev/null || true
    
    # Create simple log file
    LOG_FILE="$SCRIPT_DIR/logs/orbital-$(date +%Y%m%d).log"
    touch "$LOG_FILE" 2>/dev/null || LOG_FILE="/tmp/orbital.log"
}

# Check if SSH agent is running
check_ssh_agent() {
    if [[ -n "${SSH_AUTH_SOCK:-}" ]] && ssh-add -l >/dev/null 2>&1; then
        SSH_AGENT_RUNNING=true
    else
        SSH_AGENT_RUNNING=false
    fi
}

# Main menu with GitHub integration
main_menu() {
    apply_theme
    show_header "ARK ORBITAL COMMAND v$VERSION" "Complete Ecosystem Management"
    
    # Check GitHub status
    local github_status="❌ Not Configured"
    if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
        github_status="✅ Connected"
        GITHUB_CONFIGURED=true
    elif [[ -f ~/.ssh/id_ed25519 ]]; then
        github_status="⚠️  SSH Key exists (not verified)"
    fi
    
    echo -e "${THEME_PRIMARY}🌠 MAIN MENU 🌠${NC}"
    echo -e "${THEME_INFO}GitHub: $github_status | SSH Agent: $([[ "$SSH_AGENT_RUNNING" == "true" ]] && echo "✅" || echo "❌")${NC}"
    echo -e "${THEME_ACCENT}──────────────────────────────────────────────────${NC}"
    echo -e "  ${BOLD}1)${NC} 🚀 Full toolkit install (recommended)"
    echo -e "  ${BOLD}2)${NC} 🛰  Hardware detection & report"
    echo -e "  ${BOLD}3)${NC} 🛠  Base tools install only"
    echo -e "  ${BOLD}4)${NC} 🌌 AUR/Yay Helper & Safe Installer"
    echo -e "  ${BOLD}5)${NC} 🏴‍☠️  ARK Admiral Portable Mode"
    echo -e "  ${BOLD}6)${NC} 📦 Complete Arch Linux Installer"
    echo -e "  ${BOLD}7)${NC} 🤖 Expert Mode CLI"
    echo -e "  ${BOLD}8)${NC} 🔄 ARK Updater System"
    echo -e "  ${BOLD}9)${NC} 🎨 Customize ARK Ecosystem"
    echo -e " ${BOLD}10)${NC} 📋 Fleet Status & Telemetry"
    echo -e " ${BOLD}11)${NC} 🔐 GitHub Integration Setup ${THEME_SUCCESS}[NEW v34]${NC}"
    echo -e ""
    echo -e "  ${BOLD}F)${NC} 🛸 Launch ARK Forge"
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
        11) github_integration_setup ;;
        F|f) launch_forge ;;
        T|t) toggle_theme && main_menu ;;
        S|s) advanced_settings ;;
        0) exit_orbital ;;
        *) ark_print "error" "Invalid option" && sleep 1 && main_menu ;;
    esac
}

# GitHub Integration Setup - THE MAIN NEW FEATURE
github_integration_setup() {
    show_header "GITHUB INTEGRATION" "Automated SSH Setup"
    
    echo -e "${THEME_ACCENT}🔐 GitHub Integration for The ARK${NC}\n"
    
    echo "This wizard will:"
    echo "  • Generate SSH keys for GitHub"
    echo "  • Configure SSH agent for passwordless operation"
    echo "  • Set up your ARK repositories"
    echo "  • Test GitHub connectivity"
    echo ""
    
    echo -e "${THEME_ACCENT}Current Status:${NC}"
    echo -n "  • SSH Key: "
    if [[ -f ~/.ssh/id_ed25519 ]]; then
        echo -e "${THEME_SUCCESS}Found${NC}"
        echo -n "  • Public Key: "
        echo -e "${THEME_INFO}$(cat ~/.ssh/id_ed25519.pub | cut -d' ' -f3)${NC}"
    else
        echo -e "${THEME_WARN}Not found${NC}"
    fi
    
    echo -n "  • SSH Agent: "
    check_ssh_agent
    if [[ "$SSH_AGENT_RUNNING" == "true" ]]; then
        echo -e "${THEME_SUCCESS}Running${NC}"
    else
        echo -e "${THEME_WARN}Not running${NC}"
    fi
    
    echo -n "  • GitHub Connection: "
    if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
        echo -e "${THEME_SUCCESS}Authenticated${NC}"
        GITHUB_CONFIGURED=true
    else
        echo -e "${THEME_WARN}Not authenticated${NC}"
    fi
    
    echo ""
    echo -e "${THEME_ACCENT}Options:${NC}"
    echo "  1) Complete GitHub Setup (Recommended)"
    echo "  2) Generate SSH Key only"
    echo "  3) Configure SSH Agent"
    echo "  4) Add SSH Key to GitHub (manual)"
    echo "  5) Test GitHub Connection"
    echo "  6) Configure ARK Repositories"
    echo "  7) Troubleshoot Issues"
    echo "  0) Back"
    echo ""
    
    read -p "$(theme_prompt 'Select: ')" git_choice
    
    case $git_choice in
        1) complete_github_setup ;;
        2) generate_ssh_key ;;
        3) configure_ssh_agent ;;
        4) show_ssh_key_instructions ;;
        5) test_github_connection ;;
        6) configure_ark_repositories ;;
        7) troubleshoot_github ;;
        0) main_menu && return ;;
    esac
    
    read -p "Press Enter to continue..."
    github_integration_setup
}

# Complete GitHub Setup
complete_github_setup() {
    ark_print "info" "Starting complete GitHub setup..."
    echo ""
    
    # Step 1: Generate SSH key if needed
    if [[ ! -f ~/.ssh/id_ed25519 ]]; then
        generate_ssh_key
    else
        ark_print "success" "SSH key already exists"
    fi
    
    # Step 2: Configure SSH agent
    configure_ssh_agent
    
    # Step 3: Show instructions for GitHub
    echo ""
    ark_print "info" "Now add your SSH key to GitHub:"
    echo ""
    echo -e "${THEME_ACCENT}Your SSH Public Key:${NC}"
    echo -e "${THEME_PRIMARY}$(cat ~/.ssh/id_ed25519.pub)${NC}"
    echo ""
    echo -e "${THEME_INFO}Steps:${NC}"
    echo "1. Copy the key above"
    echo "2. Go to: https://github.com/settings/keys"
    echo "3. Click 'New SSH key'"
    echo "4. Title: 'The ARK - $(hostname)'"
    echo "5. Paste the key and click 'Add SSH key'"
    echo ""
    read -p "Press Enter when you've added the key to GitHub..."
    
    # Step 4: Test connection
    test_github_connection
    
    # Step 5: Configure repositories
    if [[ "$GITHUB_CONFIGURED" == "true" ]]; then
        read -p "$(theme_prompt 'Configure ARK repositories? (Y/n): ')" config_repos
        if [[ ! "$config_repos" =~ ^[Nn]$ ]]; then
            configure_ark_repositories
        fi
    fi
}

# Configure SSH Agent - SOLVES THE PASSPHRASE PROBLEM
configure_ssh_agent() {
    ark_print "info" "Configuring SSH agent..."
    
    # Start SSH agent if not running
    if [[ -z "${SSH_AUTH_SOCK:-}" ]]; then
        eval "$(ssh-agent -s)" > /dev/null 2>&1
    fi
    
    # Add key to agent
    if [[ -f ~/.ssh/id_ed25519 ]]; then
        ssh-add ~/.ssh/id_ed25519
        
        # Create persistent SSH agent config
        mkdir -p ~/.ssh
        cat > ~/.ssh/config << 'SSHEOF'
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519
    AddKeysToAgent yes
    UseKeychain yes
SSHEOF
        
        chmod 600 ~/.ssh/config
        
        # Add to shell profile for persistence
        if ! grep -q "ARK SSH Agent" ~/.bashrc; then
            echo "" >> ~/.bashrc
            echo "# The ARK SSH Agent - Auto-start" >> ~/.bashrc
            echo 'if [ -z "$SSH_AUTH_SOCK" ]; then' >> ~/.bashrc
            echo '    eval "$(ssh-agent -s)" > /dev/null 2>&1' >> ~/.bashrc
            echo '    ssh-add ~/.ssh/id_ed25519 2>/dev/null' >> ~/.bashrc
            echo 'fi' >> ~/.bashrc
        fi
        
        SSH_AGENT_RUNNING=true
        ark_print "success" "SSH agent configured! No more passphrases needed!"
    else
        ark_print "error" "No SSH key found. Generate one first!"
    fi
}

# Test GitHub Connection
test_github_connection() {
    ark_print "info" "Testing GitHub connection..."
    echo ""
    
    if ssh -T git@github.com 2>&1 | tee /tmp/github_test.log | grep -q "successfully authenticated"; then
        GITHUB_CONFIGURED=true
        ark_print "success" "GitHub authentication successful!"
        echo -e "${THEME_INFO}$(cat /tmp/github_test.log)${NC}"
    else
        GITHUB_CONFIGURED=false
        ark_print "error" "GitHub authentication failed!"
        echo -e "${THEME_ERROR}$(cat /tmp/github_test.log)${NC}"
    fi
    
    rm -f /tmp/github_test.log
}

# Show SSH Key Instructions
show_ssh_key_instructions() {
    if [[ -f ~/.ssh/id_ed25519.pub ]]; then
        echo -e "${THEME_ACCENT}Your SSH Public Key:${NC}"
        echo -e "${THEME_PRIMARY}$(cat ~/.ssh/id_ed25519.pub)${NC}"
        echo ""
        echo -e "${THEME_INFO}Add this key to GitHub:${NC}"
        echo "1. Go to: https://github.com/settings/keys"
        echo "2. Click 'New SSH key'"
        echo "3. Title: 'The ARK - $(hostname)'"
        echo "4. Paste the key above"
        echo "5. Click 'Add SSH key'"
    else
        ark_print "error" "No SSH key found! Generate one first."
    fi
}

# Stub functions for other menu items
full_toolkit_install() { ark_print "info" "Full toolkit - Coming soon!"; read -p "Press Enter..."; main_menu; }
hardware_detection() { 
    show_header "HARDWARE DETECTION" "System Analysis"
    echo "CPU: $(lscpu 2>/dev/null | grep "Model name" | cut -d: -f2 | xargs || echo "Unknown")"
    echo "RAM: $(free -h 2>/dev/null | grep Mem | awk '{print $2}' || echo "Unknown")"
    echo "Disk: $(lsblk -d 2>/dev/null | grep disk | awk '{print $1, $4}' || echo "Unknown")"
    read -p "Press Enter..."; main_menu;
}
base_tools_install() { ark_print "info" "Base tools - Coming soon!"; read -p "Press Enter..."; main_menu; }
aur_yay_installer() { ark_print "info" "AUR/Yay - Coming soon!"; read -p "Press Enter..."; main_menu; }
ark_admiral_portable() { ark_print "info" "Portable mode - Coming soon!"; read -p "Press Enter..."; main_menu; }
arch_linux_installer() { ark_print "info" "Arch installer - Coming soon!"; read -p "Press Enter..."; main_menu; }
expert_mode_cli() { ark_print "info" "Expert CLI - Coming soon!"; read -p "Press Enter..."; main_menu; }
ark_updater_system() { ark_print "info" "Updater - Coming soon!"; read -p "Press Enter..."; main_menu; }
customize_ark_ecosystem() { ark_print "info" "Customize - Coming soon!"; read -p "Press Enter..."; main_menu; }
fleet_status_telemetry() { 
    show_header "FLEET STATUS" "The ARK Ecosystem"
    echo -e "${THEME_SUCCESS}✓${NC} OnePlus 12 'Waffle' - Active"
    echo -e "${THEME_WARN}⚠${NC} [CLASSIFIED] - Standby"
    echo -e "${THEME_ERROR}✗${NC} [REDACTED] - Development"
    read -p "Press Enter..."; main_menu;
}
launch_forge() { 
    ark_print "info" "Launching ARK Forge..."
    if [[ -f "$ARK_BASE/ark-forge/ark-forge.sh" ]]; then
        cd "$ARK_BASE/ark-forge"
        ./ark-forge.sh
    else
        ark_print "error" "ARK Forge not found!"
        sleep 2
    fi
    main_menu
}
advanced_settings() { ark_print "info" "Advanced settings - Coming soon!"; read -p "Press Enter..."; main_menu; }
generate_ssh_key() {
    ark_print "info" "Generating SSH key for GitHub..."
    
    read -p "Enter your GitHub email: " github_email
    
    # Generate key
    ssh-keygen -t ed25519 -C "$github_email" -f ~/.ssh/id_ed25519
    
    # Set permissions
    chmod 700 ~/.ssh
    chmod 600 ~/.ssh/id_ed25519
    chmod 644 ~/.ssh/id_ed25519.pub
    
    ark_print "success" "SSH key generated successfully!"
}
configure_ark_repositories() {
    ark_print "info" "Configuring ARK repositories..."
    echo ""
    
    read -p "Enter your GitHub username [koobie777]: " github_user
    github_user=${github_user:-koobie777}
    
    # Configure Orbital Command
    if [[ -d "$ARK_BASE/ark-orbital-command/.git" ]]; then
        cd "$ARK_BASE/ark-orbital-command"
        git remote set-url origin "git@github.com:$github_user/ark-orbital-admin-suite.git"
        ark_print "success" "Orbital Command repository configured"
    fi
    
    # Configure ARK Forge
    if [[ -d "$ARK_BASE/ark-forge/.git" ]]; then
        cd "$ARK_BASE/ark-forge"
        git remote set-url origin "git@github.com:$github_user/Ark-Build-Tool.git"
        ark_print "success" "ARK Forge repository configured"
    fi
    
    echo ""
    ark_print "info" "Repository Status:"
    cd "$ARK_BASE/ark-orbital-command" && echo "  • Orbital Command: $(git remote get-url origin 2>/dev/null || echo "Not configured")"
    cd "$ARK_BASE/ark-forge" && echo "  • ARK Forge: $(git remote get-url origin 2>/dev/null || echo "Not configured")"
}
troubleshoot_github() {
    show_header "TROUBLESHOOTING" "GitHub Integration Issues"
    
    echo -e "${THEME_ACCENT}Common Issues & Solutions:${NC}\n"
    
    echo "1. 'Permission denied (publickey)':"
    echo "   • Ensure SSH key is added to GitHub"
    echo "   • Check SSH agent is running"
    echo "   • Verify key permissions (600)"
    echo ""
    
    echo "2. 'Host key verification failed':"
    echo "   • Run: ssh-keyscan github.com >> ~/.ssh/known_hosts"
    echo ""
    
    echo "3. 'Could not open a connection to your authentication agent':"
    echo "   • Run: eval \$(ssh-agent -s)"
    echo "   • Then: ssh-add ~/.ssh/id_ed25519"
    echo ""
    
    echo -e "${THEME_ACCENT}Diagnostic Commands:${NC}"
    echo "  • ssh -vT git@github.com    # Verbose connection test"
    echo "  • ssh-add -l                # List loaded keys"
    echo "  • cat ~/.ssh/id_ed25519.pub # Show your public key"
}

toggle_theme() {
    if [[ "$THEME_ENABLED" == "true" ]]; then
        THEME_ENABLED=false
    else
        THEME_ENABLED=true
    fi
    ark_print "success" "Theme: $THEME_ENABLED"
    sleep 1
}

exit_orbital() {
    echo -e "\n${THEME_SUCCESS}Orbital Command v$VERSION shutting down${NC}"
    echo -e "\n${THEME_ACCENT}May The ARK be with you!${NC}\n"
    exit 0
}

# Initialize and start
check_ssh_agent
init_orbital

# Start main menu
main_menu
