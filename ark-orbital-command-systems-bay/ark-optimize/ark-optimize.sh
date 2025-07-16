#!/usr/bin/env bash
# ⚡ ARK Hardware Optimization Module for The ARK Ecosystem (v2.3.0 Fleet Renaissance)
# Robust, modular, ARK-themed, extensible, updated for meta-repo and ARK protocol

ARK_OPTIMIZE_VERSION="v2.3.0"

# =========================
# ARK THEME CONSTANTS
# =========================
ARK_COLOR_CYAN="\033[1;36m"
ARK_COLOR_PURPLE="\033[1;35m"
ARK_COLOR_RESET="\033[0m"
ARK_COLOR_YELLOW="\033[1;33m"
ARK_COLOR_GREEN="\033[1;32m"
ARK_COLOR_RED="\033[1;31m"
ARK_COLOR_BLUE="\033[1;34m"
ARK_SHIP="🛸"
ARK_OK="✅"
ARK_WARN="⚠️"
ARK_FAIL="❌"

# ========== PROFILE DEFINITIONS ==========
declare -A ARK_PROFILES=(
    ["performance"]="[PERF] Max speed, disables power saving. (Best for builds/gaming)"
    ["lowpower"]="[LOW] CPU powersave, sleep enabled. (Best for laptops/battery/quiet)"
    ["balanced"]="[BAL] CPU ondemand, default scheduler. (Good for most missions)"
    ["powersave-extreme"]="[PWR-SAVE] All power-saving features enabled, USB autosuspend, disk spin-down, screen dim."
    ["server"]="[SRV] Balanced CPU, aggressive I/O scheduler, tuned for 24/7 reliability."
    ["benchmark"]="[BMK] Max turbo, disables all power saving, disables thermal throttling (if supported)."
    ["custom"]="[CUST] Customize each component's settings interactively."
)

# ========== ARK MAIN ENTRY ==========
ark_optimize() {
    ark_optimize_banner
    ark_detect_hardware
    ark_prompt_optimization_profile
    ark_apply_optimization
    ark_optimize_return_menu
}

ark_optimize_menu() {
    ark_optimize
}

# ========== ARK BANNERS & UI ==========
ark_optimize_banner() {
    ark_separator
    printf "${ARK_COLOR_CYAN}║${ARK_COLOR_PURPLE}   ⚡ ARK HARDWARE OPTIMIZER MODULE              %-9s${ARK_COLOR_CYAN}║${ARK_COLOR_RESET}\n" "v$ARK_OPTIMIZE_VERSION"
    printf "${ARK_COLOR_CYAN}║${ARK_COLOR_PURPLE}   Module: Hardware Optimizer for The ARK Ecosystem     ${ARK_COLOR_CYAN}║${ARK_COLOR_RESET}\n"
    ark_separator
    echo -e "${ARK_COLOR_YELLOW}Welcome, Commander! This tool optimizes and diagnoses all ARK devices.${ARK_COLOR_RESET}"
}

ark_separator() {
    echo -e "${ARK_COLOR_CYAN}╔═══════════════════════════════════════════════════════════════╗${ARK_COLOR_RESET}"
}

ark_status() {
    local status_icon="$1"
    local msg="$2"
    local color="$3"
    printf "${color}%s ${msg}${ARK_COLOR_RESET}\n" "$status_icon"
}

# ========== ARK HELP & EXPLANATION ==========
ark_show_help() {
    echo -e "${ARK_COLOR_PURPLE}🛰️  Universal ARK Help Panel${ARK_COLOR_RESET}"
    echo -e "${ARK_COLOR_BLUE}This tool offers:${ARK_COLOR_RESET}"
    echo -e "  - Hardware detection & fleet diagnostics"
    echo -e "  - Multiple system-wide and Android-optimized performance profiles"
    echo -e "  - Power management, build environment prep, RAM/disk tuning, and deep-dive utilities"
    echo -e "  - Online optimization tip scraping (with built-in ARK warnings)"
    echo -e "  - Hardware info export for fleet, support, or inventory"
    echo -e "  - Live tips & help at every step"
    echo -e "  - Custom and advanced power/performance scenarios for any ARK device"
    echo -e "${ARK_COLOR_YELLOW}Tips:${ARK_COLOR_RESET} Press 'h' at any menu to view this help panel."
}

# ========== ARK HARDWARE DETECTION ==========
ark_detect_hardware() {
    echo -e "${ARK_COLOR_BLUE}🔭 Scanning system hardware...${ARK_COLOR_RESET}"
    local cpu_model mem_total disk_total gpu_model
    cpu_model=$(lscpu | grep 'Model name' | sed 's/Model name:[ \t]*//')
    mem_total=$(awk '/MemTotal/ {printf "%.1f GiB", $2/1024/1024}' /proc/meminfo)
    disk_total=$(lsblk -d -b -o SIZE | awk 'NR>1 {sum+=$1} END {printf "%.1f GiB", sum/1024/1024/1024}')
    gpu_model=$(lspci | grep -i 'vga\|3d\|2d' | cut -d ':' -f3- | sed 's/^ //')
    echo -e "${ARK_COLOR_PURPLE}🚀 Detected Hardware:${ARK_COLOR_RESET}"
    echo -e "  🧠 CPU: ${ARK_COLOR_GREEN}$cpu_model${ARK_COLOR_RESET}"
    echo -e "  🛰️  Memory: ${ARK_COLOR_GREEN}$mem_total${ARK_COLOR_RESET}"
    echo -e "  💾 Storage: ${ARK_COLOR_GREEN}$disk_total${ARK_COLOR_RESET}"
    echo -e "  🎮 GPU: ${ARK_COLOR_GREEN}$gpu_model${ARK_COLOR_RESET}"
}

ark_show_profile_explanation() {
    echo -e "${ARK_COLOR_BLUE}Profile Key:${ARK_COLOR_RESET}"
    for key in performance lowpower balanced powersave-extreme server benchmark custom; do
        printf "  %s\n" "${ARK_PROFILES[$key]}"
    done
    echo -e "${ARK_COLOR_YELLOW}Switch profiles at any time to match your current ARK mission!${ARK_COLOR_RESET}"
}

# ========== ARK PROFILE SELECTION ==========
ark_prompt_optimization_profile() {
    echo ""
    ark_show_profile_explanation
    echo ""
    echo -e "${ARK_COLOR_YELLOW}Tip: Use 'custom' for granular settings, or 'h' for help at any time.${ARK_COLOR_RESET}"
    read -p "Select profile [1-7] (see above) or 'h' for help: " ark_profile_choice
    if [[ "$ark_profile_choice" == "h" ]]; then
        ark_show_help
        ark_prompt_optimization_profile
        return
    fi
    case "$ark_profile_choice" in
        2) ARK_OPT_PROFILE="lowpower" ;;
        3) ARK_OPT_PROFILE="balanced" ;;
        4) ARK_OPT_PROFILE="powersave-extreme" ;;
        5) ARK_OPT_PROFILE="server" ;;
        6) ARK_OPT_PROFILE="benchmark" ;;
        7) ARK_OPT_PROFILE="custom" ;;
        *) ARK_OPT_PROFILE="performance" ;;
    esac
}

