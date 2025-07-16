#!/usr/bin/env bash
# 🛰️ ARK-TEST: ALL-IN-ONE DIAGNOSTICS SUITE – ADMIRAL A.R.K. FLAGSHIP EDITION

# ===========================
# ARK COLOR & ICON THEMING
# ===========================
ARK_COLOR_CYAN="\033[1;36m"
ARK_COLOR_PURPLE="\033[1;35m"
ARK_COLOR_YELLOW="\033[1;33m"
ARK_COLOR_GREEN="\033[1;32m"
ARK_COLOR_RED="\033[1;31m"
ARK_COLOR_BLUE="\033[1;34m"
ARK_COLOR_MAGENTA="\033[1;35m"
ARK_COLOR_WHITE="\033[1;37m"
ARK_COLOR_RESET="\033[0m"
ARK_ICON_PANEL="🛰️"
ARK_ICON_TEST="🧪"
ARK_ICON_OK="✅"
ARK_ICON_FAIL="❌"
ARK_ICON_WARN="⚠️"
ARK_ICON_SHIP="🚀"
ARK_ICON_CONFIG="⚙️"
ARK_ICON_PACKAGE="📦"
ARK_ICON_NETWORK="🌐"
ARK_ICON_SYSTEM="🖥️"
ARK_ICON_BATTERY="🔋"
ARK_ICON_DISK="💾"
ARK_ICON_CPU="🧠"
ARK_ICON_RAM="💽"
ARK_ICON_GPU="🎮"
ARK_ICON_USB="🔌"
ARK_ICON_ANDROID="🤖"
ARK_ICON_NODE="🟩"
ARK_ICON_GIT="🌐"
ARK_ICON_PYTHON="🐍"
ARK_ICON_EXIT="🌌"
ARK_ICON_MENU="📋"
ARK_ICON_INFO="ℹ️"
ARK_ICON_STEP="🪐"
ARK_ICON_SELECT="➡️"
ARK_ICON_ARROW="➤"
ARK_ICON_SUBMODULE="🧩"
ARK_ICON_HELP="🆘"

# ===========================
# ARK-TEST SUITE BANNER/UI
# ===========================
ark_test_banner() {
    clear
    echo -e "${ARK_COLOR_MAGENTA}"
    echo "╔══════════════════════════════════════════════════════════════════════════════╗"
    echo "║    ${ARK_ICON_TEST}${ARK_COLOR_WHITE}  ARK-TEST: ALL-IN-ONE FLEET DIAGNOSTICS SUITE  ${ARK_ICON_TEST}${ARK_COLOR_MAGENTA}               ║"
    echo "╠══════════════════════════════════════════════════════════════════════════════╣"
    echo -e "║    ${ARK_COLOR_CYAN}Fleet Diagnostics • Modular Subsystems • Guided Checks • Ecosystem Health${ARK_COLOR_MAGENTA} ║"
    echo "╚══════════════════════════════════════════════════════════════════════════════╝"
    echo -e "${ARK_COLOR_RESET}"
}

ark_test_section() {
    local secname="$1"
    echo -e "\n${ARK_COLOR_PURPLE}━━━━━━━━━━━━━━━━━━━ ${ARK_ICON_STEP} $secname ━━━━━━━━━━━━━━━━━━━${ARK_COLOR_RESET}"
}

ark_test_step() {
    local msg="$1"
    echo -e "${ARK_COLOR_BLUE}${ARK_ICON_STEP} $msg${ARK_COLOR_RESET}"
}

ark_test_success() {
    local msg="$1"
    echo -e "${ARK_COLOR_GREEN}${ARK_ICON_OK} $msg${ARK_COLOR_RESET}"
}

ark_test_fail() {
    local msg="$1"
    echo -e "${ARK_COLOR_RED}${ARK_ICON_FAIL} $msg${ARK_COLOR_RESET}"
}

ark_test_warn() {
    local msg="$1"
    echo -e "${ARK_COLOR_YELLOW}${ARK_ICON_WARN} $msg${ARK_COLOR_RESET}"
}

ark_test_info() {
    local msg="$1"
    echo -e "${ARK_COLOR_CYAN}${ARK_ICON_INFO} $msg${ARK_COLOR_RESET}"
}

ark_test_pause() {
    echo -e "\n${ARK_COLOR_MAGENTA}Press [Enter] to continue, Commander.${ARK_COLOR_RESET}"
    read -r
}

