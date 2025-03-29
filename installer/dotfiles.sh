#!/bin/bash

# Get the actual user
if [[ -n "$SUDO_USER" ]]; then
    USER_HOME=$(eval echo ~$SUDO_USER)
    USERNAME="$SUDO_USER"
else
    USER_HOME="$HOME"
    USERNAME="$USER"
fi

DOTFILES_DIR="$USER_HOME/.dotfiles"
CONFIG_DIR="$USER_HOME/.config"
GITHUB_REPO="https://github.com/D3B-0x0/dotfiles.git"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m'

print_status() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }

# Backup configs
backup_configs() {
    local backup_dir="$USER_HOME/.config_backup_$(date +%Y%m%d_%H%M%S)"
    print_status "Backing up existing configs to $backup_dir"
    mkdir -p "$backup_dir"
    
    for config in "$CONFIG_DIR"/*; do
        [ -e "$config" ] && mv "$config" "$backup_dir/"
    done

    print_success "Backup completed"
}

# Clone dotfiles repo
clone_dotfiles() {
    if [ -d "$DOTFILES_DIR" ]; then
        print_warning "Dotfiles directory already exists!"
        read -rp "Remove it and clone again? (y/n): " choice
        case "$choice" in
            y) rm -rf "$DOTFILES_DIR" ;;
            n) return ;;
        esac
    fi

    print_status "Cloning dotfiles..."
    sudo -u "$USERNAME" git clone "$GITHUB_REPO" "$DOTFILES_DIR"
    
    if [ $? -eq 0 ]; then
        print_success "Dotfiles cloned"
    else
        print_error "Failed to clone repo!"
        exit 1
    fi
}

# Install configs
install_configs() {
    print_status "Installing config files..."
    
    # Ensure .config exists
    sudo -u "$USERNAME" mkdir -p "$CONFIG_DIR"

    # Use rsync to preserve permissions and ensure all files are copied
    sudo -u "$USERNAME" rsync -av "$DOTFILES_DIR/.config/" "$CONFIG_DIR/"

    print_success "Configs installed!"
}

# Main function
install_dotfiles() {
    print_status "Starting dotfiles setup..."

    if ! command -v git &>/dev/null; then
        print_error "Git is not installed!"
        exit 1
    fi

    read -rp "Backup existing configs? (y/n): " do_backup
    [[ "$do_backup" =~ ^[Yy]$ ]] && backup_configs

    clone_dotfiles
    install_configs

    print_success "Dotfiles installation complete!"
}

# Run only if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_dotfiles
fi
