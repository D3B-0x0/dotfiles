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
    
    if [ ! -f "$DOTFILES_DIR/dotfiles.sh" ]; then
        print_error "dotfiles.sh not found!"
    fi

    chmod +x "$DOTFILES_DIR/dotfiles.sh"
    bash "$DOTFILES_DIR/dotfiles.sh" || print_error "Dotfiles installation failed"

    print_success "Dotfiles installed successfully"
}

main() {
    print_status "Starting setup..."
    install_dependencies
    clone_dotfiles
    install_dotfiles
    print_success "Setup complete!"
}

main
