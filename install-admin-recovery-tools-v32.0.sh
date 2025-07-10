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
        echo "  5) 🪐 ARK Core Installation (Admiral GUI)"
        echo "  6) 📋 Print Mission Summary"
        echo "  7) ❌ Abort/Exit"
        echo "------------------------------------------------------"
        read -rp "$(echo -e "${COLOR_YELLOW}Enter selection [1-7]: ${COLOR_RESET}")" opt
        case $opt in
            1) run_full_install ;;
            2) run_hardware_detection ;;
            3) install_base_tools ;;
            4) yay_aur_menu ;;
            5) ark_core_installation ;;
            6) print_summary; read -n 1 -s -r -p "Press any key to continue...";;
            7) caution "Mission aborted by user. Disengaging..."; sleep 1; exit 0 ;;
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

# ---[ ARK CORE INSTALLATION FUNCTIONS ]---

ark_core_installation() {
    if ! is_root; then
        critical "ARK Core installation requires root privileges. Please run with sudo."
        read -n 1 -s -r -p "Press any key to return to menu..."
        return
    fi

    header
    echo -e "${COLOR_PURPLE}🪐 ARK CORE INSTALLATION - ADMIRAL GUI SETUP 🪐${COLOR_RESET}\n"
    echo -e "${COLOR_CYAN}This will install ARK Core with a complete Admiral GUI environment:${COLOR_RESET}"
    echo -e "  • Create 'commander' user with KDE Plasma desktop"
    echo -e "  • Space-themed environment with transparency and blur effects"
    echo -e "  • SSH server for remote access"
    echo -e "  • Full ARK Orbital Admin Suite integration"
    echo -e "  • Support for both headless and GUI modes"
    echo
    echo -e "${COLOR_YELLOW}Installation Mode Options:${COLOR_RESET}"
    echo "  1) 🖥️  Full GUI Mode (KDE Plasma + Desktop Environment)"
    echo "  2) 💻 Headless Mode (SSH access only, no GUI)"
    echo "  3) 🔙 Back to main menu"
    echo
    read -rp "$(echo -e "${COLOR_YELLOW}Select installation mode [1-3]: ${COLOR_RESET}")" mode_choice
    
    case $mode_choice in
        1) install_ark_core_gui ;;
        2) install_ark_core_headless ;;
        3) return ;;
        *) caution "Invalid selection. Returning to main menu."; return ;;
    esac
}

install_ark_core_gui() {
    mission "Initiating ARK Core GUI installation..."
    echo -e "${COLOR_YELLOW}This process will:${COLOR_RESET}"
    echo "1. Create 'commander' user account"
    echo "2. Install KDE Plasma desktop environment"
    echo "3. Configure space-themed desktop with effects"
    echo "4. Setup SSH server"
    echo "5. Install ARK Orbital Admin Suite tools"
    echo
    prompt "Continue with GUI installation? [Y/n] "
    read yn
    yn=${yn:-Y}
    if [[ ! "$yn" =~ ^[Yy]$ ]]; then
        caution "Installation cancelled."
        read -n 1 -s -r -p "Press any key to return..."
        return
    fi

    create_commander_user
    install_kde_plasma
    configure_space_theme
    configure_ssh_access
    integrate_ark_tools
    configure_auto_login
    
    success "ARK Core GUI installation completed!"
    echo -e "${COLOR_GREEN}🎉 Welcome to ARK Core Admiral GUI!${COLOR_RESET}"
    echo
    echo -e "${COLOR_CYAN}Next steps:${COLOR_RESET}"
    echo "• Reboot to start KDE Plasma: sudo reboot"
    echo "• Login as 'commander' user"
    echo "• SSH access available on port 22"
    echo "• ARK Orbital Admin Suite accessible from desktop"
    echo
    SUMMARY["ARK Core GUI"]="Installed with commander user and KDE Plasma"
    read -n 1 -s -r -p "Press any key to continue..."
}

install_ark_core_headless() {
    mission "Initiating ARK Core headless installation..."
    echo -e "${COLOR_YELLOW}This process will:${COLOR_RESET}"
    echo "1. Create 'commander' user account"
    echo "2. Setup SSH server for remote access"
    echo "3. Install ARK Orbital Admin Suite tools"
    echo "4. Configure headless operation"
    echo
    prompt "Continue with headless installation? [Y/n] "
    read yn
    yn=${yn:-Y}
    if [[ ! "$yn" =~ ^[Yy]$ ]]; then
        caution "Installation cancelled."
        read -n 1 -s -r -p "Press any key to return..."
        return
    fi

    create_commander_user
    configure_ssh_access
    integrate_ark_tools
    configure_headless_setup
    
    success "ARK Core headless installation completed!"
    echo -e "${COLOR_GREEN}🚀 ARK Core is ready for remote administration!${COLOR_RESET}"
    echo
    echo -e "${COLOR_CYAN}Access information:${COLOR_RESET}"
    echo "• SSH: ssh commander@$(hostname -I | awk '{print $1}')"
    echo "• ARK Orbital Admin Suite: ~/ark-orbital-admin-suite/"
    echo "• Default password: please change after first login"
    echo
    SUMMARY["ARK Core Headless"]="Installed with commander user and SSH access"
    read -n 1 -s -r -p "Press any key to continue..."
}

create_commander_user() {
    mission "Creating commander user account..."
    
    if id "commander" &>/dev/null; then
        caution "User 'commander' already exists. Skipping user creation."
        return
    fi
    
    # Create commander user with home directory
    safe_pacman "useradd -m -G wheel,audio,video,optical,storage -s /bin/bash commander"
    
    # Set password for commander
    echo -e "${COLOR_YELLOW}Setting password for commander user...${COLOR_RESET}"
    echo "commander:arkcommander" | chpasswd
    
    # Add commander to sudoers
    echo "commander ALL=(ALL) ALL" >> /etc/sudoers.d/commander
    
    # Create initial directories
    sudo -u commander mkdir -p /home/commander/{Desktop,Documents,Downloads,Pictures,Videos,Music}
    sudo -u commander mkdir -p /home/commander/.config
    
    success "Commander user created successfully"
    SUMMARY["Commander User"]="Created with administrative privileges"
}

install_kde_plasma() {
    mission "Installing KDE Plasma desktop environment..."
    
    # Install KDE Plasma and essential applications
    safe_pacman "pacman -S --needed --noconfirm \
        plasma-meta plasma-wayland-session kde-applications-meta \
        sddm sddm-kcm dolphin konsole kate kwrite kcalc \
        spectacle gwenview okular ark kfind ksystemlog \
        plasma-browser-integration plasma-desktop plasma-workspace \
        kscreen kgamma5 powerdevil plasma-pa plasma-nm \
        bluedevil discover packagekit-qt5 flatpak \
        ttf-liberation ttf-dejavu noto-fonts noto-fonts-emoji"
    
    # Enable display manager
    systemctl enable sddm
    
    # Install additional space-themed packages
    safe_pacman "pacman -S --needed --noconfirm \
        plasma-browser-integration latte-dock kvantum-qt5 \
        papirus-icon-theme breeze-gtk kde-gtk-config"
    
    success "KDE Plasma installation completed"
    SUMMARY["KDE Plasma"]="Installed with SDDM display manager"
}

