#!/usr/bin/env bash
set -euo pipefail

# ╭──────────────────────────────────────╮
# │  O R B I T A L   C O M M A N D     │
# │    ARK Fleet Admin Suite v34.0      │
# │    Commander: koobie777              │
# │    Date: 2025-07-13                │
# ╰──────────────────────────────────────╯

VERSION="34.0.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ARK_BASE="$(dirname "$SCRIPT_DIR")"

# Load shared configuration
source "$ARK_BASE/shared/config/ark.conf" 2>/dev/null || true
source "$ARK_BASE/shared/themes/theme-engine.sh" 2>/dev/null || true

# GitHub Integration flags
GITHUB_CONFIGURED="${GITHUB_CONFIGURED:-false}"
SSH_AGENT_RUNNING="${SSH_AGENT_RUNNING:-false}"

# Check if SSH agent is running
check_ssh_agent() {
    if [[ -n "${SSH_AUTH_SOCK:-}" ]]; then
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
    if [[ -f ~/.ssh/id_ed25519 ]] && [[ "$GITHUB_CONFIGURED" == "true" ]]; then
        github_status="✅ Connected"
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

# GitHub Integration Setup
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

# Generate SSH Key
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

# Configure SSH Agent
configure_ssh_agent() {
    ark_print "info" "Configuring SSH agent..."
    
    # Start SSH agent
    eval "$(ssh-agent -s)" > /dev/null 2>&1
    
    # Add key to agent
    if [[ -f ~/.ssh/id_ed25519 ]]; then
        ssh-add ~/.ssh/id_ed25519
        
        # Create persistent SSH agent config
        cat > ~/.ssh/config << 'SSHEOF'
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519
    AddKeysToAgent yes
SSHEOF
        
        chmod 600 ~/.ssh/config
        
        # Add to shell profile for persistence
        echo "" >> ~/.bashrc
        echo "# The ARK SSH Agent" >> ~/.bashrc
        echo 'if [ -z "$SSH_AUTH_SOCK" ]; then' >> ~/.bashrc
        echo '    eval "$(ssh-agent -s)" > /dev/null 2>&1' >> ~/.bashrc
        echo '    ssh-add ~/.ssh/id_ed25519 2>/dev/null' >> ~/.bashrc
        echo 'fi' >> ~/.bashrc
        
        SSH_AGENT_RUNNING=true
        ark_print "success" "SSH agent configured and will start automatically!"
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

# Configure ARK Repositories
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
    
    # Show status
    echo ""
    ark_print "info" "Repository Status:"
    cd "$ARK_BASE/ark-orbital-command" && echo "  • Orbital Command: $(git remote get-url origin)"
    cd "$ARK_BASE/ark-forge" && echo "  • ARK Forge: $(git remote get-url origin)"
}

# Troubleshoot GitHub Issues
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

# Include all other functions from v33...
# (Full toolkit install, hardware detection, etc.)

# Initialize
check_ssh_agent
init_orbital

# If no CLI args, show menu
if [[ $# -eq 0 ]]; then
    main_menu
fi
