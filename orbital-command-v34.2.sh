#!/usr/bin/env bash
#
# ╔═══════════════════════════════════════════════════════════════╗
# ║                  ORBITAL COMMAND ADMIN SUITE                 ║
# ║                         Version 34.2                         ║
# ║                    The ARK Ecosystem                         ║
# ║                  Commander: koobie777                        ║
# ╚═══════════════════════════════════════════════════════════════╝
#
# Enhanced with configurable ARK greeting and SSH management
# Date: 2025-07-13 02:01:31 UTC

set -euo pipefail

# ARK Configuration Management
setup_ark_config() {
    if [ ! -f ~/.ark_config ]; then
        cat > ~/.ark_config << 'ARKEOF'
# The ARK Ecosystem Configuration v34.2
ARK_GREETING_ENABLED=true
ARK_GREETING_STYLE="full"
ARK_COMMANDER_NAME="koobie777"
ARK_SYSTEM_NAME="arksupreme-mk1"
ARK_CUSTOM_MESSAGE="The ARK is ready, Commander!"
ARK_VERSION="v34.2"
ARK_SSH_AUTO_SETUP=true
ARK_SSH_PASSWORDLESS=true
ARK_DEV_MODE=true
ARK_AUTO_UPDATE=false
ARKEOF
        echo "✅ ARK configuration created"
    fi
    source ~/.ark_config
}

# ARK SSH Key Management
setup_ark_ssh() {
    echo ""
    echo "🔑 ARK SSH Key Management v34.2"
    echo "================================="
    
    # Check for existing SSH key
    if [ ! -f ~/.ssh/id_ed25519 ]; then
        echo "🚀 Generating passwordless SSH key for The ARK ecosystem..."
        mkdir -p ~/.ssh
        ssh-keygen -t ed25519 -C "koobie777@arksupreme-mk1-ark-ecosystem" -f ~/.ssh/id_ed25519 -N ""
        
        echo ""
        echo "🔑 New ARK SSH Key (passwordless):"
        echo "════════════════════════════════════════════════════════════"
        cat ~/.ssh/id_ed25519.pub
        echo "════════════════════════════════════════════════════════════"
        echo ""
        echo "📋 To complete setup:"
        echo "   1. Copy the key above"
        echo "   2. Go to GitHub → Settings → SSH and GPG keys"
        echo "   3. Click 'New SSH key'"
        echo "   4. Paste the key and save"
        echo ""
        read -p "Press Enter after adding to GitHub..."
    else
        echo "✅ SSH key already exists"
    fi
    
    # Configure SSH
    cat > ~/.ssh/config << 'ARKEOF'
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519
    AddKeysToAgent yes
ARKEOF
    
    chmod 600 ~/.ssh/config
    chmod 600 ~/.ssh/id_ed25519* 2>/dev/null || true
    
    # Start SSH agent and add key
    eval "$(ssh-agent -s)" > /dev/null 2>&1
    ssh-add ~/.ssh/id_ed25519 2>/dev/null || true
    
    # Test GitHub connection
    echo "🧪 Testing GitHub connection..."
    if timeout 10 ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
        echo "✅ GitHub SSH connection successful!"
        echo "🌌 The ARK ecosystem is connected to GitHub!"
        return 0
    else
        echo "⚠️  GitHub connection failed. Please:"
        echo "   - Add the SSH key to GitHub"
        echo "   - Check your internet connection"
        echo "   - Try running this setup again"
        return 1
    fi
}

# ARK Greeting System
show_ark_greeting() {
    source ~/.ark_config 2>/dev/null || return 0
    
    if [[ "$ARK_GREETING_ENABLED" == "true" ]]; then
        case "$ARK_GREETING_STYLE" in
            "full")
                echo "🚀 The ARK Ecosystem v$ARK_VERSION"
                echo "Commander: $ARK_COMMANDER_NAME | System: $ARK_SYSTEM_NAME"
                echo "🌌 $ARK_CUSTOM_MESSAGE"
                ;;
            "minimal")
                echo "🚀 ARK v$ARK_VERSION ready, $ARK_COMMANDER_NAME"
                ;;
            "silent")
                # Silent mode - no output
                ;;
        esac
    fi
}

# System Information
get_system_info() {
    echo "📊 System Information:"
    echo "  OS: $(lsb_release -d 2>/dev/null | cut -f2 || echo "Unknown")"
    echo "  Kernel: $(uname -r)"
    echo "  CPU: $(lscpu | grep "Model name" | cut -d: -f2 | xargs 2>/dev/null || echo "Unknown")"
    echo "  Memory: $(free -h | awk '/^Mem:/ {print $2}' 2>/dev/null || echo "Unknown")"
    echo "  Storage: $(df -h / | awk 'NR==2 {print $4 " free of " $2}' 2>/dev/null || echo "Unknown")"
}

# Enhanced Package Management
install_ark_essentials() {
    echo "🛠️  Installing ARK Essential Tools..."
    
    # Base development tools
    local base_packages=(
        "base-devel" "git" "curl" "wget" "vim" "nano" "htop" "tree"
        "unzip" "zip" "p7zip" "rsync" "screen" "tmux" "jq" "bc"
    )
    
    # Android development tools
    local android_packages=(
        "android-tools" "python" "python-pip"
        "java-openjdk" "ccache" "schedtool" "squashfs-tools"
    )
    
    echo "Installing base development tools..."
    for package in "${base_packages[@]}"; do
        if ! pacman -Q "$package" &>/dev/null; then
            echo "  📦 Installing $package..."
            pacman -S --noconfirm "$package" || echo "    ⚠️  Failed to install $package"
        else
            echo "  ✅ $package already installed"
        fi
    done
    
    echo "Installing Android development tools..."
    for package in "${android_packages[@]}"; do
        if ! pacman -Q "$package" &>/dev/null; then
            echo "  📱 Installing $package..."
            pacman -S --noconfirm "$package" || echo "    ⚠️  Failed to install $package"
        else
            echo "  ✅ $package already installed"
        fi
    done
    
    # Setup AUR helper (yay)
    if ! command -v yay &>/dev/null; then
        echo "🔧 Installing yay AUR helper..."
        cd /tmp
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm
        cd - && rm -rf /tmp/yay
        echo "✅ yay installed successfully"
    else
        echo "✅ yay already available"
    fi
}

# Hardware Optimization
optimize_for_android_dev() {
    echo "⚡ Optimizing system for Android development..."
    
    # Increase file watchers for large Android projects
    echo "fs.inotify.max_user_watches=524288" | tee /etc/sysctl.d/99-ark-android.conf
    sysctl -p /etc/sysctl.d/99-ark-android.conf 2>/dev/null || true
    
    # Setup ccache
    export USE_CCACHE=1
    export CCACHE_DIR="$HOME/.ccache"
    ccache -M 50G 2>/dev/null || echo "⚠️  ccache setup skipped"
    
    # USB rules for Android devices
    echo "🔌 Setting up Android device USB rules..."
    cat > /etc/udev/rules.d/51-android.rules << 'ARKEOF'
# Android USB rules for The ARK
SUBSYSTEM=="usb", ATTR{idVendor}=="22b8", MODE="0666", GROUP="plugdev"
SUBSYSTEM=="usb", ATTR{idVendor}=="2ae5", MODE="0666", GROUP="plugdev"
SUBSYSTEM=="usb", ATTR{idVendor}=="04e8", MODE="0666", GROUP="plugdev"
SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", MODE="0666", GROUP="plugdev"
SUBSYSTEM=="usb", ATTR{idVendor}=="2717", MODE="0666", GROUP="plugdev"
ARKEOF
    
    udevadm control --reload-rules 2>/dev/null || true
    usermod -a -G plugdev "$USER" 2>/dev/null || true
    
    echo "✅ Hardware optimization complete"
}

# ARK Fleet Status
show_fleet_status() {
    echo ""
    echo "🚀 The ARK Fleet Status"
    echo "======================="
    echo "🛰️  Orbital Command: ACTIVE (v34.2)"
    echo "🔧 ARK Forge: DEVELOPMENT"
    echo ""
    echo "📱 Fleet Devices:"
    echo "  • OnePlus 12 'Waffle': ACTIVE"
    echo "  • [REDACTED]: CLASSIFIED"
    echo "  • [CLASSIFIED]: CLASSIFIED"
    echo ""
    echo "🌌 All systems operational, Commander!"
}