configure_space_theme() {
    mission "Configuring space-themed desktop environment..."
    
    # Create theme configuration directory
    sudo -u commander mkdir -p /home/commander/.config/plasma-org.kde.plasma.desktop-appletsrc
    sudo -u commander mkdir -p /home/commander/.config/kwinrc
    sudo -u commander mkdir -p /home/commander/.config/plasmarc
    
    # Configure Plasma theme settings
    cat > /home/commander/.config/plasmarc << 'EOF'
[Theme]
name=breeze-dark

[Wallpapers]
usersWallpapers=/usr/share/wallpapers/
EOF
    
    # Configure KWin effects for transparency and blur
    cat > /home/commander/.config/kwinrc << 'EOF'
[Compositing]
Enabled=true
GLCore=true
HiddenPreviews=5
OpenGLIsUnsafe=false
WindowsBlockCompositing=true

[Effect-Blur]
BlurStrength=5
NoiseStrength=0

[Effect-DesktopGrid]
Zoomout=750

[Effect-PresentWindows]
DrawWindowCaptions=true
DrawWindowIcons=true

[Plugins]
blurEnabled=true
contrastEnabled=true
kwin4_effect_fadeEnabled=true
kwin4_effect_translucyEnabled=true
slideEnabled=true
zoomEnabled=true
EOF
    
    # Set space wallpaper if available
    if [[ -f /usr/share/wallpapers/Next/contents/images/1920x1080.jpg ]]; then
        cat > /home/commander/.config/plasma-org.kde.plasma.desktop-appletsrc << 'EOF'
[Containments][1][Wallpaper][org.kde.image][General]
Image=file:///usr/share/wallpapers/Next/contents/images/1920x1080.jpg
EOF
    fi
    
    # Set dark theme and space colors
    cat > /home/commander/.config/kdeglobals << 'EOF'
[ColorEffects:Disabled]
Color=56,56,56
ColorAmount=0
ColorEffect=0

[ColorEffects:Inactive]
ChangeSelectionColor=true
Color=112,111,110
ColorAmount=0.025000000000000001
ColorEffect=2

[Colors:Button]
BackgroundAlternate=64,69,82
BackgroundNormal=49,54,59
DecorationFocus=61,174,233
DecorationHover=61,174,233
ForegroundActive=61,174,233
ForegroundInactive=161,169,177
ForegroundLink=29,153,243
ForegroundNegative=218,68,83
ForegroundNeutral=246,116,0
ForegroundNormal=252,252,252
ForegroundPositive=39,174,96
ForegroundVisited=155,89,182

[Colors:Selection]
BackgroundAlternate=30,146,255
BackgroundNormal=61,174,233
DecorationFocus=61,174,233
DecorationHover=61,174,233
ForegroundActive=252,252,252
ForegroundInactive=161,169,177
ForegroundLink=253,188,75
ForegroundNegative=218,68,83
ForegroundNeutral=246,116,0
ForegroundNormal=252,252,252
ForegroundPositive=39,174,96
ForegroundVisited=155,89,182

[Colors:Window]
BackgroundAlternate=49,54,59
BackgroundNormal=35,38,41
DecorationFocus=61,174,233
DecorationHover=61,174,233
ForegroundActive=61,174,233
ForegroundInactive=161,169,177
ForegroundLink=29,153,243
ForegroundNegative=218,68,83
ForegroundNeutral=246,116,0
ForegroundNormal=252,252,252
ForegroundPositive=39,174,96
ForegroundVisited=155,89,182

[General]
ColorScheme=BreezeDark
Name=Breeze Dark
shadeSortColumn=true

[KDE]
contrast=4

[WM]
activeBackground=47,52,63
activeBlend=47,52,63
activeForeground=252,252,252
inactiveBackground=47,52,63
inactiveBlend=47,52,63
inactiveForeground=161,169,177
EOF
    
    # Set ownership
    chown -R commander:commander /home/commander/.config
    
    success "Space-themed desktop configuration completed"
    SUMMARY["Space Theme"]="Configured with dark theme, blur effects, and transparency"
}

configure_ssh_access() {
    mission "Configuring SSH server access..."
    
    # Install OpenSSH if not present
    safe_pacman "pacman -S --needed --noconfirm openssh"
    
    # Configure SSH daemon
    cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
    
    # Basic SSH configuration
    cat > /etc/ssh/sshd_config << 'EOF'
# ARK Core SSH Configuration
Port 22
Protocol 2
HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key
HostKey /etc/ssh/ssh_host_ed25519_key

# Authentication
LoginGraceTime 2m
PermitRootLogin no
StrictModes yes
MaxAuthTries 6
MaxSessions 10
PubkeyAuthentication yes
PasswordAuthentication yes
PermitEmptyPasswords no
ChallengeResponseAuthentication no
KerberosAuthentication no
GSSAPIAuthentication no
UsePAM yes

# Allow commander user
AllowUsers commander

# Logging
SyslogFacility AUTH
LogLevel INFO

# Network
X11Forwarding yes
X11DisplayOffset 10
PrintMotd no
PrintLastLog yes
TCPKeepAlive yes
ClientAliveInterval 60
ClientAliveCountMax 3

# SFTP
Subsystem sftp /usr/lib/ssh/sftp-server

# Banner
Banner /etc/ssh/banner
EOF
    
    # Create SSH banner
    cat > /etc/ssh/banner << 'EOF'
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
     🪐 ARK CORE ORBITAL COMMAND 🪐
      Welcome to the Admiral GUI
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Authorized access only.
All activities are monitored and logged.

Mission Control: ARK Orbital Admin Suite
EOF
    
    # Enable and start SSH service
    systemctl enable sshd
    systemctl restart sshd
    
    # Configure firewall for SSH
    if command -v ufw &> /dev/null; then
        ufw allow ssh
    elif command -v firewall-cmd &> /dev/null; then
        firewall-cmd --permanent --add-service=ssh
        firewall-cmd --reload
    fi
    
    success "SSH server configured and enabled"
    SUMMARY["SSH Access"]="Enabled on port 22 for commander user"
}

