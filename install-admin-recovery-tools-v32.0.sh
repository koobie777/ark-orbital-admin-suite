#!/bin/bash

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
#      🪐 ARK ORBITAL ADMIN SUITE v32.0 🪐
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

declare -A SUMMARY
AUR_LIST=(
  "timeshift"
  "ventoy-bin"
  "pamac-aur"
  "visual-studio-code-bin"
  "auto-cpufreq"
)

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
    echo -e "${COLOR_PURPLE}🪐  ARK ORBITAL ADMIN SUITE v32.0 - MISSION CONTROL  🪐${COLOR_RESET}"
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
        echo "  5) 📋 Print Mission Summary"
        echo "  6) ❌ Abort/Exit"
        echo "------------------------------------------------------"
        read -rp "$(echo -e "${COLOR_YELLOW}Enter selection [1-6]: ${COLOR_RESET}")" opt
        case $opt in
            1) run_full_install ;;
            2) run_hardware_detection ;;
            3) install_base_tools ;;
            4) yay_aur_menu ;;
            5) print_summary; read -n 1 -s -r -p "Press any key to continue...";;
            6) caution "Mission aborted by user. Disengaging..."; sleep 1; exit 0 ;;
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

post_yay_aur_utilities() { mission "Offering AUR utilities..."; }

# ---[ AUR Helper Entrypoint (after all function definitions!) ]---
if [[ "$1" == "--aur-helper-session" ]] && [[ $EUID -ne 0 ]]; then
    yay_aur_menu
    exit 0
fi

# ---[ LAUNCH MAIN MENU ]---
main_menu
