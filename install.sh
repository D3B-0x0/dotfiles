#!/bin/bash

# Detect real user if running via sudo
if [[ -n "$SUDO_USER" ]]; then
    USER_HOME=$(eval echo ~$SUDO_USER)
    USERNAME="$SUDO_USER"
else
    USER_HOME="$HOME"
    USERNAME="$USER"
fi

DOTFILES_DIR="$USER_HOME/.dotfiles"
DOTFILES_SCRIPT="$DOTFILES_DIR/dotfiles.sh"
PACKAGES_SCRIPT="$DOTFILES_DIR/packages.sh"

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

# Run dotfiles installation
install_dotfiles() {
    print_status "Running dotfiles installation..."
    
    if [ ! -f "$DOTFILES_SCRIPT" ]; then
        print_error "dotfiles.sh not found! Make sure the repo is cloned."
        exit 1
    fi
    
    sudo -u "$USERNAME" bash "$DOTFILES_SCRIPT"
}

# Run package installation
install_packages() {
    print_status "Running package installation..."
    
    if [ -f "$PACKAGES_SCRIPT" ]; then
        sudo -u "$USERNAME" bash "$PACKAGES_SCRIPT"
        print_success "Packages installed"
    else
        print_warning "packages.sh not found! Skipping package installation."
    fi
}

# Main function
main() {
    print_status "Starting system setup..."
    
    install_dependencies
    install_dotfiles
    install_packages

    print_success "System setup complete!"
}

# Run only if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi
