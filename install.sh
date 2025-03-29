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
DOTFILES_REPO="https://github.com/D3B-0x0/dotfiles.git"
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

# Clone dotfiles repository
clone_dotfiles() {
    if [ -d "$DOTFILES_DIR" ]; then
        print_warning "Dotfiles directory already exists!"
        while true; do
            read -r -p "Do you want to remove it and clone again? (y/n): " choice
            choice=$(echo "$choice" | tr '[:upper:]' '[:lower:]')
            case "$choice" in
                y) rm -rf "$DOTFILES_DIR"; break ;;
                n) print_error "Dotfiles already exist, but script may fail. Exiting."; exit 1 ;;
                *) echo "Invalid input, please enter y or n." ;;
            esac
        done
    fi

    print_status "Cloning dotfiles repository..."
    sudo -u "$USERNAME" git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
    
    if [ $? -eq 0 ]; then
        print_success "Dotfiles cloned successfully"
    else
        print_error "Failed to clone repository!"
        exit 1
    fi
}

# Run dotfiles installation
install_dotfiles() {
    print_status "Running dotfiles installation..."
    
    if [ ! -f "$DOTFILES_SCRIPT" ]; then
        print_error "dotfiles.sh not found! Something went wrong with cloning."
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
    clone_dotfiles  # Now ensures dotfiles exist
    install_dotfiles
    install_packages

    print_success "System setup complete!"
}

# Run only if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi
