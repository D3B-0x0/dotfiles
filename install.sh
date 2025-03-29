#!/bin/bash

USER_HOME="$HOME"
DOTFILES_DIR="$USER_HOME/.dotfiles"
DOTFILES_REPO="https://github.com/D3B-0x0/dotfiles.git"

# Color functions
print_status() { echo -e "\e[34m[INFO]\e[0m $1"; }
print_success() { echo -e "\e[32m[SUCCESS]\e[0m $1"; }
print_error() { echo -e "\e[31m[ERROR]\e[0m $1"; exit 1; }

install_dependencies() {
    print_status "Installing dependencies..."
    sudo pacman -Syu --needed --noconfirm git curl || print_error "Failed to install dependencies"
    print_success "Dependencies installed"
}

clone_dotfiles() {
    print_status "Cloning dotfiles repository..."
    
    if [ -d "$DOTFILES_DIR" ]; then
        print_status "Dotfiles directory exists. Removing it..."
        rm -rf "$DOTFILES_DIR"
    fi

    git clone "$DOTFILES_REPO" "$DOTFILES_DIR" || print_error "Failed to clone dotfiles repository"

    if [ ! -d "$DOTFILES_DIR" ]; then
        print_error "Dotfiles directory not found after cloning!"
    fi

    print_success "Dotfiles cloned successfully"
}

install_dotfiles() {
    print_status "Running dotfiles installation..."

    DOTFILES_SCRIPT="$DOTFILES_DIR/installer/dotfiles.sh"

    if [ ! -f "$DOTFILES_SCRIPT" ]; then
        print_error "dotfiles.sh not found in $DOTFILES_DIR/installer!"
    else
        print_status "Found dotfiles.sh at $DOTFILES_SCRIPT"
        chmod +x "$DOTFILES_SCRIPT"
        bash "$DOTFILES_SCRIPT" || print_error "Dotfiles installation failed"
    fi

    print_success "Dotfiles installed successfully"
}

install_packages() {
    print_status "Installing packages..."

    PACKAGES_SCRIPT="$DOTFILES_DIR/installer/packages.sh"

    if [ ! -f "$PACKAGES_SCRIPT" ]; then
        print_error "packages.sh not found in $DOTFILES_DIR/installer!"
    else
        print_status "Found packages.sh at $PACKAGES_SCRIPT"
        chmod +x "$PACKAGES_SCRIPT"
        bash "$PACKAGES_SCRIPT" || print_error "Package installation failed"
    fi

    print_success "Packages installed successfully"
}

main() {
    print_status "Starting setup..."
    install_dependencies
    clone_dotfiles
    install_dotfiles
    install_packages
    print_success "Setup complete!"
}

main
