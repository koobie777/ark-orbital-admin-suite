#!/usr/bin/env bash
# 🛰️ ARK ORBITAL COMMAND MAIN MENU – v5.4.0 (Fleet Renaissance Protocol, Advanced Debug, ARK SYSTEM PANEL v2, Compact & Comprehensive)

source "${ARK_CONFIG_PATH:-$HOME/.ark_config}"

: "${ARK_COLOR_BG:=\033[48;5;234m}"
: "${ARK_COLOR_TITLE:=\033[38;5;219m}"
: "${ARK_COLOR_CYAN:=\033[38;5;87m}"
: "${ARK_COLOR_PURPLE:=\033[38;5;219m}"
: "${ARK_COLOR_YELLOW:=\033[38;5;226m}"
: "${ARK_COLOR_GREEN:=\033[38;5;70m}"
: "${ARK_COLOR_RED:=\033[38;5;196m}"
: "${ARK_COLOR_BLUE:=\033[38;5;81m}"
: "${ARK_COLOR_WHITE:=\033[38;5;255m}"
: "${ARK_COLOR_MAGENTA:=\033[38;5;201m}"
: "${ARK_COLOR_GRAY:=\033[38;5;244m}"
: "${ARK_COLOR_RESET:=\033[0m}"
: "${ARK_COLOR_DIVIDER:=\033[38;5;123m}"

: "${ARK_ICON_PANEL:=🛰️}"
: "${ARK_ICON_USER:=👨‍🚀}"
: "${ARK_ICON_SYSTEM:=🛰️}"
: "${ARK_ICON_CLOCK:=🕰️}"
: "${ARK_ICON_HOST:=🖥️}"
: "${ARK_ICON_OS:=📦}"
: "${ARK_ICON_UPTIME:=⏱}"
: "${ARK_ICON_CPU:=🧠}"
: "${ARK_ICON_RAM:=🧬}"
: "${ARK_ICON_DISK:=💾}"
: "${ARK_ICON_NET:=🌐}"
: "${ARK_ICON_MAC:=🔑}"
: "${ARK_ICON_TEMP:=🌡️}"
: "${ARK_ICON_BAT:=🔋}"
: "${ARK_ICON_DIVIDER:=━}"
: "${ARK_ICON_INFO:=ℹ️}"
: "${ARK_ICON_GALAXY:=🪐}"

