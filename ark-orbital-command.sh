#!/usr/bin/env bash

# 🛰️ ADMIRAL A.R.K. – ARK ORBITAL COMMAND CENTRAL HUB (v42.1.0 - Panel Fix, Protocol Renaissance+, Advanced Diagnostics, Enhanced Preboot)

: "${ARK_COLOR_BG:=\033[48;5;234m}"
: "${ARK_COLOR_PANEL:=\033[38;5;81m}"
: "${ARK_COLOR_TITLE:=\033[38;5;219m}"
: "${ARK_COLOR_OK:=\033[38;5;70m}"
: "${ARK_COLOR_WARN:=\033[38;5;226m}"
: "${ARK_COLOR_FAIL:=\033[38;5;196m}"
: "${ARK_COLOR_SECTION:=\033[38;5;123m}"
: "${ARK_COLOR_DETAIL:=\033[38;5;250m}"
: "${ARK_COLOR_RESET:=\033[0m}"
: "${ARK_ICON_BOOT:=🛰️}"
: "${ARK_ICON_OK:=✅}"
: "${ARK_ICON_FAIL:=❌}"
: "${ARK_ICON_WARN:=⚠️}"
: "${ARK_ICON_MENU:=📋}"
: "${ARK_ICON_SPARK:=✨}"
: "${ARK_ICON_ARROW:=➤}"
: "${ARK_ICON_DIVIDER:=━}"
: "${ARK_ICON_STAR:=🌟}"
: "${ARK_ICON_GEAR:=⚙️}"
: "${ARK_ICON_BUG:=🐞}"
: "${ARK_ICON_MAGNIFY:=🔍}"
: "${ARK_ICON_DOC:=📄}"
: "${ARK_ICON_FOLDER:=📁}"
: "${ARK_ICON_SYSTEM:=🛰️}"
: "${ARK_ICON_DIAG:=🧪}"
: "${ARK_ICON_INFO:=ℹ️}"
: "${ARK_ORBITAL_VERSION:=v42.1.0}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export SCRIPT_DIR
export ARK_DOCK_PATH="$SCRIPT_DIR/ark-orbital-command-systems-bay"
export ARK_CONFIG_PATH="$HOME/.ark_config"
PREBOOT_LOG="/tmp/ark-orbital-preboot.log"
: > "$PREBOOT_LOG"

echo -e "${ARK_COLOR_PANEL}${ARK_ICON_BOOT} ARK-Orbital-Command v${ARK_ORBITAL_VERSION} is THE CENTRAL HUB of The ARK Ecosystem."
echo -e "${ARK_COLOR_INFO}All modules, diagnostics, and launches are managed here. Every tool presents a detailed report before returning.${ARK_COLOR_RESET}"

create_default_ark_config() {
    if command -v hostname &>/dev/null; then
        ARK_SYSTEM_NAME="$(hostname)"
    else
        ARK_SYSTEM_NAME="UNKNOWN"
    fi
    if [[ ! -f "$ARK_CONFIG_PATH" ]]; then
        cat > "$ARK_CONFIG_PATH" << ARKEOF
# ARK Ecosystem Config – DO NOT COMMIT WITH REAL SECRETS
ARK_GREETING_ENABLED=true
ARK_GREETING_STYLE="full"
ARK_COMMANDER_NAME="Commander"
ARK_SYSTEM_NAME="${ARK_SYSTEM_NAME}"
ARK_CUSTOM_MESSAGE="The ARK is ready, Commander!"
ARK_VERSION="${ARK_ORBITAL_VERSION}"
ARK_SSH_AUTO_SETUP=true
ARK_SSH_PASSWORDLESS=true
ARK_DEV_MODE=true
ARK_AUTO_UPDATE=false
ARK_GITHUB_EMAIL="your@email.com"
ARK_GITHUB_USER="yourgithubuser"
ARK_LOCAL_SSH_COMMENT="local@theark"
ARK_LOCAL_SSH_KEY="\$HOME/.ssh/id_ed25519_local"
ARK_REMOTE_USER="commander"
ARK_REMOTE_HOST="ark-remote-host"
ARK_REVEAL=0
ARKEOF
        echo "[OK] Default ark-config created at $ARK_CONFIG_PATH" >>"$PREBOOT_LOG"
    else
        for key in \
            ARK_GREETING_ENABLED ARK_GREETING_STYLE ARK_COMMANDER_NAME ARK_SYSTEM_NAME \
            ARK_CUSTOM_MESSAGE ARK_VERSION ARK_SSH_AUTO_SETUP ARK_SSH_PASSWORDLESS \
            ARK_DEV_MODE ARK_AUTO_UPDATE ARK_GITHUB_EMAIL ARK_GITHUB_USER \
            ARK_LOCAL_SSH_COMMENT ARK_LOCAL_SSH_KEY ARK_REMOTE_USER ARK_REMOTE_HOST ARK_REVEAL; do
            grep -q "^$key=" "$ARK_CONFIG_PATH" || echo "$key=" >>"$ARK_CONFIG_PATH"
        done
        echo "[CONFIG] Existing ark-config found at $ARK_CONFIG_PATH" >>"$PREBOOT_LOG"
    fi
}