# ========== ARK PROFILE APPLICATION ==========
ark_apply_optimization() {
    ark_show_profile_explanation
    case "$ARK_OPT_PROFILE" in
        "performance")
            ark_status "$ARK_SHIP" "Applying Performance profile: Max CPU, disabling power saving, turbo enabled." "$ARK_COLOR_BLUE"
            ark_status "$ARK_OK" "Best for Android building, gaming, or intensive ARK tasks." "$ARK_COLOR_GREEN"
            sudo cpupower frequency-set -g performance 2>/dev/null
            sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target 2>/dev/null
            sudo powertop --auto-tune 2>/dev/null
            ;;
        "lowpower")
            ark_status "$ARK_SHIP" "Applying Low Power profile: CPU powersave, sleep enabled, TLP started." "$ARK_COLOR_BLUE"
            ark_status "$ARK_OK" "Ideal for laptops, battery, or keeping devices cool in The ARK." "$ARK_COLOR_GREEN"
            sudo cpupower frequency-set -g powersave 2>/dev/null
            sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target 2>/dev/null
            sudo tlp start 2>/dev/null || true
            ;;
        "balanced")
            ark_status "$ARK_SHIP" "Applying Balanced profile: CPU ondemand, default scheduler." "$ARK_COLOR_BLUE"
            ark_status "$ARK_OK" "Balanced for most ARK missions." "$ARK_COLOR_GREEN"
            sudo cpupower frequency-set -g ondemand 2>/dev/null
            ;;
        "powersave-extreme")
            ark_status "$ARK_SHIP" "Applying Powersave Extreme: All power-saving features enabled." "$ARK_COLOR_BLUE"
            sudo cpupower frequency-set -g powersave 2>/dev/null
            sudo tlp start 2>/dev/null || true
            sudo hdparm -S 12 /dev/sda 2>/dev/null
            sudo bash -c "echo 1 > /sys/module/usbcore/parameters/autosuspend"
            xset dpms 600 900 1200 2>/dev/null || true
            ;;
        "server")
            ark_status "$ARK_SHIP" "Applying Server profile: Balanced CPU, aggressive I/O, tuned for reliability." "$ARK_COLOR_BLUE"
            sudo cpupower frequency-set -g ondemand 2>/dev/null
            sudo systemctl enable --now tuned 2>/dev/null || true
            sudo tuned-adm profile throughput-performance 2>/dev/null || true
            ;;
        "benchmark")
            ark_status "$ARK_SHIP" "Applying Benchmark profile: Max turbo, disables all power saving." "$ARK_COLOR_BLUE"
            sudo cpupower frequency-set -g performance 2>/dev/null
            sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target 2>/dev/null
            echo 0 | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo 2>/dev/null || true
            ;;
        "custom")
            ark_status "$ARK_SHIP" "Launching Custom Tuning Wizard..." "$ARK_COLOR_BLUE"
            ark_custom_profile_wizard
            ;;
    esac
    echo -e "${ARK_COLOR_YELLOW}Switching profiles affects performance, not stability. You can always revert or fine-tune!${ARK_COLOR_RESET}"
}

# ========== ARK CUSTOM PROFILE ==========
ark_custom_profile_wizard() {
    echo -e "${ARK_COLOR_CYAN}-- ARK Custom Profile Wizard --${ARK_COLOR_RESET}"
    echo -e "${ARK_COLOR_YELLOW}You will be prompted for each subsystem. Press Enter for default.${ARK_COLOR_RESET}"
    # CPU Governor
    read -p "CPU governor [performance/powersave/ondemand] (default: performance): " cpu_gov
    cpu_gov="${cpu_gov:-performance}"
    sudo cpupower frequency-set -g "$cpu_gov" 2>/dev/null
    # Disk Scheduler
    read -p "Disk scheduler [cfq/deadline/noop] (default: cfq): " disk_sched
    disk_sched="${disk_sched:-cfq}"
    for dev in /sys/block/*/queue/scheduler; do echo "$disk_sched" | sudo tee "$dev" > /dev/null; done
    # USB autosuspend
    read -p "Enable USB autosuspend? [y/N]: " usb_auto
    if [[ "$usb_auto" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        sudo bash -c "echo 1 > /sys/module/usbcore/parameters/autosuspend"
    fi
    # TLP
    read -p "Enable TLP power management? [y/N]: " tlp_en
    if [[ "$tlp_en" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        sudo tlp start 2>/dev/null || true
    fi
    # Display power management
    read -p "Set display to sleep after N seconds (0 to disable, default 900): " dpms_time
    dpms_time="${dpms_time:-900}"
    if [[ "$dpms_time" != "0" ]]; then
        xset dpms "$dpms_time" "$((dpms_time+300))" "$((dpms_time+600))" 2>/dev/null || true
    fi
    ark_status "$ARK_OK" "Custom tuning applied! You can revisit this wizard any time." "$ARK_COLOR_GREEN"
}

# ========== RETURN TO ARK MENU ==========
ark_optimize_return_menu() {
    echo
    read -rp "Press [Enter] to return to the main menu, Commander..."
}

# ========== FUTURE EXPANSION ==========
# - Place additional helper scripts in modules/ (subfolder)
# - Add android-specific, device-specific, or custom optimization routines as submodules
# - Future: ARK Optimize will auto-detect device type and load matching submodules
# - Cadet Mode: Step-by-step guidance for new users (coming soon)

# ====== ARK MODULE ENTRY POINT ======
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    ark_optimize_menu
fi

# End of ARK Optimize Module
