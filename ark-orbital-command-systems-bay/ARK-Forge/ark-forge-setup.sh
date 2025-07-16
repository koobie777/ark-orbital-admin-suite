#!/usr/bin/env bash
# ╭─────────────────────────────────────────────╮
# │         THE ARK-Forge LAUNCHER              │
# │   Smart ARK Ecosystem Session Manager       │
# │           Commander: koobie777              │
# │         The ARK Supreme Mk1                 │
# ╰─────────────────────────────────────────────╯

CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
PURPLE='\033[0;35m'
NC='\033[0m'

ARK_SESSION="ark-forge"
ARK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ARK Banner
echo -e "${CYAN}═══════════════════════════════════════════════${NC}"
echo -e "${CYAN}         🛰️ THE ARK ECOSYSTEM LAUNCHER         ${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════${NC}"

# Check if we're already in the ARK tmux session
if [[ -n "$TMUX" ]]; then
    session_name=$(tmux display-message -p '#S')
    if [[ "$session_name" == "$ARK_SESSION" ]]; then
        # Already in ARK-Forge session, just run arkforge
        exec "$ARK_DIR/arkforge.sh"
    fi
fi

# Check if ARK-Forge session exists
if tmux has-session -t "$ARK_SESSION" 2>/dev/null; then
    echo -e "${CYAN}🛰️ ARK-Forge Session detected${NC}"

    # Check for active builds
    build_windows=$(tmux list-windows -t "$ARK_SESSION" -F "#W" | grep -E "(build|sync)" | wc -l)

    if [[ $build_windows -gt 0 ]]; then
        echo -e "${YELLOW}Active ARK-Forge operations found:${NC}"
        tmux list-windows -t "$ARK_SESSION" -F "  • #W" | grep -E "(build|sync)"
        echo ""
    fi

    echo -e "${GREEN}ARK-Forge Options:${NC}"
    echo "  1) Attach to existing ARK-Forge session"
    echo "  2) Create new window in ARK-Forge session"
    echo "  3) Kill session and start fresh"
    echo "  4) Run ARK-Forge without tmux"
    echo ""
    read -p "Select option (1-4): " choice

    case $choice in
        1)
            exec tmux attach-session -t "$ARK_SESSION"
            ;;
        2)
            tmux new-window -t "$ARK_SESSION" -c "$ARK_DIR" "$ARK_DIR/arkforge.sh"
            exec tmux attach-session -t "$ARK_SESSION"
            ;;
        3)
            tmux kill-session -t "$ARK_SESSION"
            echo -e "${YELLOW}🛰️ Restarting ARK-Forge...${NC}"
            sleep 1
            exec tmux new-session -s "$ARK_SESSION" -c "$ARK_DIR" "$ARK_DIR/arkforge.sh"
            ;;
        4)
            exec "$ARK_DIR/arkforge.sh"
            ;;
        *)
            echo -e "${RED}Invalid option - The ARK cannot comply${NC}"
            exit 1
            ;;
    esac
else
    # No session exists, create new one
    echo -e "${CYAN}🛰️ Initializing The ARK-Forge Ecosystem...${NC}"
    echo -e "${GREEN}✅ ARK-Forge privileges cached for session${NC}"
    echo -e "${PURPLE}🌌 ARK-Forge is ready, Commander!${NC}"
    sleep 1
    exec tmux new-session -s "$ARK_SESSION" -c "$ARK_DIR" "$ARK_DIR/arkforge.sh"
fi