# ARK Configuration Manager
manage_ark_config() {
    echo ""
    echo "⚙️  ARK Configuration Manager"
    echo "============================="
    
    if [ ! -f ~/.ark_config ]; then
        setup_ark_config
    fi
    
    echo "Current ARK Configuration:"
    echo "-------------------------"
    cat ~/.ark_config | grep -E "^ARK_" | sed 's/^/  /'
    echo ""
    
    echo "Configuration Options:"
    echo "  1) Enable/Disable ARK Greeting"
    echo "  2) Change Greeting Style (full/minimal/silent)"
    echo "  3) Update Commander Name"
    echo "  4) Reset to Defaults"
    echo "  0) Return to Main Menu"
    echo ""
    
    read -p "Select option: " config_choice
    
    case $config_choice in
        1)
            read -p "Enable ARK greeting? (y/n): " enable_greeting
            if [[ "$enable_greeting" =~ ^[Yy]$ ]]; then
                sed -i 's/ARK_GREETING_ENABLED=.*/ARK_GREETING_ENABLED=true/' ~/.ark_config
            else
                sed -i 's/ARK_GREETING_ENABLED=.*/ARK_GREETING_ENABLED=false/' ~/.ark_config
            fi
            echo "✅ Greeting preference updated"
            ;;
        2)
            echo "Greeting styles:"
            echo "  full    - Complete ARK initialization display"
            echo "  minimal - Brief ARK ready message"
            echo "  silent  - No greeting display"
            read -p "Select style (full/minimal/silent): " style
            if [[ "$style" =~ ^(full|minimal|silent)$ ]]; then
                sed -i "s/ARK_GREETING_STYLE=.*/ARK_GREETING_STYLE=\"$style\"/" ~/.ark_config
                echo "✅ Greeting style updated to $style"
            else
                echo "❌ Invalid style selected"
            fi
            ;;
        3)
            read -p "Enter new commander name: " new_name
            if [[ -n "$new_name" ]]; then
                sed -i "s/ARK_COMMANDER_NAME=.*/ARK_COMMANDER_NAME=\"$new_name\"/" ~/.ark_config
                echo "✅ Commander name updated to $new_name"
            fi
            ;;
        4)
            rm ~/.ark_config
            setup_ark_config
            echo "✅ Configuration reset to defaults"
            ;;
    esac
}

# Main Menu
show_main_menu() {
    clear
    show_ark_greeting
    echo ""
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║                  ORBITAL COMMAND ADMIN SUITE                 ║"
    echo "║                         Version 34.2                         ║"
    echo "║                      The ARK Ecosystem                       ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo ""
    get_system_info
    echo ""
    echo "🚀 ARK Command Options:"
    echo "  1) 🛠️  Install ARK Essential Tools"
    echo "  2) ⚡ Optimize for Android Development"
    echo "  3) 🔑 Setup GitHub SSH (Passwordless)"
    echo "  4) 📊 Show Fleet Status"
    echo "  5) ⚙️  ARK Configuration Manager"
    echo "  6) 🔄 Update System Packages"
    echo "  7) 🧪 Test ARK Components"
    echo "  0) 🌌 Exit ARK Orbital Command"
    echo ""
}

# Test ARK Components
test_ark_components() {
    echo ""
    echo "🧪 Testing ARK Ecosystem Components"
    echo "==================================="
    
    # Test SSH
    echo "🔑 Testing GitHub SSH connection..."
    if timeout 5 ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
        echo "  ✅ GitHub SSH: OPERATIONAL"
    else
        echo "  ❌ GitHub SSH: FAILED"
    fi
    
    # Test development tools
    echo "🛠️  Testing development tools..."
    local tools=("git" "fastboot" "adb" "java" "python" "ccache")
    for tool in "${tools[@]}"; do
        if command -v "$tool" &>/dev/null; then
            echo "  ✅ $tool: AVAILABLE"
        else
            echo "  ❌ $tool: MISSING"
        fi
    done
    
    # Test ARK configuration
    echo "⚙️  Testing ARK configuration..."
    if [ -f ~/.ark_config ]; then
        echo "  ✅ ARK Config: LOADED"
        source ~/.ark_config
        echo "  ✅ Version: $ARK_VERSION"
        echo "  ✅ Commander: $ARK_COMMANDER_NAME"
    else
        echo "  ❌ ARK Config: MISSING"
    fi
    
    echo ""
    echo "🌌 Component testing complete!"
}

# Update system packages
update_system() {
    echo "🔄 Updating system packages..."
    pacman -Syu --noconfirm
    
    if command -v yay &>/dev/null; then
        echo "🔄 Updating AUR packages..."
        yay -Syu --noconfirm
    fi
    
    echo "✅ System update complete"
}

# Main execution
main() {
    # Setup ARK configuration
    setup_ark_config
    
    while true; do
        show_main_menu
        read -p "Enter your choice: " choice
        
        case $choice in
            1) install_ark_essentials ;;
            2) optimize_for_android_dev ;;
            3) setup_ark_ssh ;;
            4) show_fleet_status ;;
            5) manage_ark_config ;;
            6) update_system ;;
            7) test_ark_components ;;
            0) 
                echo ""
                echo "🌌 Thank you for using The ARK Orbital Command Suite!"
                echo "May The ARK be with you, Commander $ARK_COMMANDER_NAME!"
                exit 0
                ;;
            *) 
                echo "❌ Invalid option. Please try again."
                read -p "Press Enter to continue..."
                ;;
        esac
        
        echo ""
        read -p "Press Enter to continue..."
    done
}

# Check if running as root for package operations
if [[ $EUID -eq 0 ]]; then
    echo "⚠️  Running as root - ARK Orbital Command Suite ready"
else
    echo "ℹ️  Some operations may require sudo privileges"
fi

# Execute main function
main "$@"
