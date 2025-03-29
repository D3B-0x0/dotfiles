#!/bin/bash

DOTFILES_DIR="$HOME/.dotfiles"
GITHUB_REPO="https://github.com/D3B-0x0/dotfiles.git"
CONFIG_DIR="$HOME/.config"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Backup existing configs
backup_configs() {
    local backup_dir="$HOME/.config_backup_$(date +%Y%m%d_%H%M%S)"
    print_status "Creating backup of existing configs in $backup_dir"

    mkdir -p "$backup_dir"

    local configs=(
        "ags" "alacritty" "background" "bat" "btop" "cava"
        "chrome-flags.conf" "code-flags.conf" "fastfetch" "fish"
        "fontconfig" "foot" "fuzzel" "hypr" "hyprpanel" "kitty"
        "mpv" "neofetch" "nvim" "qt5ct" "spicetify.bak"
        "starship.toml" "thorium-flags.conf" "tmux" "wezterm"
        "wlogout" "yazi" "yt-dlp" "yt-x" "zathura" "zed"
        "zshrc.d"
    )

    for config in "${configs[@]}"; do
        if [ -e "$CONFIG_DIR/$config" ]; then
            mkdir -p "$backup_dir/$(dirname "$config")"  # Ensure parent directory exists
            mv -f "$CONFIG_DIR/$config" "$backup_dir/"
            print_status "Backed up: $config"
        fi
    done

    print_success "Backup completed"
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
                n) exit 1 ;;
                *) echo "Invalid input, please enter y or n." ;;
            esac
        done
    fi

    print_status "Cloning dotfiles repository..."
    git clone "$GITHUB_REPO" "$DOTFILES_DIR"
    if [ $? -eq 0 ]; then
        print_success "Dotfiles cloned successfully"
    else
        print_error "Failed to clone repository!"
        exit 1
    fi
}

# Copy dotfiles to .config
install_configs() {
    print_status "Installing config files..."

    mkdir -p "$CONFIG_DIR"

    local configs=(
        "ags" "alacritty" "background" "bat" "btop" "cava"
        "chrome-flags.conf" "code-flags.conf" "fastfetch" "fish"
        "fontconfig" "foot" "fuzzel" "hypr" "hyprpanel" "kitty"
        "mpv" "neofetch" "nvim" "qt5ct" "spicetify.bak"
        "starship.toml" "thorium-flags.conf" "tmux" "wezterm"
        "wlogout" "yazi" "yt-dlp" "yt-x" "zathura" "zed"
        "zshrc.d"
    )

    for config in "${configs[@]}"; do
        if [ -d "$DOTFILES_DIR/.config/$config" ] || [ -f "$DOTFILES_DIR/.config/$config" ]; then
            cp -r "$DOTFILES_DIR/.config/$config" "$CONFIG_DIR/"
            print_status "Installed: $config"
        else
            print_warning "Source not found: $config"
        fi
    done

    print_success "Config files installed successfully"
}

# Clean up downloaded repository
cleanup() {
    print_status "Cleaning up..."
    rm -rf "$DOTFILES_DIR"
    print_success "Cleanup completed"
}

# Main function for dotfiles installation
install_dotfiles() {
    print_status "Starting dotfiles installation..."

    if ! command -v git &>/dev/null; then
        print_error "Git is not installed!"
        exit 1
    fi

    while true; do
        read -r -p "Do you want to backup existing configs? (y/n): " do_backup
        do_backup=$(echo "$do_backup" | tr '[:upper:]' '[:lower:]')
        case "$do_backup" in
            y) backup_configs; break ;;
            n) break ;;
            *) echo "Invalid input, please enter y or n." ;;
        esac
    done

    clone_dotfiles
    install_configs

    while true; do
        read -r -p "Remove downloaded repository? (y/n): " do_cleanup
        do_cleanup=$(echo "$do_cleanup" | tr '[:upper:]' '[:lower:]')
        case "$do_cleanup" in
            y) cleanup; break ;;
            n) break ;;
            *) echo "Invalid input, please enter y or n." ;;
        esac
    done

    print_success "Dotfiles installation completed!"
}

# Allow running as standalone script or being sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_dotfiles
fi