# --- ADVANCED SYSTEM PANEL (COMPACT/COMPREHENSIVE) ---
ark_menu_panel() {
    # Commander/System
    local commander="${ARK_COMMANDER_NAME:-Unknown}"
    local system="${ARK_SYSTEM_NAME:-Unknown}"

    # Time
    local datetime="$(date '+%Y-%m-%d %H:%M:%S')"

    # Hostname/OS/Uptime (fallbacks)
    local hostname_str="N/A"
    if command -v hostname &>/dev/null; then
        hostname_str="$(hostname)"
    fi
    local os_str="$(uname -o 2>/dev/null || uname -s)"
    local uptime_str="$(uptime -p 2>/dev/null | sed 's/up //')"

    # CPU Info (fallback to unknown)
    local cpu_str="$(awk -F: '/model name/ {print $2; exit}' /proc/cpuinfo | xargs)"
    [ -z "$cpu_str" ] && cpu_str="Unknown CPU"

    # RAM Info
    local ram_total="$(awk '/MemTotal/ {printf "%.1f", $2/1024/1024}' /proc/meminfo 2>/dev/null)"
    local ram_used="$(free -m | awk '/Mem:/ {printf "%.1f", $3/1024}')"
    local ram_str="${ram_used}Gi/${ram_total}Gi"

    # Disk Info (root only, GB)
    local disk_used="N/A"
    local disk_total="N/A"
    if df -BG / &>/dev/null; then
        disk_used="$(df -BG / | awk 'NR==2 {gsub("G","",$3); print $3 "G"}')"
        disk_total="$(df -BG / | awk 'NR==2 {gsub("G","",$2); print $2 "G"}')"
    fi
    local disk_str="${disk_used}/${disk_total}"

    # IP Address (first non-loopback)
    local ip_str="N/A"
    if command -v hostname &>/dev/null; then
        ip_str="$(hostname -I 2>/dev/null | awk '{for(i=1;i<=NF;i++) if ($i !~ /^127/) {print $i; break}}')"
        [ -z "$ip_str" ] && ip_str="N/A"
    fi

    # MAC Address (first interface)
    local mac_str="N/A"
    if command -v ip &>/dev/null; then
        mac_str="$(ip link | awk '/ether/ {print $2; exit}')"
    elif command -v ifconfig &>/dev/null; then
        mac_str="$(ifconfig | awk '/ether/ {print $2; exit}')"
    fi

    # Battery Info (if present)
    local bat_str=""
    if [ -d /sys/class/power_supply/BAT0 ]; then
        local bat_now="$(cat /sys/class/power_supply/BAT0/energy_now 2>/dev/null)"
        local bat_full="$(cat /sys/class/power_supply/BAT0/energy_full 2>/dev/null)"
        if [[ "$bat_now" =~ ^[0-9]+$ ]] && [[ "$bat_full" =~ ^[0-9]+$ ]]; then
            local bat_pct=$((100 * bat_now / bat_full))
            bat_str="${ARK_ICON_BAT} Battery: ${bat_pct}%"
        fi
    fi

    # CPU Temp (if present)
    local temp_str=""
    if [ -f /sys/class/thermal/thermal_zone0/temp ]; then
        local temp_raw="$(cat /sys/class/thermal/thermal_zone0/temp)"
        if [[ "$temp_raw" =~ ^[0-9]+$ ]]; then
            local temp_c="$(awk "BEGIN {print $temp_raw/1000}")"
            temp_str="${ARK_ICON_TEMP} Temp: ${temp_c}°C"
        fi
    fi

    # Panel Output (compact)
    echo -e "${ARK_COLOR_CYAN}${ARK_ICON_PANEL} ARK SYSTEM PANEL${ARK_COLOR_GRAY} v5.4.0${ARK_COLOR_RESET}"
    echo -e "${ARK_COLOR_DIVIDER}${ARK_ICON_DIVIDER}────────────────────────────────────────────${ARK_COLOR_RESET}"
    echo -e "${ARK_COLOR_YELLOW}${ARK_ICON_USER} Commander: ${commander} ${ARK_COLOR_WHITE}| ${ARK_ICON_SYSTEM} System: ${system}${ARK_COLOR_RESET}"
    echo -e "${ARK_COLOR_GREEN}${ARK_ICON_CLOCK} ${datetime} ${ARK_COLOR_WHITE}| ${ARK_ICON_HOST} ${hostname_str}${ARK_COLOR_RESET}"
    echo -e "${ARK_COLOR_MAGENTA}${ARK_ICON_OS} ${os_str} ${ARK_COLOR_WHITE}| ${ARK_ICON_UPTIME} ${uptime_str}${ARK_COLOR_RESET}"
    echo -e "${ARK_COLOR_BLUE}${ARK_ICON_CPU} ${cpu_str}${ARK_COLOR_WHITE} | ${ARK_ICON_RAM} ${ram_str}${ARK_COLOR_WHITE} | ${ARK_ICON_DISK} ${disk_str}${ARK_COLOR_RESET}"
    echo -e "${ARK_COLOR_WHITE}${ARK_ICON_NET} IP: ${ip_str} ${ARK_COLOR_WHITE}| ${ARK_ICON_MAC} MAC: ${mac_str}${ARK_COLOR_RESET}"
    if [ -n "$bat_str" ] || [ -n "$temp_str" ]; then
        echo -e "${ARK_COLOR_YELLOW}${bat_str} ${ARK_COLOR_RED}${temp_str}${ARK_COLOR_RESET}"
    fi
    echo -e "${ARK_COLOR_DIVIDER}${ARK_ICON_DIVIDER}────────────────────────────────────────────${ARK_COLOR_RESET}"
}

# --- ADVANCED AUTO-SOURCE ALL MENU SUBMODULES (debug, path-aware) ---
ARK_DOCK_PATH="${ARK_DOCK_PATH/#\~/$HOME}"
ARK_MENU_SUBSYSTEMS="${ARK_DOCK_PATH}/ark-menu/ark-menu-systems-bay"
for submod in "$ARK_MENU_SUBSYSTEMS"/*.sh; do
    echo "[ARK-MENU DEBUG] Sourcing $submod"
    [[ -r "$submod" ]] && source "$submod"
done

ark_error() {
    local type="$1"
    local location="$2"
    local fix="$3"
    echo -e "${ARK_COLOR_FAIL}⚠️ [${type} ERROR]\nLocation: ${location}\nFix: ${fix}\n\"I'll guide you, Commander.\"${ARK_COLOR_RESET}"
    read -rp "Press [Enter] to return to the menu..."
}

ark_run_with_error_report() {
    local cmd="$1"
    local label="$2"
    if ! type "$cmd" &>/dev/null; then
        ark_error "MODULE MISSING" "$label" "Install or update ARK module for $label."
        return 1
    fi
    eval "$cmd"
    local status=$?
    if [[ $status -ne 0 ]]; then
        ark_error "COMMAND" "$label" "Check logs or previous output for diagnostics."
    fi
}

ark_toggle_reveal_mode() {
    local config="$HOME/.ark_config"
    if ! grep -q '^ARK_REVEAL=' "$config" 2>/dev/null; then
        echo "ARK_REVEAL=0" >> "$config"
    fi
    . "$config"
    if [[ "$ARK_REVEAL" == "1" ]]; then
        sed -i 's/^ARK_REVEAL=.*/ARK_REVEAL=0/' "$config"
    else
        sed -i 's/^ARK_REVEAL=.*/ARK_REVEAL=1/' "$config"
    fi
    . "$config"
    export ARK_REVEAL
}

