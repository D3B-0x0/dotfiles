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

# Install dependencies
print_status "Installing dependencies..."
pacman -Sy --noconfirm git curl gum || { print_error "Failed to install dependencies."; exit 1; }

# Clone dotfiles repo (Prevent double cloning)
DOTFILES_DIR="$HOME/.dotfiles"
if [ -d "$DOTFILES_DIR/.git" ]; then
    print_status "Dotfiles directory already exists. Pulling latest changes..."
    git -C "$DOTFILES_DIR" pull || { print_error "Failed to update dotfiles."; exit 1; }
else
    print_status "Cloning dotfiles repository..."
    git clone --depth=1 "https://github.com/D3B-0x0/dotfiles.git" "$DOTFILES_DIR" || { print_error "Failed to clone dotfiles."; exit 1; }
fi

# Ensure scripts are executable
chmod +x "$DOTFILES_DIR/installer/dotfiles.sh" "$DOTFILES_DIR/installer/packages.sh" || { print_error "Failed to make scripts executable."; exit 1; }

# Add Chaotic AUR Repository if missing
if ! grep -q "\[chaotic-aur\]" /etc/pacman.conf; then
    print_status "Adding Chaotic AUR repository..."
    pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
    pacman-key --lsign-key 3056513887B78AEB
    pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
    pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
    echo -e "\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" | tee -a /etc/pacman.conf
    print_success "Chaotic AUR added successfully!"
else
    print_status "Chaotic AUR already added. Skipping..."
fi

# Add BlackArch Repository if missing
if ! pacman -Q blackarch-keyring &>/dev/null; then
    print_status "Adding BlackArch repository..."
    curl -O https://blackarch.org/strap.sh || { print_error "Failed to download BlackArch setup script."; exit 1; }
    sha1sum strap.sh | grep -q "86eb4efb68918dbfdd1e22862a48fda20a8145ff" || { print_error "SHA1 checksum failed!"; rm strap.sh; exit 1; }
    chmod +x strap.sh
    ./strap.sh || { print_error "BlackArch installation failed."; exit 1; }
    rm strap.sh
    print_success "BlackArch repo added successfully!"
else
    print_status "BlackArch repo already added. Skipping..."
fi

# Full system update
print_status "Updating system..."
pacman -Syu --noconfirm || { print_error "System update failed."; exit 1; }

# Run dotfiles and package installer
print_status "Running dotfiles and package installation..."
bash "$DOTFILES_DIR/installer/dotfiles.sh" || { print_error "Dotfiles installation failed."; exit 1; }
bash "$DOTFILES_DIR/installer/packages.sh" || { print_error "Package installation failed."; exit 1; }

print_success "System setup completed successfully! 🚀"
