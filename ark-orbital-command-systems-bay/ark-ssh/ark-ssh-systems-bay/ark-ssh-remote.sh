#!/usr/bin/env bash
# ARK Remote SSH Setup & Guided Security

source "${ARK_CONFIG_PATH:-$HOME/.ark_config}"

ark_ssh_remote_menu() {
    echo ""
    echo "🛰️  ARK Remote Terminal SSH Setup"
    echo "=================================="

    read -p "Enter remote user (default: ${ARK_REMOTE_USER:-commander}): " remote_user
    remote_user="${remote_user:-${ARK_REMOTE_USER:-commander}}"
    read -p "Enter remote host (default: ${ARK_REMOTE_HOST:-your-remote}): " remote_host
    remote_host="${remote_host:-${ARK_REMOTE_HOST:-your-remote}}"

    if [[ ! -f ~/.ssh/id_ed25519 ]]; then
        echo "🔒 Generating SSH keypair..."
        ssh-keygen -t ed25519 -C "${ARK_GITHUB_EMAIL:-ark@theark}" -f ~/.ssh/id_ed25519 -N ""
    fi

    echo "🚀 Copying public key to remote host..."
    ssh-copy-id -i ~/.ssh/id_ed25519 "$remote_user@$remote_host"

    echo "🛡️  Recommended: Disable password login on the remote server for maximum security."
    echo "  - You must have sudo privileges on the remote."
    read -p "Harden remote SSH config (disables password login)? (y/n): " harden_remote
    if [[ "$harden_remote" =~ ^[Yy]$ ]]; then
        ssh "$remote_user@$remote_host" "sudo sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config && sudo systemctl reload sshd"
        echo "✅ Remote SSH password login disabled."
    fi

    echo "🧪 Testing remote SSH connection..."
    if timeout 10 ssh -o BatchMode=yes "$remote_user@$remote_host" "echo 'Connected'" 2>&1 | grep -q "Connected"; then
        echo "✅ Remote SSH connection successful!"
    else
        echo "⚠️  Remote SSH connection failed! Check network, key, and user settings."
    fi
}
