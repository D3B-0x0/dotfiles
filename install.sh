#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    print_error "This script must be run as root! Use sudo."
    exit 1
fi

print_status "Starting system setup..."

# Get actual user's home directory
USER_HOME=$(eval echo ~$SUDO_USER)
DOTFILES_DIR="$USER_HOME/.dotfiles"

# Install dependencies
print_status "Installing dependencies..."
pacman -Sy --noconfirm git curl gum

# Clone dotfiles in the actual user's home directory
if [ -d "$DOTFILES_DIR" ]; then
    print_status "Dotfiles directory already exists!"
    read -p "Do you want to remove it and clone again? (y/n): " REPLY
    if [[ "$REPLY" == "y" ]]; then
        rm -rf "$DOTFILES_DIR"
    else
        print_error "Dotfiles installation aborted."
        exit 1
    fi
fi

print_status "Cloning dotfiles repository to $DOTFILES_DIR..."
sudo -u $SUDO_USER git clone "https://github.com/D3B-0x0/dotfiles.git" "$DOTFILES_DIR"

# Ensure scripts are executable
chmod +x "$DOTFILES_DIR/installer/dotfiles.sh" "$DOTFILES_DIR/installer/packages.sh"

# Install dotfiles FIRST
print_status "Installing dotfiles..."
sudo -u $SUDO_USER bash "$DOTFILES_DIR/installer/dotfiles.sh"

# Install packages AFTER dotfiles
print_status "Installing packages..."
sudo -u $SUDO_USER bash "$DOTFILES_DIR/installer/packages.sh"

# Remove cloned repo AFTER everything is done
print_status "Cleaning up dotfiles repo..."
rm -rf "$DOTFILES_DIR"

print_success "System setup completed successfully! 🚀"
