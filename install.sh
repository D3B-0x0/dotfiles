#!/bin/bash

# Define script locations
DOTFILES_SCRIPT="/home/ghost/Downloads/dotfiles/installer/dotfiles.sh"
PACKAGES_SCRIPT="/home/ghost/Downloads/dotfiles/installer/packages.sh"

# Check for Gum
if ! command -v gum &>/dev/null; then
    echo -e "\033[0;31m[ERROR]\033[0m Gum is not installed!"
    read -p "Do you want to install Gum now? (y/n): " install_gum
    if [[ "$install_gum" =~ ^[Yy]$ ]]; then
        sudo pacman -S gum --noconfirm
    else
        echo -e "\033[0;31m[ERROR]\033[0m Gum is required for this script!"
        exit 1
    fi
fi

# Make scripts executable
gum style --border normal --margin "1" --padding "1" --border-foreground 212 " Making scripts executable..."
chmod +x "$DOTFILES_SCRIPT" "$PACKAGES_SCRIPT"
gum spin --spinner dot --title "Scripts are now executable" -- sleep 1

# Run package installation
gum confirm "Do you want to install packages?" && {
    gum style --border normal --margin "1" --padding "1" --border-foreground 212 " Installing packages..."
    sudo "$PACKAGES_SCRIPT" && gum style --border double --border-foreground 82 " Packages installed successfully!"
} || gum style --border normal --border-foreground 1 " Skipping package installation."

# Run dotfiles installation
gum confirm "Do you want to install dotfiles?" && {
    gum style --border normal --margin "1" --padding "1" --border-foreground 212 " Installing dotfiles..."
    "$DOTFILES_SCRIPT" && gum style --border double --border-foreground 82 " Dotfiles installed successfully!"
} || gum style --border normal --border-foreground 1 " Skipping dotfiles installation."

gum style --border normal --border-foreground 82 "Installation process completed! 🚀"
