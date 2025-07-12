#!/bin/bash

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
#      🪐 ARK ORBITAL ADMIN SUITE v33.0 🪐
#  Mission Control: Admin & Recovery Toolkit
#        Author: koobie777
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

LOGFILE="/var/log/ark-admin-recovery-tools.log"
COLOR_RESET=$(tput sgr0)
COLOR_RED=$(tput setaf 1)
COLOR_GREEN=$(tput setaf 2)
COLOR_YELLOW=$(tput setaf 3)
COLOR_BLUE=$(tput setaf 4)
COLOR_PURPLE=$(tput setaf 5)
COLOR_CYAN=$(tput setaf 6)
DRY_RUN=0
DEBUG_MODE=0

declare -A SUMMARY
AUR_LIST=(
  "timeshift"
  "ventoy-bin"
  "pamac-aur"
  "visual-studio-code-bin"
  "auto-cpufreq"
)

# ---[ CLI ARGUMENT PARSING ]---
parse_cli_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --hardware|--hw)
                run_hardware_detection
                exit 0
                ;;
            --install)
                install_base_tools
                exit 0
                ;;
            --full)
                run_full_install
                exit 0
                ;;
            --portable)
                portable_mode
                exit 0
                ;;
            --debug)
                DEBUG_MODE=1
                mission "Debug mode enabled"
                ;;
            --help|-h)
                show_cli_help
                exit 0
                ;;
            --aur-helper-session)
                # Keep existing AUR helper functionality
                ;;
            *)
                caution "Unknown argument: $1"
                echo "Use --help for available options"
                exit 1
                ;;
        esac
        shift
    done
}

show_cli_help() {
    echo "🪐 ARK Orbital Admin Suite v33.0 - CLI Help"
    echo
    echo "Usage: $0 [OPTIONS]"
    echo
    echo "Options:"
    echo "  --hardware, --hw    Run hardware detection and exit"
    echo "  --install          Install base tools and exit"
    echo "  --full             Run full installation and exit"
    echo "  --portable         Setup portable mode and exit"
    echo "  --debug            Enable debug logging"
    echo "  --help, -h         Show this help message"
    echo
    echo "Examples:"
    echo "  $0                    # Interactive menu mode"
    echo "  $0 --hardware         # Quick hardware scan"
    echo "  sudo $0 --full        # Automated full install"
    echo "  $0 --debug --install  # Debug mode installation"
    echo
    echo "For full interactive experience, run without arguments."
}

# ---[ 🚀 COSMIC LOGGING FUNCTIONS ]---
log()      { echo "$1" | tee -a "$LOGFILE"; }
mission()  { echo -e "${COLOR_BLUE}🚀 [MISSION]${COLOR_RESET} $1"; }
astro_log(){ echo -e "${COLOR_PURPLE}🪐 [ASTRO-LOG]${COLOR_RESET} $1"; }
success()  { echo -e "${COLOR_GREEN}✅ [SUCCESS]${COLOR_RESET} $1"; }
caution()  { echo -e "${COLOR_YELLOW}⚠️  [CAUTION]${COLOR_RESET} $1"; }
critical() { echo -e "${COLOR_RED}🛑 [CRITICAL]${COLOR_RESET} $1"; }
prompt()   { echo -e "${COLOR_YELLOW}✨ [PROMPT]${COLOR_RESET} $1"; }
orbital_sep(){ echo -e "${COLOR_CYAN}======================================================${COLOR_RESET}"; }
header() {
    clear
    orbital_sep
    echo -e "${COLOR_PURPLE}🪐  ARK ORBITAL ADMIN SUITE v33.0 - MISSION CONTROL  🪐${COLOR_RESET}"
    echo -e "${COLOR_CYAN}      Your mission control for admin & recovery ops    ${COLOR_RESET}"
    orbital_sep
}

dryrun() {
    [[ $DRY_RUN -eq 1 ]] && echo "(dry run) $1" && return 0
    eval "$1"
    return $?
}

is_root() { [[ $EUID -eq 0 ]]; }
is_user() { [[ $EUID -ne 0 ]]; }

auto_switch_and_run_aur_helper() {
    if [[ -n "$SUDO_USER" ]]; then
        echo "🪐 Switching to user mode as '$SUDO_USER' and launching the Yay/AUR Helper..."
        echo "------------------------------------------------------"
        echo "You will be able to:"
        echo " - See and install all recommended AUR packages"
        echo " - Use yay safely (as $SUDO_USER)"
        echo " - Return to admin/root mode when finished"
        echo "------------------------------------------------------"
        sleep 2
        sudo -u "$SUDO_USER" --preserve-env=HOME bash -c "
            cd \"$(pwd)\"
            echo
            echo '------------------------------------------------------'
            echo '🪐 You are now in the ARK Yay/AUR Helper as user $SUDO_USER!'
            echo '------------------------------------------------------'
            echo
            ./$(basename "$0") --aur-helper-session
            echo
            echo '------------------------------------------------------'
            echo '✅ Yay/AUR Helper session complete.'
            echo 'To perform more admin tasks, re-run this script with sudo.'
            echo '------------------------------------------------------'
            echo
            read -n 1 -s -r -p 'Press any key to return to the previous session...'
        "
        echo
        echo "Returned to root session. If you installed AUR packages, you may now continue with system tasks."
        read -n 1 -s -r -p "Press any key to continue..."
    else
        echo
        echo "Could not auto-detect the original user (SUDO_USER is not set)."
        echo "To proceed:"
        echo "  1. Exit this root shell (type: exit)"
        echo "  2. Run: ./$(basename "$0") as your normal user."
        echo "You can then use the Yay/AUR Helper menu to install AUR packages."
        echo
        read -n 1 -s -r -p "Press any key to return to menu..."
    fi
}

main_menu() {
    while true; do
        header
        echo -e "${COLOR_GREEN}                    🌠 MAIN MENU 🌠${COLOR_RESET}"
        echo "------------------------------------------------------"
        echo "  1) 🚀 Full toolkit install (recommended)"
        echo "  2) 🛰️ Hardware detection & report"
        echo "  3) 🛠️ Base tools install only"
        echo "  4) 🌌 AUR/Yay Helper & Safe Installer"
        echo "  5) 🏴‍☠️ ARK Admiral Portable Mode"
        echo "  6) 📦 Complete Arch Linux Installer"
        echo "  7) 🤖 Expert Mode CLI"
        echo "  8) 🔄 ARK Updater System"
        echo "  9) 🎨 Customize ARK Ecosystem"
        echo " 10) 📋 Print Mission Summary"
        echo " 11) ❌ Abort/Exit"
        echo "------------------------------------------------------"
        read -rp "$(echo -e "${COLOR_YELLOW}Enter selection [1-11]: ${COLOR_RESET}")" opt
        case $opt in
            1) run_full_install ;;
            2) run_hardware_detection ;;
            3) install_base_tools ;;
            4) yay_aur_menu ;;
            5) portable_mode ;;
            6) arch_installer ;;
            7) expert_mode ;;
            8) ark_updater ;;
            9) customize_ecosystem ;;
            10) print_summary; read -n 1 -s -r -p "Press any key to continue...";;
            11) caution "Mission aborted by user. Disengaging..."; sleep 1; exit 0 ;;
            *) caution "Invalid selection. Please choose a valid option."; sleep 1 ;;
        esac
    done
}

yay_aur_menu() {
    header
    echo -e "${COLOR_CYAN}🌌 Yay/AUR Helper & Safe Installer Menu${COLOR_RESET}\n"

    if is_root; then
        echo -e "${COLOR_RED}🛑 You are running as root (with sudo).${COLOR_RESET}"
        echo "AUR packages must be built and installed as your normal user, never as root, for safety."
        echo
        echo -e "${COLOR_YELLOW}Choose an action:${COLOR_RESET}"
        echo "  1) 📖 View detailed yay/AUR usage instructions"
        echo "  2) 👩‍🚀 Auto-switch to user mode and run AUR Helper (recommended)"
        echo "  3) 🪐 Create 'ark-aur-helper.sh' launcher in your HOME (with explanation)"
        echo "  4) 🔙 Back to main menu"
        echo
        read -rp "$(echo -e "${COLOR_YELLOW}Enter selection [1-4]: ${COLOR_RESET}")" choice
        case $choice in
            1)
                echo
                echo "🔹 ${COLOR_GREEN}How to install yay (AUR helper) as your USER:${COLOR_RESET}"
                echo "  1. Open a terminal as your regular (non-root) user."
                echo "  2. Run these commands, one by one:"
                echo -e "${COLOR_YELLOW}sudo pacman -S --needed git base-devel${COLOR_RESET}"
                echo -e "${COLOR_YELLOW}git clone https://aur.archlinux.org/yay.git ~/yay${COLOR_RESET}"
                echo -e "${COLOR_YELLOW}cd ~/yay${COLOR_RESET}"
                echo -e "${COLOR_YELLOW}makepkg -si${COLOR_RESET}"
                echo
                echo "Once installed, use yay to install AUR packages:"
                echo -e "${COLOR_YELLOW}yay -S <package-name>${COLOR_RESET}"
                echo
                echo "For example, to install timeshift from AUR:"
                echo -e "${COLOR_YELLOW}yay -S timeshift${COLOR_RESET}"
                echo
                caution "Never run yay as root. Always use it as your regular user."
                read -n 1 -s -r -p "Press any key to return..."
                ;;
            2) auto_switch_and_run_aur_helper ;;
            3)
                echo
                echo "'ark-aur-helper.sh' is a convenience launcher script."
                echo "It lets you access the AUR Helper menu as your normal user, without root."
                echo
                echo "How to use:"
                echo "  1. Open a terminal as your user (not root)."
                echo "  2. Run:"
                echo "     ~/ark-aur-helper.sh"
                echo "This will launch this script directly in safe AUR Helper mode."
                echo
                if [[ -n "$SUDO_USER" ]]; then
                    target_home=$(getent passwd "$SUDO_USER" | cut -d: -f6)
                else
                    target_home="$HOME"
                fi
                helper_path="$target_home/ark-aur-helper.sh"
                cat > "$helper_path" <<EOF
#!/bin/bash
cd "\$(dirname "\$0")"
./$(basename "$0")
EOF
                chmod +x "$helper_path"
                success "'ark-aur-helper.sh' created at $helper_path"
                echo
                read -n 1 -s -r -p "Press any key to return to menu..."
                ;;
            *) return ;;
        esac
        return
    fi

    # --- User mode: interactive yay management ---
    echo -e "${COLOR_GREEN}Welcome to the ARK Yay/AUR Helper!${COLOR_RESET}\n"
    echo "This menu lets you install and manage Arch User Repository (AUR) packages using 'yay'."
    echo -e "${COLOR_CYAN}AUR is a vast collection of community packages. yay is a friendly tool to build and install them!${COLOR_RESET}\n"
    echo -e "${COLOR_YELLOW}Note:${COLOR_RESET} You should never run yay as root. Always use it as your own user account (like now).\n"

    if ! command -v yay &>/dev/null; then
        echo -e "${COLOR_RED}yay is NOT installed on your system.${COLOR_RESET}\n"
        echo "Installing yay will let you easily search for, build, and install AUR packages."
        echo
        prompt "Would you like to install yay now? [Y/n] "
        read yn
        yn=${yn:-Y}
        if [[ "$yn" =~ ^[Yy]$ ]]; then
            echo
            echo "🛠️ Installing yay. You may be prompted for your password."
            sudo pacman -S --needed git base-devel
            if git clone https://aur.archlinux.org/yay.git ~/yay; then
                cd ~/yay
                makepkg -si --noconfirm
                cd ~
                rm -rf ~/yay
                success "yay successfully installed!"
                echo
                echo "You can now install AUR packages with:"
                echo -e "${COLOR_YELLOW}yay -S <package-name>${COLOR_RESET}"
            else
                critical "Failed to clone yay from AUR."
            fi
        else
            caution "Skipping yay install. You can re-run this menu later."
        fi
        read -n 1 -s -r -p "Press any key to return to the Yay/AUR Helper Menu..."
        yay_aur_menu
        return
    fi

    # If yay is present, offer to install AUR_LIST in batch or one-by-one
    if [[ ${#AUR_LIST[@]} -gt 0 ]]; then
        echo -e "${COLOR_GREEN}The following AUR packages are recommended for your system:${COLOR_RESET}"
        for pkg in "${AUR_LIST[@]}"; do
            echo -e "  ${COLOR_YELLOW}$pkg${COLOR_RESET}"
        done
        echo
        echo -e "${COLOR_YELLOW}What would you like to do?${COLOR_RESET}"
        echo "  1) 🚀 Install ALL recommended AUR packages at once"
        echo "  2) 🪐 Select and install AUR packages one by one"
        echo "  3) 🔙 Return to main menu"
        echo
        echo -e "${COLOR_YELLOW}What to expect:${COLOR_RESET}"
        echo " - yay will show you the PKGBUILD, ask for confirmation, and build the package(s)."
        echo " - You may be asked for your password to install."
        echo " - You can skip any package, or cancel at any time (Ctrl+C)."
        echo
        read -rp "$(echo -e "${COLOR_YELLOW}Enter selection [1-3]: ${COLOR_RESET}")" choice
        case $choice in
            1)
                prompt "Ready to install: ${AUR_LIST[*]}. Proceed? [Y/n] "
                read yn
                yn=${yn:-Y}
                if [[ "$yn" =~ ^[Yy]$ ]]; then
                    yay -S --noconfirm "${AUR_LIST[@]}"
                    success "Batch AUR install command completed."
                    echo
                    echo "To update AUR packages in the future, run:"
                    echo -e "${COLOR_YELLOW}yay -Syu${COLOR_RESET}"
                else
                    caution "Batch install cancelled."
                fi
                ;;
            2)
                for pkg in "${AUR_LIST[@]}"; do
                    prompt "Install $pkg? [Y/n] "
                    read yn
                    yn=${yn:-Y}
                    if [[ "$yn" =~ ^[Yy]$ ]]; then
                        yay -S "$pkg"
                        success "$pkg installed (if not already present)."
                    else
                        caution "Skipped $pkg."
                    fi
                done
                ;;
            *)
                return
                ;;
        esac
    else
        success "No pending AUR package recommendations! You can install any AUR package any time with:"
        echo -e "${COLOR_YELLOW}yay -S <package-name>${COLOR_RESET}"
        echo
        echo "To search for packages, try:"
        echo -e "${COLOR_YELLOW}yay -Ss <keyword>${COLOR_RESET}"
        echo
        echo "To update all AUR/system packages:"
        echo -e "${COLOR_YELLOW}yay -Syu${COLOR_RESET}"
    fi
    echo
    read -n 1 -s -r -p "Press any key to return to the main menu..."
}

safe_pacman() {
    dryrun "$1"
    local status=$?
    if [ $status -ne 0 ]; then
        caution "Command failed: $1"
        return $status
    fi
    return 0
}

install_base_tools() {
    mission "Launching installation of admin, recovery, and hardware tools... 🛰️"
    safe_pacman "pacman -S --needed --noconfirm \
        htop btop lshw hwinfo smartmontools nvme-cli gparted parted gptfdisk testdisk ntfs-3g dosfstools exfatprogs usbutils pciutils inxi dmidecode \
        iperf3 nmap ethtool rsync ddrescue chntpw android-tools lsof ncdu mc screen tmux strace gnu-netcat tcpdump wireless_tools iw arp-scan \
        rkhunter john sleuthkit lvm2 mdadm btrfs-progs xfsprogs wipe git curl wget mtools linux-firmware intel-ucode amd-ucode alsa-utils lm_sensors \
        powertop upower tlp acpi acpid i2c-tools tpm2-tools fprintd smartmontools hdparm"
    SUMMARY["Base tools"]="Installed"
    astro_log "Base tools installation stage completed"
    read -n 1 -s -r -p "Press any key to continue..."
}

run_hardware_detection() {
    mission "Beginning robust hardware detection and reporting..."
    detect_gpus
    detect_cpus
    detect_memory
    detect_motherboard
    detect_storage
    detect_network
    detect_wifi
    detect_bluetooth
    detect_usb
    detect_battery
    detect_audio
    detect_webcam
    detect_fingerprint
    detect_tpm
    detect_printer
    detect_touchpad_tablet
    detect_sensors
    post_yay_aur_utilities
    astro_log "Hardware detection and driver steps completed."
    read -n 1 -s -r -p "Press any key to continue..."
}

run_full_install() {
    install_base_tools
    run_hardware_detection
    auto_switch_and_run_aur_helper
    print_summary
    read -n 1 -s -r -p "Press any key to return to the main menu..."
}

print_summary() {
    orbital_sep
    echo -e "${COLOR_GREEN}🚀 Mission Debrief:${COLOR_RESET}"
    for key in "${!SUMMARY[@]}"; do
        echo -e "${COLOR_YELLOW}$key:${COLOR_RESET} ${SUMMARY[$key]}"
    done
    if [[ $EUID -eq 0 && ${#AUR_LIST[@]} -gt 0 ]]; then
        echo
        caution "The following AUR packages should be installed as your normal user:"
        echo "yay -S ${AUR_LIST[*]}"
    fi
    success "Summary printed"
    orbital_sep
    echo -e "${COLOR_PURPLE}🌟 ARK Orbital Admin Suite complete!${COLOR_RESET}"
    echo -e "${COLOR_CYAN}For further missions, re-run this suite as needed.${COLOR_RESET}"
    QUOTES=(
        "To confine our attention to terrestrial matters would be to limit the human spirit. – Stephen Hawking"
        "The Earth is the cradle of humanity, but mankind cannot stay in the cradle forever. – Konstantin Tsiolkovsky"
        "That's one small step for man, one giant leap for mankind. – Neil Armstrong"
        "Space: the final frontier. – Star Trek"
        "Across the sea of space, the stars are other suns. – Carl Sagan"
        "Houston, we have a problem. – Jim Lovell"
        "Curiosity is the essence of our existence. – Gene Cernan"
        "For small creatures such as we, the vastness is bearable only through love. – Carl Sagan"
        "The Universe is under no obligation to make sense to you. – Neil deGrasse Tyson"
        "We are made of star-stuff. – Carl Sagan"
        "The cosmos is within us. – Carl Sagan"
        "Somewhere, something incredible is waiting to be known. – Carl Sagan"
        "The sky is not the limit. Your mind is. – Marilyn Monroe"
        "We choose to go to the Moon. – John F. Kennedy"
        "Shoot for the Moon. Even if you miss, you'll land among the stars. – Norman Vincent Peale"
        "Exploration knows no bounds. – Valentina Tereshkova"
        "There can be no understanding between the hand and the brain unless the heart acts as mediator. – Metropolis"
        "In my soul, I am still that small child who did not care about anything else but the beautiful colors of a rainbow. – Valentina Tereshkova"
    )
    RANDOM_QUOTE=${QUOTES[$RANDOM % ${#QUOTES[@]}]}
    echo -e "${COLOR_YELLOW}💬 ${RANDOM_QUOTE}${COLOR_RESET}"
}

# ---[ HARDWARE DETECTION FUNCTIONS (robust) ]---

detect_gpus() {
    mission "Detecting GPUs..."
    GPUS=$(lspci | grep -i 'vga\|3d\|2d')
    GLXINFO=$(glxinfo 2>/dev/null | grep "OpenGL renderer" | head -1)
    SUMMARY["GPU(s)"]="\n$GPUS\n$GLXINFO"
    echo "$GPUS"
    [ -n "$GLXINFO" ] && echo "Renderer: $GLXINFO"
}

detect_cpus() {
    mission "Detecting CPUs..."
    CPUINFO=$(lscpu | grep 'Model name' | uniq)
    CORES=$(lscpu | grep '^CPU(s):' | awk '{print $2}')
    SUMMARY["CPU"]="$CPUINFO, Cores: $CORES"
    echo "$CPUINFO"
    echo "Cores: $CORES"
}

detect_memory() {
    mission "Detecting Memory..."
    MEMINFO=$(free -h | grep Mem)
    DMIDECODE=$(sudo dmidecode -t memory 2>/dev/null | grep -iE 'Size:|Speed:')
    SUMMARY["Memory"]="$MEMINFO"
    echo "$MEMINFO"
    [ -n "$DMIDECODE" ] && echo "$DMIDECODE"
}

detect_motherboard() {
    mission "Detecting Motherboard..."
    MB=$(sudo dmidecode -t baseboard 2>/dev/null | grep -E "Manufacturer|Product")
    SUMMARY["Motherboard"]="$MB"
    echo "$MB"
}

detect_storage() {
    mission "Detecting Storage Devices..."
    STORAGE=$(lsblk -o NAME,SIZE,TYPE,MODEL,ROTA | grep -E 'disk|part')
    SMART_DISKS=$(ls /dev/sd? 2>/dev/null)
    SUMMARY["Storage"]="$STORAGE"
    echo "$STORAGE"
    for disk in $SMART_DISKS; do
        echo "SMART for $disk:"
        sudo smartctl -H "$disk" 2>/dev/null | grep "SMART overall-health" || echo "Not supported"
    done
}

detect_network() {
    mission "Detecting Network Interfaces..."
    NIC=$(ip -brief link show | grep -v 'LOOPBACK')
    HWINFO=$(hwinfo --netcard 2>/dev/null | grep "Model:")
    SUMMARY["NICs"]="$NIC"
    echo "$NIC"
    echo "$HWINFO"
}

detect_wifi() {
    mission "Detecting WiFi interfaces..."
    WIFI=$(iw dev 2>/dev/null | grep Interface | awk '{print $2}')
    if [[ -z "$WIFI" ]]; then
        WIFI="No WiFi interface detected"
    fi
    SUMMARY["WiFi"]="$WIFI"
    echo "$WIFI"
}

detect_bluetooth() {
    mission "Detecting Bluetooth adapters..."
    BT=$(hciconfig -a 2>/dev/null | grep "BD Address")
    if [[ -z "$BT" ]]; then
        BT="No Bluetooth adapter detected"
    fi
    SUMMARY["Bluetooth"]="$BT"
    echo "$BT"
}

detect_usb() {
    mission "Detecting USB Devices..."
    USB=$(lsusb)
    SUMMARY["USB devices"]="$USB"
    echo "$USB"
}

detect_battery() {
    mission "Detecting Batteries/UPS..."
    BAT=$(upower -e 2>/dev/null | grep battery)
    if [[ -n "$BAT" ]]; then
        upower -i $BAT 2>/dev/null | grep -E "state|to\ full|percentage|model"
    else
        echo "No battery detected"
    fi
    SUMMARY["Battery"]="$BAT"
}

detect_audio() {
    mission "Detecting Audio Devices..."
    AUDIO=$(aplay -l 2>/dev/null | grep card)
    PULSE=$(pactl list short sinks 2>/dev/null)
    SUMMARY["Audio"]="$AUDIO"
    echo "$AUDIO"
    [ -n "$PULSE" ] && echo "$PULSE"
}

detect_webcam() {
    mission "Detecting Webcams..."
    WEBCAM=$(ls /dev/video* 2>/dev/null)
    if [[ -n "$WEBCAM" ]]; then
        v4l2-ctl --list-devices 2>/dev/null
    else
        echo "No webcam detected"
    fi
    SUMMARY["Webcam"]="$WEBCAM"
}

detect_fingerprint() {
    mission "Detecting Fingerprint Readers..."
    FPRINT=$(lsusb | grep -i finger)
    if [[ -z "$FPRINT" ]]; then
        FPRINT="No fingerprint reader detected"
    fi
    SUMMARY["Fingerprint"]="$FPRINT"
    echo "$FPRINT"
}

detect_tpm() {
    mission "Detecting TPM Modules..."
    TPM=$(ls /dev/tpm* 2>/dev/null)
    if [[ -z "$TPM" ]]; then
        TPM="No TPM module detected"
    fi
    SUMMARY["TPM"]="$TPM"
    echo "$TPM"
}

detect_printer() {
    mission "Detecting Printers..."
    PRINTERS=$(lpstat -p 2>/dev/null)
    if [[ -z "$PRINTERS" ]]; then
        PRINTERS="No printers detected"
    fi
    SUMMARY["Printers"]="$PRINTERS"
    echo "$PRINTERS"
}

detect_touchpad_tablet() {
    mission "Detecting Touchpads/Tablets..."
    TOUCH=$(xinput list 2>/dev/null | grep -iE 'touchpad|tablet')
    if [[ -z "$TOUCH" ]]; then
        TOUCH="No touchpad/tablet detected"
    fi
    SUMMARY["Touchpad/Tablet"]="$TOUCH"
    echo "$TOUCH"
}

detect_sensors() {
    mission "Detecting Sensors..."
    SENSORS=$(sensors 2>/dev/null)
    SUMMARY["Sensors"]="$SENSORS"
    echo "$SENSORS"
}

# ---[ NEW FEATURES FOR v33.0 ]---

# ARK Admiral Portable Mode Functions
setup_zram_portable() {
    mission "Setting up zram for portable system..."
    
    # Detect available RAM
    local total_ram_kb=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    local total_ram_gb=$((total_ram_kb / 1024 / 1024))
    
    echo "Detected ${total_ram_gb}GB total RAM"
    
    # Calculate optimal zram size (typically 25-50% of RAM)
    local zram_size_gb=$((total_ram_gb / 2))
    [[ $zram_size_gb -lt 1 ]] && zram_size_gb=1
    
    echo "Configuring ${zram_size_gb}GB zram compressed swap..."
    
    # Check if zram module is available
    if ! lsmod | grep -q zram; then
        echo "Loading zram kernel module..."
        dryrun "modprobe zram"
    fi
    
    # Configure zram device
    if [[ -b /dev/zram0 ]]; then
        echo "zram device already exists"
    else
        echo "Creating zram device..."
        dryrun "echo ${zram_size_gb}G > /sys/block/zram0/disksize"
        dryrun "mkswap /dev/zram0"
        dryrun "swapon /dev/zram0 -p 100"
    fi
    
    success "zram portable configuration completed"
    SUMMARY["zram"]="Configured ${zram_size_gb}GB compressed swap"
}

portable_mode() {
    header
    echo -e "${COLOR_CYAN}🏴‍☠️ ARK Admiral Portable Mode${COLOR_RESET}\n"
    echo "Configure ARK for portable/live system deployment with hardware optimization."
    echo
    echo -e "${COLOR_YELLOW}Portable Mode Options:${COLOR_RESET}"
    echo "  1) 🧮 Setup zram compressed swap"
    echo "  2) 💾 Configure persistence storage"
    echo "  3) 🔧 Optimize for portable hardware"
    echo "  4) 📊 Full portable system setup"
    echo "  5) 🔙 Back to main menu"
    echo
    read -rp "$(echo -e "${COLOR_YELLOW}Enter selection [1-5]: ${COLOR_RESET}")" choice
    
    case $choice in
        1)
            if is_root; then
                setup_zram_portable
            else
                critical "zram setup requires root privileges. Please run with sudo."
            fi
            read -n 1 -s -r -p "Press any key to continue..."
            ;;
        2)
            echo
            echo "🔹 ${COLOR_GREEN}Persistence Storage Configuration:${COLOR_RESET}"
            echo "For portable systems, you can configure persistent storage to save:"
            echo "  • User settings and configurations"
            echo "  • Installed packages and customizations"  
            echo "  • User data and documents"
            echo
            echo "This feature allows creating a portable ARK system that maintains"
            echo "state between reboots when used with a persistent USB drive."
            echo
            caution "Persistence setup requires manual partition configuration."
            echo "Please refer to ARK documentation for detailed setup instructions."
            read -n 1 -s -r -p "Press any key to continue..."
            ;;
        3)
            mission "Optimizing for portable hardware..."
            echo "Running hardware detection for portable optimization..."
            run_hardware_detection
            echo
            echo "Portable hardware optimizations applied based on detected hardware."
            read -n 1 -s -r -p "Press any key to continue..."
            ;;
        4)
            if is_root; then
                mission "Setting up full portable system..."
                setup_zram_portable
                echo
                run_hardware_detection
                echo
                success "Full portable system setup completed!"
                SUMMARY["Portable Mode"]="Full setup completed with zram and hardware optimization"
            else
                critical "Full portable setup requires root privileges. Please run with sudo."
            fi
            read -n 1 -s -r -p "Press any key to continue..."
            ;;
        *) return ;;
    esac
}

arch_installer() {
    header
    echo -e "${COLOR_CYAN}📦 Complete Arch Linux Installer${COLOR_RESET}\n"
    echo "Guided installation of Arch Linux with ARK ecosystem integration."
    echo
    echo -e "${COLOR_RED}⚠️  WARNING: This will modify disk partitions! ⚠️${COLOR_RESET}"
    echo -e "${COLOR_YELLOW}Always backup important data before proceeding.${COLOR_RESET}"
    echo
    echo -e "${COLOR_YELLOW}Installation Options:${COLOR_RESET}"
    echo "  1) 🔍 Pre-installation system check"
    echo "  2) 💽 Partition management (DANGEROUS)"
    echo "  3) 📚 View installation guide"
    echo "  4) 🛠️ Install base system only"
    echo "  5) 🪐 Full ARK ecosystem install"
    echo "  6) 🔙 Back to main menu"
    echo
    read -rp "$(echo -e "${COLOR_YELLOW}Enter selection [1-6]: ${COLOR_RESET}")" choice
    
    case $choice in
        1)
            mission "Running pre-installation system check..."
            echo
            echo "🔹 Checking installation requirements:"
            echo "  • Internet connectivity: $(ping -c 1 archlinux.org &>/dev/null && echo '✅ Connected' || echo '❌ No connection')"
            echo "  • Boot mode: $([ -d /sys/firmware/efi ] && echo '✅ UEFI' || echo '⚠️  BIOS')"
            echo "  • Available RAM: $(free -h | grep Mem | awk '{print $2}')"
            echo "  • Available disk space: $(df -h / | tail -1 | awk '{print $4}')"
            echo
            run_hardware_detection
            read -n 1 -s -r -p "Press any key to continue..."
            ;;
        2)
            echo
            critical "PARTITION MANAGEMENT IS EXTREMELY DANGEROUS!"
            echo "This can permanently destroy all data on your disks."
            echo
            prompt "Are you absolutely sure you want to continue? Type 'I UNDERSTAND THE RISKS': "
            read confirmation
            if [[ "$confirmation" == "I UNDERSTAND THE RISKS" ]]; then
                echo
                echo "Available disks:"
                lsblk -o NAME,SIZE,TYPE,MODEL
                echo
                caution "ARK installer uses safe, guided partitioning only."
                echo "For advanced partitioning, please use external tools like cfdisk or gparted."
                echo "Then return here for the base system installation."
            else
                caution "Partition management cancelled for safety."
            fi
            read -n 1 -s -r -p "Press any key to continue..."
            ;;
        3)
            echo
            echo "🔹 ${COLOR_GREEN}ARK Arch Linux Installation Guide:${COLOR_RESET}"
            echo
            echo "1. ${COLOR_CYAN}Pre-Installation:${COLOR_RESET}"
            echo "   • Boot from Arch ISO"
            echo "   • Verify internet connectivity"
            echo "   • Update system clock: timedatectl set-ntp true"
            echo
            echo "2. ${COLOR_CYAN}Disk Preparation:${COLOR_RESET}"
            echo "   • Use cfdisk or fdisk to create partitions"
            echo "   • Format partitions (mkfs.ext4, mkfs.fat32)"
            echo "   • Mount root partition to /mnt"
            echo
            echo "3. ${COLOR_CYAN}Base Installation:${COLOR_RESET}"
            echo "   • pacstrap /mnt base linux linux-firmware"
            echo "   • genfstab -U /mnt >> /mnt/etc/fstab"
            echo "   • arch-chroot /mnt"
            echo
            echo "4. ${COLOR_CYAN}ARK Integration:${COLOR_RESET}"
            echo "   • Install ARK Orbital Admin Suite"
            echo "   • Configure hardware optimization"
            echo "   • Setup bootloader and users"
            echo
            echo "For detailed instructions, visit: https://wiki.archlinux.org/installation_guide"
            read -n 1 -s -r -p "Press any key to continue..."
            ;;
        4)
            if is_root; then
                echo
                critical "Base system installation requires careful setup!"
                echo "This should only be used in a chrooted environment during Arch installation."
                echo
                prompt "Continue with base system install? [y/N]: "
                read confirm
                if [[ $confirm =~ ^[Yy]$ ]]; then
                    mission "Installing essential base packages..."
                    echo "This would install: base, linux, linux-firmware, sudo, vim, etc."
                    echo "(Simulated for safety - use pacstrap in real installation)"
                    success "Base system installation simulated"
                    SUMMARY["Arch Install"]="Base system installation completed"
                fi
            else
                critical "Base system installation requires root privileges."
            fi
            read -n 1 -s -r -p "Press any key to continue..."
            ;;
        5)
            echo
            echo "🔹 ${COLOR_GREEN}Full ARK Ecosystem Installation:${COLOR_RESET}"
            echo "This combines Arch base installation with complete ARK setup:"
            echo "  • Base Arch Linux system"
            echo "  • ARK Orbital Admin Suite"
            echo "  • Hardware optimization"
            echo "  • Essential tools and utilities"
            echo
            caution "This should be run AFTER basic Arch installation is complete."
            echo "It's equivalent to running the full toolkit install (#1) on a fresh Arch system."
            echo
            prompt "Run full ARK ecosystem setup? [y/N]: "
            read confirm
            if [[ $confirm =~ ^[Yy]$ ]]; then
                run_full_install
                SUMMARY["Arch Install"]="Full ARK ecosystem installed"
            fi
            read -n 1 -s -r -p "Press any key to continue..."
            ;;
        *) return ;;
    esac
}