ark_help_center() {
    clear
    echo -e "${ARK_COLOR_TITLE}${ARK_ICON_HELP} ARK ORBITAL HELP CENTER${ARK_COLOR_RESET}"
    echo -e "${ARK_COLOR_DIVIDER}${ARK_ICON_DIVIDER}──────────────────────────────────────────────────────────${ARK_COLOR_RESET}"
    echo -e "${ARK_COLOR_CYAN}${ARK_ICON_INFO}  Welcome to The ARK Ecosystem – Modular, privacy-first, tmux-powered Android build fleet."
    echo -e "${ARK_COLOR_YELLOW}  Toggle privacy/reveal mode anytime with [t]."
    echo -e "${ARK_COLOR_GREEN}  Input menu number and press [Enter] to navigate."
    echo -e "${ARK_COLOR_WHITE}  Modules return here after completion. Errors are ARK-themed and never exit tmux."
    echo -e "${ARK_COLOR_MAGENTA}  Submodules are modular and easily updated."
    echo -e "${ARK_COLOR_BLUE}  For Android ROM builds, see ARK-Ecosystem README."
    echo -e "${ARK_COLOR_DIVIDER}${ARK_ICON_DIVIDER}──────────────────────────────────────────────────────────${ARK_COLOR_RESET}"
    echo -e "${ARK_COLOR_YELLOW}  May The ARK be with you!${ARK_COLOR_RESET}"
    read -rp "Press [Enter] to return to the main menu..."
}

