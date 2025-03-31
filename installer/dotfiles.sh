#!/bin/bash
# Improved dotfiles installer script

# Get the actual user
if [[ -n "$SUDO_USER" ]]; then
    USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
    USERNAME="$SUDO_USER"
else
    USER_HOME="$HOME"
    USERNAME="$USER"
fi

DOTFILES_DIR="$USER_HOME/.dotfiles"
CONFIG_DIR="$USER_HOME/.config"
GITHUB_REPO="https://github.com/D3B-0x0/dotfiles.git"

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

# Check for required commands
check_requirements() {
    for cmd in git rsync; do
        if ! command -v "$cmd" &>/dev/null; then
            print_error "$cmd is not installed!"
            exit 1
        fi
    done
}

# Backup configs
backup_configs() {
    local backup_dir="$USER_HOME/.config_backup_$(date +%Y%m%d_%H%M%S)"
    print_status "Backing up existing configs to $backup_dir"
    
    if [[ -d "$CONFIG_DIR" ]]; then
        mkdir -p "$backup_dir"
        if sudo -u "$USERNAME" rsync -a "$CONFIG_DIR/" "$backup_dir/"; then
            print_success "Backup completed"
        else
            print_error "Backup failed!"
            exit 1
        fi
    else
        print_warning "No existing config directory found. Skipping backup."
    fi
}

# Clone dotfiles repo
clone_dotfiles() {
    if [[ -d "$DOTFILES_DIR" ]]; then
        if [[ -d "$DOTFILES_DIR/.git" ]]; then
            print_warning "Dotfiles repository already exists!"
            read -rp "Update existing repo instead of re-cloning? (y/n): " update_choice
            if [[ "$update_choice" =~ ^[Yy]$ ]]; then
                print_status "Updating existing dotfiles repository..."
                (cd "$DOTFILES_DIR" && sudo -u "$USERNAME" git pull)
                if [[ $? -eq 0 ]]; then
                    print_success "Dotfiles repository updated"
                    return 0
                else
                    print_error "Failed to update repository!"
                fi
            fi
        fi
        
        read -rp "Remove existing dotfiles directory and clone again? (y/n): " choice
        if [[ "$choice" =~ ^[Yy]$ ]]; then
            rm -rf "$DOTFILES_DIR"
        else
            return 0
        fi
    fi
    
    print_status "Cloning dotfiles..."
    if sudo -u "$USERNAME" git clone "$GITHUB_REPO" "$DOTFILES_DIR"; then
        print_success "Dotfiles cloned successfully"
    else
        print_error "Failed to clone repository!"
        exit 1
    fi
}

# Install configs
install_configs() {
    print_status "Installing config files..."
    
    # Ensure .config exists
    sudo -u "$USERNAME" mkdir -p "$CONFIG_DIR"
    
    # Check if .config directory exists in the dotfiles repo
    if [[ -d "$DOTFILES_DIR/.config" ]]; then
        config_source="$DOTFILES_DIR/.config/"
    elif [[ -d "$DOTFILES_DIR/config" ]]; then
        config_source="$DOTFILES_DIR/config/"
    else
        print_error "Could not find config directory in the dotfiles repository!"
        print_status "Please check your repository structure."
        exit 1
    fi
    
    # Use rsync to preserve permissions and ensure all files are copied
    if sudo -u "$USERNAME" rsync -av --no-owner --no-group "$config_source" "$CONFIG_DIR/"; then
        print_success "Configs installed successfully!"
    else
        print_error "Failed to install configs!"
        exit 1
    fi
    
    # Make executable files actually executable
    find "$CONFIG_DIR" -type f -name "*.sh" -exec chmod +x {} \;
}

# Post-install actions
post_install() {
    # Check if there's a post-install script and run it if it exists
    if [[ -f "$DOTFILES_DIR/post-install.sh" ]]; then
        print_status "Running post-installation script..."
        if sudo -u "$USERNAME" bash "$DOTFILES_DIR/post-install.sh"; then
            print_success "Post-installation completed"
        else
            print_warning "Post-installation script finished with errors"
        fi
    fi
}

# Main function
install_dotfiles() {
    print_status "Starting dotfiles installation..."
    
    check_requirements
    
    read -rp "Backup existing configs? (y/n): " do_backup
    if [[ "$do_backup" =~ ^[Yy]$ ]]; then 
        backup_configs
    fi
    
    clone_dotfiles
    install_configs
    post_install
    
    print_success "Dotfiles installation complete!"
    print_status "You may need to restart your session for all changes to take effect."
}

# Run only if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_dotfiles
fi