# ===========================
# ARK-TEST ERROR HANDLER
# ===========================
ark_test_error() {
    echo -e "\n${ARK_COLOR_RED}${ARK_ICON_FAIL} ⚠️ [ERROR: $1]"
    echo -e "Location: $2"
    echo -e "Fix: $3"
    echo -e "\"I'll guide you, Commander.\"${ARK_COLOR_RESET}"
    echo -e "${ARK_COLOR_MAGENTA}Press [Enter] to review/fix, Commander.${ARK_COLOR_RESET}"
    read -r
}

# ===========================
# ARK-TEST: Guided Modular Suite
# ===========================

# 1. Guided Core System Test
ark_test_core_system() {
    ark_test_banner
    ark_test_section "CORE SYSTEM"
    ark_test_step "Checking kernel and OS info..."
    echo -ne "${ARK_COLOR_WHITE}${ARK_ICON_INFO} Kernel: ${ARK_COLOR_RESET}"
    uname -a
    echo -ne "${ARK_COLOR_WHITE}${ARK_ICON_INFO} OS:     ${ARK_COLOR_RESET}"
    cat /etc/os-release 2>/dev/null | grep PRETTY_NAME || echo "(Unknown)"

    ark_test_step "Checking uptime and system stats..."
    echo -ne "${ARK_COLOR_WHITE}${ARK_ICON_INFO} Uptime: ${ARK_COLOR_RESET}"
    uptime -p

    ark_test_step "Checking disk space..."
    df -h | grep -E '^/|Filesystem'

    ark_test_step "Checking RAM/CPU..."
    free -h
    lscpu | grep 'Model name' | sed 's/Model name:[ ]*//'

    ark_test_success "Core System diagnostics complete."
    ark_test_pause
}

# 2. Guided Network/Internet Test
ark_test_network() {
    ark_test_banner
    ark_test_section "NETWORK & INTERNET"

    # 1. Local IPs
    ark_test_step "Detecting local IPs..."
    local ips; ips="$(hostname -I 2>/dev/null || ip -o -f inet addr show | awk '{print $4}')"
    echo -e "  ${ARK_COLOR_WHITE}Local IP(s):${ARK_COLOR_RESET}"
    echo -e "    $ips"
    [[ "$ips" =~ 127\.0\.0\.1 ]] && ark_test_info "Loopback address present (normal for most systems)."
    [[ "$ips" =~ 192\.168\. ]] && ark_test_success "LAN IP detected."

    # 2. Gateway Ping
    ark_test_step "Testing Gateway connectivity..."
    local GATEWAY; GATEWAY=$(ip route | grep default | awk '{print $3}' | head -n1)
    echo -e "  ${ARK_COLOR_WHITE}Gateway:${ARK_COLOR_RESET} $GATEWAY"
    if ping -c 1 "$GATEWAY" &>/dev/null; then
        ark_test_success "Gateway is reachable."
    else
        ark_test_fail "Gateway ping failed."
        ark_test_info "Check your router or local network connection."
    fi

    # 3. DNS
    ark_test_step "Checking DNS servers..."
    local dns; dns=$(grep "nameserver" /etc/resolv.conf | awk '{print $2}' | paste -sd ",")
    echo -e "  ${ARK_COLOR_WHITE}DNS:${ARK_COLOR_RESET} $dns"
    [[ -z "$dns" ]] && ark_test_warn "No DNS servers configured."

    # 4. Internet Connectivity
    ark_test_step "Testing internet connectivity..."
    if curl -m 3 -s https://1.1.1.1 &>/dev/null; then
        ark_test_success "Internet connectivity: OK"
    else
        ark_test_fail "Internet connectivity: FAILED"
        ark_test_info "Check your WAN connection or firewall settings."
    fi

    # 5. Speedtest
    ark_test_step "Speedtest (if available)..."
    if command -v speedtest &>/dev/null; then
        speedtest --simple
        ark_test_info "For more detailed speed tests, consider using fast.com or your ISP's tool."
    else
        ark_test_warn "Speedtest CLI not installed."
        ark_test_info "Would you like to install Speedtest CLI now, Commander? [Y/n]"
        read -r install_speedtest
        if [[ "$install_speedtest" =~ ^[Yy]$|^$ ]]; then
            if command -v pacman &>/dev/null; then
                sudo pacman -S --noconfirm speedtest-cli && ark_test_success "Speedtest CLI installed."
                speedtest --simple
            elif command -v apt &>/dev/null; then
                sudo apt update && sudo apt install -y speedtest-cli && ark_test_success "Speedtest CLI installed."
                speedtest --simple
            else
                ark_test_fail "Automatic install not supported on this system."
            fi
        else
            ark_test_info "Commander chose not to install Speedtest CLI."
        fi
    fi

    # 6. Results Summary
    echo -e "\n${ARK_COLOR_CYAN}━━━━━━━━━━━ ${ARK_ICON_INFO} NETWORK SUMMARY ━━━━━━━━━━━${ARK_COLOR_RESET}"
    if [[ "$ips" =~ 192\.168\. ]] && [[ -n "$GATEWAY" ]] && curl -m 3 -s https://1.1.1.1 &>/dev/null; then
        ark_test_success "Network is fully operational, Commander."
    else
        ark_test_warn "One or more network checks failed. Review output above."
    fi

    ark_test_pause
}