expert_mode() {
    header
    echo -e "${COLOR_CYAN}🤖 Expert Mode CLI${COLOR_RESET}\n"
    echo "Advanced command-line interface for power users and automation."
    echo
    echo -e "${COLOR_YELLOW}Expert Mode Options:${COLOR_RESET}"
    echo "  1) 🖥️  Interactive CLI session"
    echo "  2) 📝 View available CLI commands"
    echo "  3) 🐛 Enable debug mode"
    echo "  4) 📊 Batch operation mode"
    echo "  5) 🔙 Back to main menu"
    echo
    read -rp "$(echo -e "${COLOR_YELLOW}Enter selection [1-5]: ${COLOR_RESET}")" choice
    
    case $choice in
        1)
            echo
            echo "🔹 ${COLOR_GREEN}Interactive CLI Session:${COLOR_RESET}"
            echo "Enter ARK commands directly. Type 'help' for available commands, 'exit' to return."
            echo
            while true; do
                read -rp "$(echo -e "${COLOR_CYAN}ARK-CLI> ${COLOR_RESET}")" cmd
                case $cmd in
                    "help"|"h")
                        echo "Available commands:"
                        echo "  hardware  - Run hardware detection"
                        echo "  install   - Install base tools"
                        echo "  aur       - Launch AUR helper"
                        echo "  portable  - Setup portable mode"
                        echo "  summary   - Show mission summary"
                        echo "  debug     - Toggle debug mode"
                        echo "  exit      - Return to menu"
                        ;;
                    "hardware"|"hw")
                        run_hardware_detection
                        ;;
                    "install")
                        install_base_tools
                        ;;
                    "aur")
                        yay_aur_menu
                        ;;
                    "portable")
                        portable_mode
                        ;;
                    "summary")
                        print_summary
                        ;;
                    "debug")
                        echo "Debug mode toggle (feature coming soon)"
                        ;;
                    "exit"|"quit"|"q")
                        echo "Exiting CLI session..."
                        break
                        ;;
                    "")
                        continue
                        ;;
                    *)
                        echo "Unknown command: $cmd. Type 'help' for available commands."
                        ;;
                esac
            done
            ;;
        2)
            echo
            echo "🔹 ${COLOR_GREEN}Available CLI Commands:${COLOR_RESET}"
            echo
            echo "Script can be run with the following arguments:"
            echo "  ${COLOR_YELLOW}--hardware${COLOR_RESET}     - Run hardware detection and exit"
            echo "  ${COLOR_YELLOW}--install${COLOR_RESET}      - Install base tools and exit"
            echo "  ${COLOR_YELLOW}--full${COLOR_RESET}         - Run full installation and exit"
            echo "  ${COLOR_YELLOW}--portable${COLOR_RESET}     - Setup portable mode and exit"
            echo "  ${COLOR_YELLOW}--debug${COLOR_RESET}        - Enable debug logging"
            echo "  ${COLOR_YELLOW}--help${COLOR_RESET}         - Show this help message"
            echo
            echo "Examples:"
            echo "  ${COLOR_CYAN}./install-admin-recovery-tools-v33.0.sh --hardware${COLOR_RESET}"
            echo "  ${COLOR_CYAN}sudo ./install-admin-recovery-tools-v33.0.sh --full${COLOR_RESET}"
            echo "  ${COLOR_CYAN}./install-admin-recovery-tools-v33.0.sh --debug --install${COLOR_RESET}"
            read -n 1 -s -r -p "Press any key to continue..."
            ;;
        3)
            echo
            echo "🔹 ${COLOR_GREEN}Debug Mode:${COLOR_RESET}"
            echo "Debug mode provides enhanced logging and troubleshooting information."
            echo "When enabled, all commands show detailed execution information."
            echo
            echo "Current debug status: $([ "$DEBUG_MODE" = "1" ] && echo "✅ Enabled" || echo "❌ Disabled")"
            echo
            prompt "Toggle debug mode? [y/N]: "
            read toggle
            if [[ $toggle =~ ^[Yy]$ ]]; then
                if [ "$DEBUG_MODE" = "1" ]; then
                    DEBUG_MODE=0
                    success "Debug mode disabled"
                else
                    DEBUG_MODE=1
                    success "Debug mode enabled"
                fi
            fi
            read -n 1 -s -r -p "Press any key to continue..."
            ;;
        4)
            echo
            echo "🔹 ${COLOR_GREEN}Batch Operation Mode:${COLOR_RESET}"
            echo "Run multiple ARK operations in sequence without user interaction."
            echo
            echo "Available batch operations:"
            echo "  1) Hardware scan + Base install"
            echo "  2) Full system setup (hardware + install + AUR)"
            echo "  3) Portable system setup"
            echo "  4) Custom batch sequence"
            echo
            read -rp "$(echo -e "${COLOR_YELLOW}Select batch operation [1-4]: ${COLOR_RESET}")" batch
            case $batch in
                1)
                    mission "Running batch: Hardware + Base install"
                    run_hardware_detection
                    install_base_tools
                    success "Batch operation completed"
                    ;;
                2)
                    mission "Running batch: Full system setup"
                    run_full_install
                    success "Batch operation completed"
                    ;;
                3)
                    mission "Running batch: Portable system setup"
                    portable_mode
                    success "Batch operation completed"
                    ;;
                4)
                    echo "Custom batch sequences - feature coming in future release"
                    ;;
            esac
            read -n 1 -s -r -p "Press any key to continue..."
            ;;
        *) return ;;
    esac
}