ark_main_menu() {
    while true; do
        clear
        # --- Top Info Panel ---
        ark_menu_panel

        echo -e "${ARK_COLOR_TITLE}${ARK_ICON_GALAXY} WELCOME TO THE ARK ORBITAL COMMAND CENTER ${ARK_ICON_GALAXY} (Menu v5.4.0)${ARK_COLOR_RESET}"
        echo -e "${ARK_COLOR_DIVIDER}${ARK_ICON_DIVIDER}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${ARK_COLOR_RESET}"

        echo -e "${ARK_COLOR_DIVIDER}${ARK_ICON_DIVIDER}━━━━━━━━━━━━━━━━━━━ ${ARK_COLOR_CYAN}FLEET OPERATIONS${ARK_COLOR_DIVIDER} ━━━━━━━━━━━━━━━━━━${ARK_COLOR_RESET}"
        echo -e "${ARK_COLOR_GREEN} 1) ${ARK_ICON_WRENCH} Install ARK Essentials${ARK_COLOR_RESET}      ${ARK_COLOR_CYAN} 2) ${ARK_ICON_LIGHTNING} Optimize System${ARK_COLOR_RESET}"
        echo -e "${ARK_COLOR_BLUE} 3) ${ARK_ICON_KEY} ARK SSH Manager${ARK_COLOR_RESET}                ${ARK_COLOR_CYAN} 4) ${ARK_ICON_STATS} Fleet Status${ARK_COLOR_RESET}"
        echo -e "${ARK_COLOR_MAGENTA} 5) ${ARK_ICON_CONFIG} Config Manager${ARK_COLOR_RESET}"

        echo -e "${ARK_COLOR_DIVIDER}${ARK_ICON_DIVIDER}━━━━━━━━━━━━━━━━━━━ ${ARK_COLOR_YELLOW}SYSTEM MAINTENANCE${ARK_COLOR_DIVIDER} ━━━━━━━━━━━━━━━━━${ARK_COLOR_RESET}"
        echo -e "${ARK_COLOR_YELLOW} 6) ${ARK_ICON_UPDATE} System Update${ARK_COLOR_RESET}                ${ARK_COLOR_GREEN} 7) ${ARK_ICON_TEST} Diagnostics & Test Suite${ARK_COLOR_RESET}"

        echo -e "${ARK_COLOR_DIVIDER}${ARK_ICON_DIVIDER}━━━━━━━━━━━━━━━━━━━ ${ARK_COLOR_PURPLE}ADVANCED MODULES${ARK_COLOR_DIVIDER} ━━━━━━━━━━━━━━━━━━${ARK_COLOR_RESET}"
        echo -e "${ARK_COLOR_GREEN} 8) ${ARK_ICON_FORGE} Launch ARK-FORGE${ARK_COLOR_YELLOW} (Under Construction)${ARK_COLOR_RESET}"
        echo -e "${ARK_COLOR_BLUE} 9) ${ARK_ICON_SYSTEM} System Info Dashboard${ARK_COLOR_RESET}"
        echo -e "${ARK_COLOR_PURPLE}10) ${ARK_ICON_PAINT} ARK Themes${ARK_COLOR_YELLOW} (Coming Soon)${ARK_COLOR_RESET}"
        echo -e "${ARK_COLOR_CYAN}11) ${ARK_ICON_REBOOT} ARK Reboot (UI/Device/Fleet/Diagnostics/Logs)${ARK_COLOR_YELLOW} (Modular)${ARK_COLOR_RESET}"

        echo -e "${ARK_COLOR_DIVIDER}${ARK_ICON_DIVIDER}━━━━━━━━━━━━━━━━━━━ ${ARK_COLOR_BLUE}ARK ECOSYSTEM${ARK_COLOR_DIVIDER} ━━━━━━━━━━━━━━━━━━━━${ARK_COLOR_RESET}"
        echo -e "${ARK_COLOR_YELLOW}12) ${ARK_ICON_MODULE} ARK Module Manager${ARK_COLOR_YELLOW} (Coming Soon)${ARK_COLOR_RESET}"
        echo -e "${ARK_COLOR_BLUE}13) ${ARK_ICON_LOGS} View ARK Logs${ARK_COLOR_YELLOW} (Coming Soon)${ARK_COLOR_RESET}"
        echo -e "${ARK_COLOR_MAGENTA}14) ${ARK_ICON_HELP} Help Center${ARK_COLOR_YELLOW} (Interactive Guide)${ARK_COLOR_RESET}"

        echo -e "${ARK_COLOR_RED} 0) ${ARK_ICON_EXIT} Exit${ARK_COLOR_RESET}"
        echo -e "${ARK_COLOR_DIVIDER}${ARK_ICON_DIVIDER}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${ARK_COLOR_RESET}"
        echo -e "${ARK_COLOR_WHITE}Press [t] to toggle privacy mode, or select a menu option. [${ARK_ICON_ARROW}]${ARK_COLOR_RESET}"
        read -rp "Enter selection, Commander: " sel
        case "$sel" in
            t|T) ark_toggle_reveal_mode; continue ;;
            1) ark_run_with_error_report "ark_essentials_install" "ark-essentials" ;;
            2) ark_run_with_error_report "ark_optimize_menu" "ark-optimize" ;;
            3) ark_run_with_error_report "ark_ssh_manager_menu" "ark-ssh-manager" ;;
            4) ark_run_with_error_report "ark_fleet_status" "ark-fleet" ;;
            5) ark_run_with_error_report "ark_config_manager" "ark-config" ;;
            6) ark_run_with_error_report "ark_update_menu" "ark-update" ;;
            7) ark_run_with_error_report "ark_test_menu" "ark-test" ;;
            8) echo -e "${ARK_COLOR_YELLOW}ARK-FORGE is under construction.${ARK_COLOR_RESET}"; read -rp "Press [Enter] to return to menu...";;
            9) ark_run_with_error_report "ark_system_info_menu" "ark-system-info" ;;
            10) echo -e "${ARK_COLOR_YELLOW}ARK Themes module coming soon.${ARK_COLOR_RESET}"; read -rp "Press [Enter] to return to menu...";;
            11) ark_run_with_error_report "ark_reboot_menu" "ark-reboot" ;;
            12) echo -e "${ARK_COLOR_YELLOW}ARK Module Manager coming soon.${ARK_COLOR_RESET}"; read -rp "Press [Enter] to return to menu...";;
            13) echo -e "${ARK_COLOR_YELLOW}ARK Logs feature coming soon.${ARK_COLOR_RESET}"; read -rp "Press [Enter] to return to menu...";;
            14) ark_help_center ;;
            0) echo -e "${ARK_COLOR_MAGENTA}${ARK_ICON_MOON} May The ARK be with you, Commander!${ARK_COLOR_RESET}"; break ;;
            *) echo -e "${ARK_COLOR_RED}Invalid selection, Commander.${ARK_COLOR_RESET}"; sleep 1 ;;
        esac
    done
}

# Entry point if called directly (optional)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    ark_main_menu
fi
