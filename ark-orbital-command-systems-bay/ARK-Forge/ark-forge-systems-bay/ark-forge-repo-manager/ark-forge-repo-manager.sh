#!/usr/bin/env bash
# ╭─────────────────────────────────────────────────────────────╮
# │ ARK REPO MANAGER v3.2 – Multi-Source, Device-First, Modular│
# │ Commander: koobie777        Date: $(date -u)                │
# ╰─────────────────────────────────────────────────────────────╯

# ---- ARK CONSTANTS & COLORS ----
NC='\033[0m'
ARK_ACCENT='\033[1;36m'
ARK_SUCCESS='\033[1;32m'
ARK_INFO='\033[1;34m'
ARK_ERROR='\033[0;31m'

ARK_MODE="${ARK_MODE:-Expert}"

# ---- ARK FLEET DEVICES ----
ARK_DEVICE_LIST=("waffle" "op515dl1") # Extend as needed

# ---- OPTIONAL ROMS (Not Required) ----
declare -A ARK_ROMS=(
    [yaap]="Yet Another AOSP Project"
    [aio]="All-In-One ROM"
    # Add or remove as needed; leave empty for device-only
)

# ---- ARK MENU BANNER ----
ark_repo_manager_banner() {
cat <<EOF

╭─────────────────────────────────────────────────────────────╮
│                🛰️ ARK REPOSITORY MANAGER v3.2               │
│           Multi-Source, Device-First, Modular Protocol      │
│ Commander: $USER      Mode: $ARK_MODE                       │
╰─────────────────────────────────────────────────────────────╯

Purpose: Unified source management for all device sources in The ARK.
Select your device, optionally pick a ROM, or leave blank to only manage
device sources for recovery/device testing or template exploration.

EOF
}

# ---- DEVICE SELECTOR ----
select_ark_device() {
    echo -e "${ARK_ACCENT}🛰️  Available ARK Fleet devices:${NC}"
    local i=1
    for d in "${ARK_DEVICE_LIST[@]}"; do
        echo "  $i) $d"
        ((i++))
    done
    read -p "Select device (number, default: 1): " dev_idx
    dev_idx=${dev_idx:-1}
    export ARK_DEVICE="${ARK_DEVICE_LIST[$((dev_idx-1))]}"
    echo -e "${ARK_INFO}🛰️  Selected device: $ARK_DEVICE${NC}"
}