# 3. Guided Git & GitHub Test
ark_test_git_github() {
    ark_test_banner
    ark_test_section "GIT & GITHUB"
    ark_test_step "Checking Git version..."
    git --version || ark_test_fail "Git not installed."

    ark_test_step "Testing SSH connection to GitHub..."
    if timeout 5 ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
        ark_test_success "GitHub SSH: OPERATIONAL"
    else
        ark_test_fail "GitHub SSH: FAILED"
    fi

    ark_test_step "Checking for git submodules..."
    if [ -f .gitmodules ]; then
        git submodule status
        ark_test_success "Submodules detected."
    else
        ark_test_warn "No git submodules detected."
    fi

    ark_test_success "Git & GitHub diagnostics complete."
    ark_test_pause
}

# 4. Guided Dev Tools Test
ark_test_dev_tools() {
    ark_test_banner
    ark_test_section "DEVELOPMENT TOOLS"
    local tools=("git" "fastboot" "adb" "java" "python" "ccache" "repo" "make" "gcc" "clang" "ninja")
    for tool in "${tools[@]}"; do
        ark_test_step "Checking $tool..."
        if command -v "$tool" &>/dev/null; then
            ark_test_success "$tool: AVAILABLE"
        else
            ark_test_fail "$tool: MISSING"
        fi
    done
    ark_test_success "Dev tools diagnostics complete."
    ark_test_pause
}

# 5. Guided Android Build Env Test
ark_test_android_env() {
    ark_test_banner
    ark_test_section "ANDROID BUILD ENVIRONMENT"

    local build_root="$HOME/android"
    local found_sdk=""
    local found_ndk=""
    local rom_device_dir

    # Scan for SDK/NDK in ARK build directories
    for rom_device_dir in "$build_root"/*; do
        [[ -d "$rom_device_dir" ]] || continue
        [[ -d "$rom_device_dir"/sdk ]] && found_sdk="$rom_device_dir/sdk"
        [[ -d "$rom_device_dir"/android-sdk ]] && found_sdk="$rom_device_dir/android-sdk"
        [[ -d "$rom_device_dir"/ndk ]] && found_ndk="$rom_device_dir/ndk"
        [[ -d "$rom_device_dir"/android-ndk ]] && found_ndk="$rom_device_dir/android-ndk"
        [[ -n "$found_sdk" && -n "$found_ndk" ]] && break
    done

    # ANDROID_HOME/SDK
    if [[ -n "$ANDROID_HOME" || -n "$ANDROID_SDK_ROOT" ]]; then
        ark_test_success "ANDROID_HOME/SDK: Set"
    elif [[ -n "$found_sdk" ]]; then
        ark_test_warn "ANDROID_HOME/SDK: Not Set"
        ark_test_info "Detected SDK at: $found_sdk"
        echo -e "${ARK_COLOR_MAGENTA}Would you like to export ANDROID_SDK_ROOT for this session? [Y/n]${ARK_COLOR_RESET}"
        read -r set_sdk
        if [[ "$set_sdk" =~ ^[Yy]$|^$ ]]; then
            export ANDROID_SDK_ROOT="$found_sdk"
            ark_test_success "ANDROID_SDK_ROOT exported."
        fi
    else
        ark_test_fail "ANDROID_HOME/SDK: Not Set"
        ark_test_info "No SDK detected in $build_root/*/sdk or android-sdk."
        ark_test_info "Please run ARKFORGE or place your SDK in the correct directory."
    fi

    # ANDROID_NDK_HOME
    if [[ -n "$ANDROID_NDK_HOME" ]]; then
        ark_test_success "ANDROID_NDK_HOME: Set"
    elif [[ -n "$found_ndk" ]]; then
        ark_test_warn "ANDROID_NDK_HOME: Not Set"
        ark_test_info "Detected NDK at: $found_ndk"
        echo -e "${ARK_COLOR_MAGENTA}Would you like to export ANDROID_NDK_HOME for this session? [Y/n]${ARK_COLOR_RESET}"
        read -r set_ndk
        if [[ "$set_ndk" =~ ^[Yy]$|^$ ]]; then
            export ANDROID_NDK_HOME="$found_ndk"
            ark_test_success "ANDROID_NDK_HOME exported."
        fi
    else
        ark_test_fail "ANDROID_NDK_HOME: Not Set"
        ark_test_info "No NDK detected in $build_root/*/ndk or android-ndk."
        ark_test_info "Please run ARKFORGE or place your NDK in the correct directory."
    fi

    # repo tool
    if command -v repo &>/dev/null; then
        ark_test_success "repo: AVAILABLE"
    else
        ark_test_fail "repo: MISSING"
        ark_test_info "Install with: sudo pacman -S repo (or use your package manager)."
    fi

    ark_test_success "Android build environment diagnostics complete."
    ark_test_pause
}