integrate_ark_tools() {
    mission "Integrating ARK Orbital Admin Suite tools..."
    
    # Copy ARK Orbital Admin Suite to commander's home
    cp -r "$(pwd)" /home/commander/ark-orbital-admin-suite
    chown -R commander:commander /home/commander/ark-orbital-admin-suite
    
    # Create desktop shortcut
    cat > /home/commander/Desktop/ARK-Orbital-Admin-Suite.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=ARK Orbital Admin Suite
Comment=Mission Control for Admin & Recovery Operations
Exec=konsole -e /home/commander/ark-orbital-admin-suite/install-admin-recovery-tools-v32.0.sh
Icon=applications-system
Terminal=false
Categories=System;Administration;
StartupNotify=true
EOF
    
    # Make desktop shortcut executable
    chmod +x /home/commander/Desktop/ARK-Orbital-Admin-Suite.desktop
    chown commander:commander /home/commander/Desktop/ARK-Orbital-Admin-Suite.desktop
    
    # Add to applications menu
    mkdir -p /home/commander/.local/share/applications
    cp /home/commander/Desktop/ARK-Orbital-Admin-Suite.desktop /home/commander/.local/share/applications/
    chown -R commander:commander /home/commander/.local
    
    # Create convenience aliases
    cat >> /home/commander/.bashrc << 'EOF'

# ARK Orbital Admin Suite aliases
alias ark-admin='cd ~/ark-orbital-admin-suite && sudo ./install-admin-recovery-tools-v32.0.sh'
alias ark-tools='cd ~/ark-orbital-admin-suite'
alias mission-control='cd ~/ark-orbital-admin-suite && sudo ./install-admin-recovery-tools-v32.0.sh'

# Welcome message
echo "🪐 Welcome to ARK Core, Commander!"
echo "Type 'ark-admin' to launch ARK Orbital Admin Suite"
echo "Type 'mission-control' for quick access to admin tools"
EOF
    
    success "ARK Orbital Admin Suite integration completed"
    SUMMARY["ARK Integration"]="Tools integrated with desktop shortcuts and aliases"
}

configure_auto_login() {
    mission "Configuring automatic login for commander..."
    
    # Configure SDDM for auto-login
    mkdir -p /etc/sddm.conf.d
    cat > /etc/sddm.conf.d/autologin.conf << 'EOF'
[Autologin]
User=commander
Session=plasma
EOF
    
    success "Auto-login configured for commander user"
}

configure_headless_setup() {
    mission "Configuring headless operation..."
    
    # Disable display manager for headless mode
    systemctl disable sddm 2>/dev/null || true
    
    # Configure automatic console login
    mkdir -p /etc/systemd/system/getty@tty1.service.d
    cat > /etc/systemd/system/getty@tty1.service.d/override.conf << 'EOF'
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin commander --noclear %I $TERM
EOF
    
    # Set multi-user target for headless
    systemctl set-default multi-user.target
    
    success "Headless operation configured"
    SUMMARY["Headless Mode"]="Configured for automatic console login"
}

# ---[ AUR Helper Entrypoint (after all function definitions!) ]---
if [[ "$1" == "--aur-helper-session" ]] && [[ $EUID -ne 0 ]]; then
    yay_aur_menu
    exit 0
fi

# ---[ LAUNCH MAIN MENU ]---
main_menu
