#!/usr/bin/env bash
# ARK GitHub SSH Setup & Tester – System-wide

source "${ARK_CONFIG_PATH:-$HOME/.ark_config}"

ark_ssh_git_menu() {
    echo ""
    echo "🔑 ARK GitHub SSH Setup"
    echo "=============================="
    if [[ ! -f ~/.ssh/id_ed25519 ]]; then
        echo "🚀 Generating new SSH key for GitHub..."
        ssh-keygen -t ed25519 -C "${ARK_GITHUB_EMAIL:-ark@theark}" -f ~/.ssh/id_ed25519 -N ""
        echo ""
        echo "🔑 Public Key (copy to GitHub):"
        echo "════════════════════════════════════════════════════════════"
        cat ~/.ssh/id_ed25519.pub
        echo "════════════════════════════════════════════════════════════"
        echo ""
        echo "📋 Next steps:"
        echo "   1. Copy the key above"
        echo "   2. Go to GitHub → Settings → SSH and GPG keys"
        echo "   3. Click 'New SSH key', paste and save"
        read -p "Press Enter after adding to GitHub..."
    else
        echo "✅ SSH key already exists for GitHub use"
    fi

    cat > ~/.ssh/config << ARKEOF
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519
    AddKeysToAgent yes
ARKEOF
    chmod 600 ~/.ssh/config
    chmod 600 ~/.ssh/id_ed25519* 2>/dev/null || true
    eval "$(ssh-agent -s)" > /dev/null 2>&1
    ssh-add ~/.ssh/id_ed25519 2>/dev/null || true

    echo "🧪 Testing GitHub SSH connection..."
    if timeout 10 ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
        echo "✅ GitHub SSH connection successful!"
        echo "🌌 The ARK is connected to GitHub (system-wide, no password needed)."
        return 0
    else
        echo "⚠️  GitHub connection failed! Check:"
        echo "   - SSH key added to GitHub?"
        echo "   - Internet connectivity?"
        echo "   - Run this setup again if needed."
        return 1
    fi
}