# ---- OPTIONAL ROM SELECTOR ----
select_ark_rom() {
    local rom_count=${#ARK_ROMS[@]}
    if [[ "$rom_count" -eq 0 ]]; then
        ARK_ROM=""
        return
    fi

    echo -e "${ARK_ACCENT}🛰️  Available ROM projects (optional):${NC}"
    echo "  0) None (Device sources only: recovery, template, etc)"
    local i=1
    for rom in "${!ARK_ROMS[@]}"; do
        echo "  $i) $rom - ${ARK_ROMS[$rom]}"
        ((i++))
    done
    read -p "Select ROM (number, default: 0): " rom_idx
    rom_idx=${rom_idx:-0}
    if [[ "$rom_idx" == "0" ]]; then
        export ARK_ROM=""
        echo -e "${ARK_INFO}🛰️  No ROM selected (device sources/recovery/template mode)${NC}"
    else
        export ARK_ROM=$(echo "${!ARK_ROMS[@]}" | cut -d' ' -f$rom_idx)
        echo -e "${ARK_INFO}🛰️  Selected ROM: $ARK_ROM${NC}"
    fi
}

# ---- INTELLIGENCE FETCH (ROM OPTIONAL) ----
fetch_ark_repo_branches() {
    echo -e "${ARK_ACCENT}🛰️  Gathering live branch/source intelligence for device: $ARK_DEVICE${NC}"
    if [[ -n "$ARK_ROM" ]]; then
        python3 modules/ark-repo-intel.py "$ARK_ROM" "$ARK_DEVICE" > /tmp/ark_branches.json
    else
        python3 modules/ark-repo-intel.py "device-only" "$ARK_DEVICE" > /tmp/ark_branches.json
    fi
    if [[ $? -ne 0 ]]; then
        echo -e "${ARK_ERROR}⚠️ [FETCH ERROR]
Location: Branch Metadata
Fix: Check python script and network access.
I'll guide you, Commander.${NC}"
        return 1
    fi
}

# ---- ADVANCED BRANCH SELECTION MENU ----
present_branch_matrix_menu() {
    echo -e "${ARK_ACCENT}🛰️  Branch Matrix for ${ARK_ROM:-Device Sources Only} on $ARK_DEVICE:${NC}"
    jq -r '.[] | "\(.idx)) \(.branch) | Android: \(.android) | Kernel: \(.kernel) | Status: \(.status) | Notes: \(.notes)"' /tmp/ark_branches.json

    echo -e "\n${ARK_ACCENT}How would you like to choose a branch?${NC}"
    echo "  1) Use latest branch (highest idx)"
    echo "  2) Use 'sixteen' branch if available"
    echo "  3) Manually select by number"
    read -p "Selection (default: 1): " branch_mode
    branch_mode=${branch_mode:-1}

    local branch_idx=""
    if [[ "$branch_mode" == "2" ]]; then
        branch_idx=$(jq '.[] | select(.branch=="sixteen") | .idx' /tmp/ark_branches.json)
        if [[ -z "$branch_idx" ]]; then
            echo -e "${ARK_ERROR}'sixteen' branch not found, defaulting to latest.${NC}"
            branch_idx=$(jq '.[].idx' /tmp/ark_branches.json | sort -nr | head -n1)
        fi
    elif [[ "$branch_mode" == "3" ]]; then
        read -p "Enter branch number: " branch_idx
    else
        branch_idx=$(jq '.[].idx' /tmp/ark_branches.json | sort -nr | head -n1)
    fi
    branch_idx="${branch_idx:-1}"

    # Extract selected branch (export for downstream use)
    branch=$(jq -r ".[] | select(.idx==$branch_idx) | .branch" /tmp/ark_branches.json)
    export ARK_BRANCH="$branch"
    echo -e "${ARK_SUCCESS}🛰️  Selected branch: $ARK_BRANCH${NC}"
}

# ---- PROMPT FOR COMPLETENESS ----
prompt_repo_completeness() {
    echo -e "${ARK_ACCENT}Repository Completeness for $ARK_BRANCH:${NC}"
    echo -e "  1) ${ARK_SUCCESS}Essential${NC} - Minimum for builds"
    echo -e "  2) ${ARK_INFO}Recommended${NC} - Better success"
    echo -e "  3) ${ARK_ACCENT}Complete${NC} - Full features"
    read -p "Select completeness (default: 2-Recommended): " completeness
    export ARK_COMPLETENESS=${completeness:-2}
}

# ---- SUMMARY ----
show_configuration_summary() {
    echo -e "\n${ARK_INFO}═══ ARK CONFIGURATION SUMMARY ═══${NC}"
    echo -e "Device: $ARK_DEVICE"
    echo -e "ROM: ${ARK_ROM:-None (device-only mode)}"
    echo -e "Branch: $ARK_BRANCH"
    echo -e "Completeness: $ARK_COMPLETENESS"
    # TODO: Add more details from /tmp/ark_branches.json as desired
}

# ---- SYNC PROMPT ----
ark_sync_repos_prompt() {
    echo -e "${ARK_INFO}🚦 Initiating repo sync for ${ARK_ROM:-Device Sources} ($ARK_BRANCH)...${NC}"
    if command -v repo &>/dev/null; then
        # TODO: Use ARK_ROM/ARK_BRANCH/ARK_DEVICE to build repo init command
        echo "repo init -u <manifest-url> -b $ARK_BRANCH"
        echo "repo sync ... (this is a stub)"
        # Implement full repo URL logic per ROM/device
    else
        echo -e "${ARK_ERROR}⚠️ [MISSING DEPENDENCY]
Location: Repository Sync
Fix: Install Google's 'repo' tool (https://source.android.com/setup/develop/repo)
I'll guide you, Commander.${NC}"
    fi
}

# ---- ARK RETURN ----
ark_return_main_menu() {
    echo
    read -p "$(echo -e "${ARK_ACCENT}Press Enter to return to ARK Main Menu...${NC}")"
    echo -e "${ARK_ACCENT}Returning to ARK Main Menu...${NC}"
    sleep 1
    if [[ -n "$TMUX" && -f "./arkforge-launcher" ]]; then
        ./arkforge-launcher
    else
        echo -e "${ARK_INFO}Not in tmux or launcher missing. Please relaunch ARKFORGE if needed.${NC}"
    fi
}

# ---- MAIN ----
ark_repo_manager_main() {
    clear
    ark_repo_manager_banner
    select_ark_device
    select_ark_rom
    fetch_ark_repo_branches || ark_return_main_menu
    present_branch_matrix_menu
    prompt_repo_completeness
    show_configuration_summary
    read -p "$(echo -e "${ARK_ACCENT}🛰️  Sync repositories now? (Y/n): ${NC}")" sync_now
    if [[ ! "${sync_now,,}" =~ ^(n|no)$ ]]; then
        ark_sync_repos_prompt
    fi
    ark_return_main_menu
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    ark_repo_manager_main
fi