# 6. Guided Python Environment Test
ark_test_python() {
    ark_test_banner
    ark_test_section "PYTHON ECOSYSTEM"
    command -v python3 &>/dev/null && ark_test_success "python3: $(python3 --version)" || ark_test_fail "python3: NOT FOUND"
    command -v pipx &>/dev/null && ark_test_success "pipx: $(pipx --version)" || ark_test_fail "pipx: NOT FOUND"
    command -v pip3 &>/dev/null && {
        ark_test_success "pip3: $(pip3 --version)"
        pip3 list --user --outdated --format=columns 2>/dev/null | grep -vE '^Package|^-|^$' || echo "  All user pip packages up-to-date."
    }
    ark_test_success "Python diagnostics complete."
    ark_test_pause
}

# 7. Guided Node.js Environment Test
ark_test_node() {
    ark_test_banner
    ark_test_section "NODE.JS ECOSYSTEM"
    command -v node &>/dev/null && ark_test_success "node: $(node --version)" || ark_test_fail "node: NOT FOUND"
    for mgr in npm yarn pnpm; do
        command -v "$mgr" &>/dev/null && ark_test_success "$mgr: $($mgr --version)" || ark_test_fail "$mgr: NOT FOUND"
    done
    ark_test_success "Node.js diagnostics complete."
    ark_test_pause
}

# 8. Guided USB Devices Test
ark_test_usb() {
    ark_test_banner
    ark_test_section "USB DEVICES"
    lsusb || ark_test_warn "lsusb not available"
    ark_test_success "USB device diagnostics complete."
    ark_test_pause
}

# 9. Guided ARK Config Test
ark_test_config() {
    ark_test_banner
    ark_test_section "ARK CONFIGURATION"
    if [ -f ~/.ark_config ]; then
        ark_test_success "~/.ark_config: PRESENT"
        source ~/.ark_config
        echo "  Version: $ARK_VERSION"
        echo "  Commander: $ARK_COMMANDER_NAME"
    else
        ark_test_fail "~/.ark_config: MISSING"
    fi
    ark_test_success "Config diagnostics complete."
    ark_test_pause
}

# 10. Guided Battery Status Test
ark_test_battery() {
    ark_test_banner
    ark_test_section "BATTERY STATUS"
    if command -v upower &>/dev/null; then
        upower -i $(upower -e | grep BAT) | grep --color=never -E "state|to\ full|to\ empty|percentage|technology"
    elif [ -d /sys/class/power_supply ]; then
        grep . /sys/class/power_supply/BAT*/{status,capacity,manufacturer,model_name} 2>/dev/null
    else
        ark_test_warn "Battery status not available."
    fi
    ark_test_success "Battery diagnostics complete."
    ark_test_pause
}

# 11. Guided GPU Status Test
ark_test_gpu() {
    ark_test_banner
    ark_test_section "GPU STATUS"
    if command -v nvidia-smi &>/dev/null; then
        nvidia-smi
        ark_test_success "Nvidia GPU detected and operational."
    elif command -v glxinfo &>/dev/null; then
        glxinfo | grep "OpenGL renderer"
        ark_test_success "OpenGL GPU detected."
    else
        ark_test_warn "GPU info not available."
    fi
    ark_test_success "GPU diagnostics complete."
    ark_test_pause
}

# 12. Guided "Everything" Test
ark_test_all() {
    ark_test_banner
    ark_test_info "Running ALL diagnostics modules in sequence. Press [Enter] after each step to proceed."
    ark_test_pause
    ark_test_core_system
    ark_test_network
    ark_test_git_github
    ark_test_dev_tools
    ark_test_android_env
    ark_test_python
    ark_test_node
    ark_test_usb
    ark_test_config
    ark_test_battery
    ark_test_gpu
    ark_test_success "ALL TESTS COMPLETE, COMMANDER!"
    ark_test_pause
}

