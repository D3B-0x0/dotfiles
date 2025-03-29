#!/bin/bash

# Detect user (for sudo cases)
if [[ -n "$SUDO_USER" ]]; then
    USER_HOME=$(eval echo ~$SUDO_USER)
    USERNAME="$SUDO_USER"
else
    USER_HOME="$HOME"
    USERNAME="$USER"
fi

DOTFILES_DIR="$USER_HOME/.dotfiles"
DOTFILES_REPO="https://github.com/D3B-0x0/dotfiles.git"
DOTFILES_SCRIPT="$DOTFILES_DIR/dotfiles.sh"
LOG_FILE="/tmp/dotfiles_install.log"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m'

print_status() { echo -e "${BLUE}[INFO]${NC} $1" | tee -a "$LOG_FILE"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1" | tee -a "$LOG_FILE"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1" | tee -a "$LOG_FILE"; }

# Ensure script runs as root
if [ "$EUID" -ne 0 ]; then
    print_error "This script must be run as root!"
    exit 1
fi

# Install dependencies
install_dependencies() {
    print_status "Installing dependencies..."
    pacman -Syu --needed --noconfirm git curl gum
    print_success "Dependencies installed"
}

# Clone dotfiles repository
clone_dotfiles() {
    print_status "Cloning dotfiles repository..."
    
    if [ -d "$DOTFILES_DIR" ]; then
        print_warning "Dotfiles directory already exists. Deleting and recloning..."
        rm -rf "$DOTFILES_DIR"
    fi

    sudo -u "$USERNAME" git clone "$DOTFILES_REPO" "$DOTFILES_DIR" 2>&1 | tee -a "$LOG_FILE"
    
    if [ ! -f "$DOTFILES_SCRIPT" ]; then
        print_error "dotfiles.sh still not found after cloning! Check logs: $LOG_FILE"
        exit 1
    fi

    print_success "Dotfiles cloned successfully"
}

# Run dotfiles installation
install_dotfiles() {
    print_status "Running dotfiles installation..."
    
    if [ ! -f "$DOTFILES_SCRIPT" ]; then
        print_error "dotfiles.sh not found! Check clone process."
        exit 1
    fi

    chmod +x "$DOTFILES_SCRIPT"
    sudo -u "$USERNAME" bash "$DOTFILES_SCRIPT" 2>&1 | tee -a "$LOG_FILE"
}

# Main function
main() {
    print_status "Starting system setup..."
    
    install_dependencies
    clone_dotfiles
    install_dotfiles

    print_success "System setup complete!"
}

# Run only if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi
