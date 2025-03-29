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
USER_HOME=$(getent passwd $SUDO_USER | cut -d: -f6)
DOTFILES_DIR="$USER_HOME/.dotfiles"

# Install dependencies
print_status "Installing dependencies..."
pacman -Sy --noconfirm git curl gum

# Clone dotfiles in the user's home directory
if [ -d "$DOTFILES_DIR" ]; then
    print_status "Dotfiles directory already exists. Removing old one..."
    rm -rf "$DOTFILES_DIR"
fi

print_status "Cloning dotfiles repository to $DOTFILES_DIR..."
sudo -u $SUDO_USER git clone "https://github.com/D3B-0x0/dotfiles.git" "$DOTFILES_DIR"

# Ensure scripts are executable
chmod +x "$DOTFILES_DIR/installer/dotfiles.sh" "$DOTFILES_DIR/installer/packages.sh"

# Install dotfiles FIRST
print_status "Installing dotfiles..."
if [ -f "$DOTFILES_DIR/installer/dotfiles.sh" ]; then
    sudo -u $SUDO_USER bash "$DOTFILES_DIR/installer/dotfiles.sh"
    print_success "Dotfiles installed successfully!"
else
    print_error "Dotfiles installation script not found!"
    exit 1
fi

# Install packages AFTER dotfiles
print_status "Installing packages..."
if [ -f "$DOTFILES_DIR/installer/packages.sh" ]; then
    sudo -u $SUDO_USER bash "$DOTFILES_DIR/installer/packages.sh"
    print_success "Packages installed successfully!"
else
    print_error "Package installation script not found!"
    exit 1
fi

# Remove cloned repo AFTER everything is done
print_status "Cleaning up dotfiles repo..."
rm -rf "$DOTFILES_DIR"
print_success "Cleanup completed!"

print_success "System setup completed successfully! 🚀"