create_default_ark_config

log_module_status() {
    local module="$1"
    local status="$2"
    local msg="$3"
    if [[ "$status" == "OK" ]]; then
        echo "[OK] $module" >>"$PREBOOT_LOG"
    else
        echo "[FAIL] $module: $msg" >>"$PREBOOT_LOG"
    fi
}

ark_diagnostic_protocol() {
    clear
    echo -e "${ARK_COLOR_TITLE}${ARK_ICON_DIAG} ADVANCED ARK DIAGNOSTIC (v3.0)${ARK_COLOR_RESET}"
    echo -e "${ARK_COLOR_SECTION}${ARK_ICON_DIVIDER}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${ARK_COLOR_RESET}"

    # Check for ARK_DOCK_PATH and SCRIPT_DIR definitions
    echo -e "${ARK_COLOR_MAGNIFY} Checking ARK_DOCK_PATH/SCRIPT_DIR definitions..."
    grep -nE 'ARK_DOCK_PATH|SCRIPT_DIR' "$ARK_DOCK_PATH"/*/*.sh | grep -v 'ark-orbital-command.sh' \
        && echo -e "${ARK_COLOR_WARN}${ARK_ICON_WARN} Found stray definitions above! Only set in ark-orbital-command.sh.${ARK_COLOR_RESET}" \
        || echo -e "${ARK_COLOR_OK}${ARK_ICON_OK} No unauthorized ARK_DOCK_PATH or SCRIPT_DIR definitions found.${ARK_COLOR_RESET}"

    # List menu subsystems
    echo -e "\n${ARK_COLOR_MAGNIFY} Listing menu subsystems in $ARK_DOCK_PATH/ark-menu/ark-menu-systems-bay:"
    ls -lh "$ARK_DOCK_PATH/ark-menu/ark-menu-systems-bay"

    # Check scripts for readability and size
    echo -e "\n${ARK_COLOR_MAGNIFY} Checking scripts for readability/size:"
    for mod in "$ARK_DOCK_PATH"/*/*.sh "$ARK_DOCK_PATH"/ark-menu/ark-menu-systems-bay/*.sh; do
        if [[ ! -r "$mod" ]]; then
            echo -e "${ARK_COLOR_FAIL}${ARK_ICON_FAIL} NOT READABLE: $mod${ARK_COLOR_RESET}"
        elif [[ ! -s "$mod" ]]; then
            echo -e "${ARK_COLOR_WARN}${ARK_ICON_WARN} EMPTY FILE: $mod${ARK_COLOR_RESET}"
        else
            echo -e "${ARK_COLOR_OK}${ARK_ICON_OK} OK: $(basename "$mod")${ARK_COLOR_RESET}"
        fi
    done

    # Syntax check for all docked modules
    echo -e "\n${ARK_COLOR_MAGNIFY} Syntax check for all docked modules:"
    errors=0
    for mod in "$ARK_DOCK_PATH"/*/*.sh "$ARK_DOCK_PATH"/ark-menu/ark-menu-systems-bay/*.sh; do
        if ! bash -n "$mod" 2>/dev/null; then
            echo -e "${ARK_COLOR_FAIL}${ARK_ICON_FAIL} SYNTAX ERROR: $mod${ARK_COLOR_RESET}"
            errors=1
        fi
    done
    if [[ $errors -eq 0 ]]; then
        echo -e "${ARK_COLOR_OK}${ARK_ICON_OK} No syntax errors found in docked modules.${ARK_COLOR_RESET}"
    fi

    # Live sourcing emulation for ALL menu subsystems
    echo -e "\n${ARK_COLOR_MAGNIFY} Live sourcing emulation for ALL menu subsystems:"
    for submod in "$ARK_DOCK_PATH"/ark-menu/ark-menu-systems-bay/*.sh; do
        echo -e "${ARK_COLOR_CYAN}Sourcing: $submod${ARK_COLOR_RESET}"
        source "$submod"
    done
    type ark_menu_panel &>/dev/null \
        && echo -e "${ARK_COLOR_OK}${ARK_ICON_OK} ark_menu_panel is available after emulation.${ARK_COLOR_RESET}" \
        || echo -e "${ARK_COLOR_FAIL}${ARK_ICON_FAIL} ark_menu_panel still NOT loaded after emulation!${ARK_COLOR_RESET}"

    echo -e "\n${ARK_COLOR_SECTION}${ARK_ICON_DIVIDER}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${ARK_COLOR_RESET}"
    echo -e "${ARK_COLOR_INFO}May The ARK be with you, Commander!${ARK_COLOR_RESET}"
    read -rp "Press [Enter] to return to main menu..."
}

# Collect verbose diagnostics
echo "[INFO] ARK_DOCK_PATH: $ARK_DOCK_PATH" >>"$PREBOOT_LOG"
ls -lh "$ARK_DOCK_PATH" >>"$PREBOOT_LOG" 2>&1
echo "[INFO] System: $(uname -a)" >>"$PREBOOT_LOG"
echo "[INFO] User: $USER" >>"$PREBOOT_LOG"
echo "[INFO] Hostname: $ARK_SYSTEM_NAME" >>"$PREBOOT_LOG"
echo "[INFO] Time: $(date)" >>"$PREBOOT_LOG"
echo "[INFO] ARK Config:" >>"$PREBOOT_LOG"
cat "$ARK_CONFIG_PATH" >>"$PREBOOT_LOG"

# 1. Source ark-menu and ALL menu submodules (regardless of shebang)
ARK_MENU_PATH="$ARK_DOCK_PATH/ark-menu/ark-menu.sh"
ARK_MENU_SYSTEMS_BAY="$ARK_DOCK_PATH/ark-menu/ark-menu-systems-bay"
if [[ -r "$ARK_MENU_PATH" ]]; then
    if bash -n "$ARK_MENU_PATH" 2>>"$PREBOOT_LOG"; then
        source "$ARK_MENU_PATH" 2>>"$PREBOOT_LOG"
        log_module_status "ark-menu/ark-menu.sh" "OK"
        for submod in "$ARK_MENU_SYSTEMS_BAY"/*.sh; do
            [[ -r "$submod" ]] && source "$submod" 2>>"$PREBOOT_LOG"
        done
    else
        log_module_status "ark-menu/ark-menu.sh" "FAIL" "Syntax error."
    fi
else
    log_module_status "ark-menu/ark-menu.sh" "FAIL" "Missing or unreadable."
    echo "[FATAL] Menu module $ARK_MENU_PATH not found." >>"$PREBOOT_LOG"
    echo -e "${ARK_COLOR_FAIL}[FATAL ERROR] Location: ARK-Orbital-Command\nFix: Menu module $ARK_MENU_PATH not found.\n\"I'll guide you, Commander.\"${ARK_COLOR_RESET}"
    read -rp "Press [Enter] to exit..."
    exit 1
fi

# 2. Source ark-reboot systems bay (modular reboot handler)
ARK_REBOOT_PATH="$ARK_DOCK_PATH/ark-reboot/ark-reboot.sh"
if [[ -r "$ARK_REBOOT_PATH" ]]; then
    if bash -n "$ARK_REBOOT_PATH" 2>>"$PREBOOT_LOG"; then
        if source "$ARK_REBOOT_PATH" 2>>"$PREBOOT_LOG"; then
            log_module_status "ark-reboot/ark-reboot.sh" "OK"
        else
            log_module_status "ark-reboot/ark-reboot.sh" "FAIL" "Source error."
        fi
    else
        log_module_status "ark-reboot/ark-reboot.sh" "FAIL" "Syntax error."
    fi
else
    log_module_status "ark-reboot/ark-reboot.sh" "FAIL" "Missing or unreadable."
fi

# 3. Load all other modules except ark-menu and ark-reboot (source regardless of shebang)
for mod in "$ARK_DOCK_PATH"/*/*.sh; do
    base="$(basename "$mod")"
    moddir="$(basename "$(dirname "$mod")")"
    [[ "$moddir" == "ark-menu" || "$moddir" == "ark-reboot" ]] && continue
    if [[ -r "$mod" ]]; then
        if bash -n "$mod" 2>>"$PREBOOT_LOG"; then
            if source "$mod" 2>>"$PREBOOT_LOG"; then
                log_module_status "$moddir/$base" "OK"
            else
                log_module_status "$moddir/$base" "FAIL" "Source error."
            fi
        else
            log_module_status "$moddir/$base" "FAIL" "Syntax error."
        fi
    else
        log_module_status "$moddir/$base" "FAIL" "Missing or unreadable."
    fi
done

# 4. Enhanced Preboot log and interactive diagnostics
if [ -s "$PREBOOT_LOG" ]; then
    clear
    echo -e "${ARK_COLOR_BG}${ARK_COLOR_TITLE}${ARK_ICON_STAR} ARK ORBITAL COMMAND PREBOOT ${ARK_ICON_STAR}${ARK_COLOR_RESET}"
    echo -e "${ARK_COLOR_SECTION}${ARK_ICON_DIVIDER}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${ARK_COLOR_RESET}"

    awk '
    /^\[OK\]/       {print "\033[38;5;70m✅ " $0 "\033[0m"}
    /^\[CONFIG\]/   {print "\033[38;5;75m🗄️ " $0 "\033[0m"}
    /^\[INFO\]/     {print "\033[38;5;81m📋 " $0 "\033[0m"}
    /^\[FAIL\]/     {print "\033[38;5;196m❌ " $0 "\033[0m"}
    /^\[FATAL\]/    {print "\033[38;5;196m❌ " $0 "\033[0m"}
    /^[d]/          {print "\033[38;5;219m📁 " $0 "\033[0m"}
    /^[\-]/         {print "\033[38;5;250m📝 " $0 "\033[0m"}
    ' "$PREBOOT_LOG"

    echo -e "${ARK_COLOR_SECTION}${ARK_ICON_DIVIDER}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${ARK_COLOR_RESET}"

    error_found=$(grep -c 'FAIL\|FATAL' "$PREBOOT_LOG")
    if (( error_found > 0 )); then
        echo -e "${ARK_COLOR_FAIL}⚠️ [PRE-BOOT ERROR DETECTED]${ARK_COLOR_RESET}"
        echo -e "${ARK_COLOR_DETAIL}Location: ARK Orbital Command"
        echo -e "Fix: Review errors above. \"I'll guide you, Commander.\"${ARK_COLOR_RESET}"
        echo -e "${ARK_COLOR_BLUE}${ARK_ICON_DIAG} Press [d] for advanced diagnostics, [Enter] to continue...${ARK_COLOR_RESET}"
        read -n 1 -s key
        if [[ "$key" == "d" ]]; then
            ark_diagnostic_protocol
        fi
    else
        SECONDS_TO_WAIT=10
        echo -e "${ARK_COLOR_OK}${ARK_ICON_SPARK} All ARK modules loaded!${ARK_COLOR_RESET}"
        echo -e "${ARK_COLOR_SECTION}Press any key to launch the main menu, or wait for the timer.${ARK_COLOR_RESET}"
        for ((i=SECONDS_TO_WAIT; i>=1; i--)); do
            echo -ne "${ARK_COLOR_PANEL}${ARK_ICON_ARROW} Launching ARK Main Menu in ${i} ... (Press any key to continue)${ARK_COLOR_RESET}\r"
            read -t 1 -n 1 key && break
        done
        echo -ne "${ARK_COLOR_TITLE}                                        ${ARK_COLOR_RESET}\r"
    fi
fi

# 5. Launch the ARK main menu (only after countdown/Enter)
if type ark_main_menu &>/dev/null; then
    ark_main_menu
else
    echo -e "${ARK_COLOR_FAIL}❌ [FATAL ERROR] ark_main_menu not defined after sourcing ark-menu.sh!"
    echo -e "Location: ARK-Orbital-Command"
    echo -e "Fix: Check ark-menu.sh for typos, syntax errors, or missing function definition."
    echo -e "\"I'll guide you, Commander.\"${ARK_COLOR_RESET}"
    read -rp "Press [Enter] to exit..."
    exit 1
fi

echo -e "${ARK_COLOR_BG}${ARK_COLOR_OK}ARK-Orbital-Command v${ARK_ORBITAL_VERSION} session complete. Review any logs above. Press [Enter] to close...${ARK_COLOR_RESET}"
read