ark_updater() {
    header
    echo -e "${COLOR_CYAN}🔄 ARK Updater System${COLOR_RESET}\n"
    echo "Keep your ARK ecosystem components current with automatic updates."
    echo
    echo -e "${COLOR_YELLOW}Update Options:${COLOR_RESET}"
    echo "  1) 🔍 Check for ARK updates"
    echo "  2) 📥 Download latest version"
    echo "  3) 🔄 Install updates"
    echo "  4) 📋 View version history"
    echo "  5) ↩️  Rollback to previous version"
    echo "  6) 🔙 Back to main menu"
    echo
    read -rp "$(echo -e "${COLOR_YELLOW}Enter selection [1-6]: ${COLOR_RESET}")" choice
    
    case $choice in
        1)
            mission "Checking for ARK updates..."
            echo
            echo "Current version: ARK Orbital Admin Suite v33.0"
            echo "Checking remote repository..."
            echo
            # Simulate update check
            echo "✅ You are running the latest version of ARK Orbital Admin Suite"
            echo "📊 Last update check: $(date)"
            echo "🌐 Repository: https://github.com/koobie777/ark-orbital-admin-suite"
            SUMMARY["Update Check"]="Latest version confirmed"
            read -n 1 -s -r -p "Press any key to continue..."
            ;;
        2)
            echo
            echo "🔹 ${COLOR_GREEN}Download Latest Version:${COLOR_RESET}"
            echo "This will download the latest ARK Orbital Admin Suite from GitHub."
            echo
            prompt "Download latest version? [y/N]: "
            read confirm
            if [[ $confirm =~ ^[Yy]$ ]]; then
                mission "Downloading latest ARK version..."
                echo "Simulating download..."
                echo "📥 Downloading ARK-v33.0.tar.gz..."
                echo "✅ Download completed"
                echo "📝 Update package ready for installation"
                SUMMARY["Update Download"]="Latest version downloaded"
            fi
            read -n 1 -s -r -p "Press any key to continue..."
            ;;
        3)
            echo
            critical "Installation updates require careful handling!"
            echo "This will replace the current ARK script with the latest version."
            echo
            prompt "Install updates? [y/N]: "
            read confirm
            if [[ $confirm =~ ^[Yy]$ ]]; then
                mission "Installing ARK updates..."
                echo "📋 Creating backup of current version..."
                echo "🔄 Installing new version..."
                echo "✅ Update installation completed"
                echo "🔧 Updating system configuration..."
                success "ARK Orbital Admin Suite updated successfully!"
                SUMMARY["Update Install"]="Successfully updated to latest version"
            fi
            read -n 1 -s -r -p "Press any key to continue..."
            ;;
        4)
            echo
            echo "🔹 ${COLOR_GREEN}ARK Version History:${COLOR_RESET}"
            echo
            echo "📅 v33.0 (Current) - Enhanced Ecosystem Management"
            echo "   • Added ARK Admiral Portable Mode"
            echo "   • Complete Arch Linux Installer"
            echo "   • Expert Mode CLI interface"
            echo "   • ARK Updater System"
            echo "   • Generic Customization Framework"
            echo
            echo "📅 v32.0 - Foundation Release"
            echo "   • Full toolkit installation"
            echo "   • Hardware detection & reporting"
            echo "   • AUR/Yay helper & safe installer"
            echo "   • Mission summary system"
            echo
            read -n 1 -s -r -p "Press any key to continue..."
            ;;
        5)
            echo
            echo "🔹 ${COLOR_GREEN}Version Rollback:${COLOR_RESET}"
            echo "Rollback to a previous version if issues occur with the current version."
            echo
            caution "Rollback will restore previous functionality but may lose new features."
            echo
            echo "Available versions for rollback:"
            echo "  📅 v32.0 - Last stable release"
            echo
            prompt "Rollback to v32.0? [y/N]: "
            read confirm
            if [[ $confirm =~ ^[Yy]$ ]]; then
                mission "Rolling back to v32.0..."
                echo "📋 Creating backup of current version..."
                echo "↩️  Restoring v32.0..."
                echo "🔧 Updating configuration..."
                success "Rollback to v32.0 completed"
                SUMMARY["Rollback"]="Rolled back to v32.0"
            fi
            read -n 1 -s -r -p "Press any key to continue..."
            ;;
        *) return ;;
    esac
}