# ===========================
# ARK-TEST SUBMODULE SYSTEM
# ===========================
ark_test_run_submodules() {
    local moddir="${ARK_TEST_SUBMODULES:-$HOME/ark-test.d}"
    if [[ -d "$moddir" ]]; then
        for script in "$moddir"/*; do
            [[ -x "$script" ]] && "$script"
        done
    fi
}

# ===========================
# ARK-TEST MODULAR MENU
# ===========================
ark_test_menu() {
    while true; do
        ark_test_banner
        echo -e "${ARK_COLOR_CYAN}Select a diagnostics module, Commander:${ARK_COLOR_RESET}"
        echo -e "${ARK_COLOR_BLUE} 1) ${ARK_ICON_SYSTEM} Core System"
        echo -e " 2) ${ARK_ICON_NETWORK} Network & Internet"
        echo -e " 3) ${ARK_ICON_GIT} Git & GitHub"
        echo -e " 4) ${ARK_ICON_PACKAGE} Dev Tools"
        echo -e " 5) ${ARK_ICON_ANDROID} Android Build Env"
        echo -e " 6) ${ARK_ICON_PYTHON} Python Ecosystem"
        echo -e " 7) ${ARK_ICON_NODE} Node.js Ecosystem"
        echo -e " 8) ${ARK_ICON_USB} USB Devices"
        echo -e " 9) ${ARK_ICON_CONFIG} ARK Config"
        echo -e "10) ${ARK_ICON_BATTERY} Battery Status"
        echo -e "11) ${ARK_ICON_GPU} GPU Status"
        echo -e "12) ${ARK_ICON_SHIP} RUN ALL TESTS"
        # Dynamically list submodules
        local moddir="${ARK_TEST_SUBMODULES:-$HOME/ark-test.d}"
        local submod_count=0
        if [[ -d "$moddir" ]]; then
            local i=13
            for script in "$moddir"/*; do
                if [[ -x "$script" ]]; then
                    local name
                    name="$(basename "$script")"
                    echo -e "${ARK_COLOR_PURPLE}$i) ${ARK_ICON_SUBMODULE} Submodule: $name${ARK_COLOR_RESET}"
                    ((i++))
                    ((submod_count++))
                fi
            done
        fi
        echo -e "${ARK_COLOR_YELLOW} h) ${ARK_ICON_HELP} Help & Guidance${ARK_COLOR_RESET}"
        echo -e "${ARK_COLOR_RED} 0) ${ARK_ICON_EXIT} Return to Main Menu${ARK_COLOR_RESET}"
        echo -en "${ARK_COLOR_WHITE}${ARK_ICON_ARROW} Selection, Commander: ${ARK_COLOR_RESET}"
        read sel
        case "$sel" in
            1) ark_test_core_system ;;
            2) ark_test_network ;;
            3) ark_test_git_github ;;
            4) ark_test_dev_tools ;;
            5) ark_test_android_env ;;
            6) ark_test_python ;;
            7) ark_test_node ;;
            8) ark_test_usb ;;
            9) ark_test_config ;;
            10) ark_test_battery ;;
            11) ark_test_gpu ;;
            12) ark_test_all ;;
            h|H) ark_test_help ;;
            0) break ;;
            *)
                # Submodule detection (13+)
                if [[ "$sel" =~ ^[0-9]+$ ]] && [[ "$sel" -ge 13 && "$submod_count" -ge 1 ]]; then
                    local idx=13
                    for script in "$moddir"/*; do
                        if [[ -x "$script" ]]; then
                            if [[ "$sel" -eq "$idx" ]]; then
                                "$script"
                                break
                            fi
                            ((idx++))
                        fi
                    done
                else
                    ark_test_fail "Invalid selection, Commander."
                    sleep 1
                fi
            ;;
        esac
    done
}

# ===========================
# ARK-TEST HELP & GUIDANCE
# ===========================
ark_test_help() {
    ark_test_banner
    echo -e "${ARK_COLOR_CYAN}${ARK_ICON_HELP} ARK-TEST HELP & GUIDANCE${ARK_COLOR_RESET}"
    cat <<EOF

Welcome to the ARK-TEST diagnostics suite, Commander!
• Select any module for a guided, step-by-step system check.
• "RUN ALL TESTS" methodically checks the whole fleet.
• Submodules: Place any test script in ~/ark-test.d/ to extend the menu.
• After each step, press [Enter] to continue.

May The ARK be with you!

EOF
    ark_test_pause
}

# ===========================
# ARK-TEST MODULE ENTRYPOINT
# ===========================
# Commander: call ark_test_menu from the ARK main menu!