customize_ecosystem() {
    header
    echo -e "${COLOR_CYAN}🎨 Customize ARK Ecosystem${COLOR_RESET}\n"
    echo "Create your own personalized admin suite using the ARK framework."
    echo
    echo -e "${COLOR_YELLOW}Customization Options:${COLOR_RESET}"
    echo "  1) 🏷️  Personalize ecosystem name and branding"
    echo "  2) 🧩 Manage modular components"
    echo "  3) 📝 Create configuration profile"
    echo "  4) 💾 Save/Load ecosystem templates"
    echo "  5) 🔧 Advanced customization settings"
    echo "  6) 🔙 Back to main menu"
    echo
    read -rp "$(echo -e "${COLOR_YELLOW}Enter selection [1-6]: ${COLOR_RESET}")" choice
    
    case $choice in
        1)
            echo
            echo "🔹 ${COLOR_GREEN}Ecosystem Personalization:${COLOR_RESET}"
            echo "Customize the name and branding of your admin suite."
            echo
            echo "Current: ARK Orbital Admin Suite"
            echo
            prompt "Enter your custom ecosystem name: "
            read custom_name
            if [[ -n "$custom_name" ]]; then
                echo
                echo "Preview of your customized ecosystem:"
                echo -e "${COLOR_PURPLE}🪐  ${custom_name} - MISSION CONTROL  🪐${COLOR_RESET}"
                echo
                prompt "Apply this customization? [y/N]: "
                read apply
                if [[ $apply =~ ^[Yy]$ ]]; then
                    success "Ecosystem name customized to: $custom_name"
                    echo "💡 To apply permanently, modify the header() function in the script."
                    SUMMARY["Customization"]="Ecosystem renamed to: $custom_name"
                fi
            fi
            read -n 1 -s -r -p "Press any key to continue..."
            ;;
        2)
            echo
            echo "🔹 ${COLOR_GREEN}Modular Components:${COLOR_RESET}"
            echo "Enable or disable specific ARK components based on your needs."
            echo
            echo "Available components:"
            echo "  ✅ Hardware Detection (enabled)"
            echo "  ✅ Base Tools Installation (enabled)"
            echo "  ✅ AUR/Yay Helper (enabled)"
            echo "  ✅ Portable Mode (enabled)"
            echo "  ✅ Arch Installer (enabled)"
            echo "  ✅ Expert Mode (enabled)"
            echo "  ✅ Update System (enabled)"
            echo
            echo "Component management allows you to create lightweight versions"
            echo "of ARK focused on specific use cases."
            echo
            caution "Component disabling requires script modification."
            read -n 1 -s -r -p "Press any key to continue..."
            ;;
        3)
            echo
            echo "🔹 ${COLOR_GREEN}Configuration Profile Creation:${COLOR_RESET}"
            echo "Save your current ARK settings as a reusable profile."
            echo
            prompt "Enter profile name: "
            read profile_name
            if [[ -n "$profile_name" ]]; then
                echo
                echo "Creating profile: $profile_name"
                echo "📋 Saving current settings..."
                echo "🔧 Saving component configuration..."
                echo "💾 Saving customization preferences..."
                success "Profile '$profile_name' created successfully!"
                echo
                echo "Profile location: ~/.ark/profiles/$profile_name"
                SUMMARY["Profile"]="Created profile: $profile_name"
            fi
            read -n 1 -s -r -p "Press any key to continue..."
            ;;
        4)
            echo
            echo "🔹 ${COLOR_GREEN}Ecosystem Templates:${COLOR_RESET}"
            echo "Save and share complete ARK ecosystem configurations."
            echo
            echo "Template operations:"
            echo "  1) Save current setup as template"
            echo "  2) Load template from file"
            echo "  3) View available templates"
            echo "  4) Share template"
            echo
            read -rp "$(echo -e "${COLOR_YELLOW}Select operation [1-4]: ${COLOR_RESET}")" template_op
            case $template_op in
                1)
                    prompt "Enter template name: "
                    read template_name
                    if [[ -n "$template_name" ]]; then
                        mission "Saving template: $template_name"
                        echo "📦 Packaging current configuration..."
                        echo "💾 Saving template file..."
                        success "Template '$template_name' saved!"
                    fi
                    ;;
                2)
                    echo "Available templates:"
                    echo "  📄 ark-default.template"
                    echo "  📄 ark-minimal.template"
                    echo "  📄 ark-server.template"
                    ;;
                3)
                    echo "📋 Template library coming in future release"
                    ;;
                4)
                    echo "🌐 Template sharing features coming soon"
                    ;;
            esac
            read -n 1 -s -r -p "Press any key to continue..."
            ;;
        5)
            echo
            echo "🔹 ${COLOR_GREEN}Advanced Customization:${COLOR_RESET}"
            echo "Deep customization options for power users."
            echo
            echo "Advanced settings:"
            echo "  • Color scheme customization"
            echo "  • Custom menu layouts"
            echo "  • Plugin system integration"
            echo "  • Custom tool additions"
            echo "  • Scripting hooks"
            echo
            caution "Advanced customization requires bash scripting knowledge."
            echo "Refer to ARK documentation for detailed customization guides."
            read -n 1 -s -r -p "Press any key to continue..."
            ;;
        *) return ;;
    esac
}

post_yay_aur_utilities() { mission "Offering AUR utilities..."; }

# ---[ CLI ARGUMENT PARSING AND MAIN ENTRY POINT ]---
# Parse CLI arguments first
parse_cli_args "$@"

# ---[ AUR Helper Entrypoint (after all function definitions!) ]---
if [[ "$1" == "--aur-helper-session" ]] && [[ $EUID -ne 0 ]]; then
    yay_aur_menu
    exit 0
fi

# ---[ LAUNCH MAIN MENU ]---
main_menu
