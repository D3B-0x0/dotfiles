#!/usr/bin/env bash

# Enhanced dotfiles setup script with Gum for beautiful CLI interfaces
# Uses dedicated scripts instead of symlinking

# Configuration
DOTFILES_REPO="https://github.com/D3B-0x0/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"
PACKAGES_SCRIPT="$DOTFILES_DIR/installer/packages.sh"
DOTFILES_SCRIPT="$DOTFILES_DIR/installer/dotfiles.sh"

# Install Gum if not already installed
install_gum() {
    if ! command -v gum &> /dev/null; then
        echo "Installing Gum for beautiful CLI interfaces..."
        
        # For Arch Linux
        if command -v pacman &> /dev/null; then
            sudo pacman -S gum --noconfirm || {
                # Try AUR if not in official repos
                if ! command -v yay &> /dev/null; then
                    echo "Installing yay AUR helper..."
                    sudo pacman -S --needed git base-devel
                    git clone https://aur.archlinux.org/yay.git /tmp/yay
                    cd /tmp/yay || exit
                    makepkg -si --noconfirm
                    cd - || exit
                fi
                yay -S gum --noconfirm
            }
        else
            echo "This script is designed for Arch Linux and Arch-based systems. Exiting."
            exit 1
        fi
    fi
    
    # Verify gum is installed
    if ! command -v gum &> /dev/null; then
        echo "Failed to install Gum. The script will continue with basic formatting."
        # Define fallback functions
        print_header() { echo -e "\n### $1 ###\n"; }
        print_status() { echo "INFO: $1"; }
        print_success() { echo "SUCCESS: $1"; }
        print_error() { echo "ERROR: $1"; exit 1; }
        print_step() { echo -e "\n-> $1"; }
    fi
}

# Function to display styled messages
print_header() {
    gum style --border normal --margin "1" --padding "1 2" --border-foreground 212 "$(gum style --foreground 212 --bold "$1")"
}

print_status() {
    gum spin --spinner dot --title "$(gum style --foreground 39 "⧖ $1")" -- sleep 1
}

print_success() {
    gum style --foreground 46 "✓ $1"
}

print_error() {
    gum style --foreground 196 --bold "✗ ERROR: $1"
    exit 1
}

print_step() {
    gum style --foreground 226 "→ $1"
}

# Functions for installation steps
install_dependencies() {
    print_step "Checking for dependencies..."
    
    DEPS=("git" "curl" "rsync")
    MISSING_DEPS=()
    
    for dep in "${DEPS[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            MISSING_DEPS+=("$dep")
        fi
    done
    
    if [ ${#MISSING_DEPS[@]} -gt 0 ]; then
        gum confirm "$(gum style --foreground 208 "Missing dependencies: ${MISSING_DEPS[*]}. Install them now?")" && {
            sudo pacman -Sy --noconfirm "${MISSING_DEPS[@]}" || print_error "Failed to install dependencies"
        } || {
            print_error "Required dependencies not installed. Exiting."
        }
    fi
    
    print_success "All dependencies are installed!"
}

clone_dotfiles() {
    gum style --border rounded --margin "1" --padding "1 2" --border-foreground 213 "$(gum style --foreground 213 --bold "🔄 Dotfiles Repository Setup")"
    
    if [ -d "$DOTFILES_DIR" ]; then
        gum confirm "$(gum style --foreground 208 --border normal --padding "0 1" "Dotfiles directory already exists. Do you want to remove it and clone again?")" && {
            # Create a fun animation for removal
            echo -n "$(gum style --foreground 208 "Removing existing dotfiles... ")"
            for i in {1..10}; do
                echo -n "$(gum style --foreground 208 "🗑️ ")"
                sleep 0.1
            done
            echo ""
            rm -rf "$DOTFILES_DIR"
            
            # Clone with visual progress
            REPO_NAME=$(basename "$DOTFILES_REPO" .git)
            gum style --foreground 39 "Preparing to clone $(gum style --bold --foreground 213 "$REPO_NAME") repository..."
            gum spin --spinner points --title "$(gum style --foreground 39 "Cloning dotfiles repository...")" -- \
                git clone "$DOTFILES_REPO" "$DOTFILES_DIR" || print_error "Failed to clone repository"
            
            # Display success with animation
            echo -n "$(gum style --foreground 46 "Repository cloned ")"
            for i in {1..3}; do
                echo -n "$(gum style --foreground 46 "✓")"
                sleep 0.2
            done
            echo ""
            gum style --border normal --margin "0 1" --padding "0 2" --border-foreground 46 "$(gum style --foreground 46 "Dotfiles are now ready at: $(gum style --bold --underline "$DOTFILES_DIR")")"
        } || {
            gum style --foreground 105 --margin "0 0 1 0" "$(gum style --bold "➟") Using existing dotfiles at $(gum style --underline "$DOTFILES_DIR")"
            
            # Show repo status instead of just continuing
            cd "$DOTFILES_DIR" && {
                BRANCH=$(git branch --show-current)
                COMMITS=$(git rev-list --count HEAD)
                LAST_COMMIT=$(git log -1 --pretty=%B | head -n 1)
                
                gum style --margin "0 2" --padding "1" --border normal --border-foreground 105 \
                "$(gum style --foreground 105 --bold "Repository Status")\n\n$(gum style --foreground 117 "Branch: $(gum style --bold "$BRANCH")")\n$(gum style --foreground 117 "Total Commits: $COMMITS")\n$(gum style --foreground 117 "Last Commit: $(gum style --italic "$LAST_COMMIT")")"
                
                gum confirm "Do you want to pull the latest changes?" && {
                    gum spin --spinner points --title "$(gum style --foreground 39 "Pulling latest changes...")" -- git pull
                    print_success "Repository updated successfully!"
                }
            }
        }
        return
    fi
    
    # Improved cloning experience
    REPO_NAME=$(basename "$DOTFILES_REPO" .git)
    gum style --foreground 39 "Preparing to clone $(gum style --bold --foreground 213 "$REPO_NAME") repository..."
    
    # Let user confirm the repo
    gum confirm "Clone from: $(gum style --underline "$DOTFILES_REPO")?" || {
        # If they don't want the default repo, let them input a new one
        NEW_REPO=$(gum input --placeholder "Enter the Git repository URL" --value "$DOTFILES_REPO")
        if [ -n "$NEW_REPO" ]; then
            DOTFILES_REPO=$NEW_REPO
            REPO_NAME=$(basename "$DOTFILES_REPO" .git)
            gum style --foreground 39 "Will clone from: $(gum style --bold "$DOTFILES_REPO")"
        fi
    }
    
    # Visual clone operation
    gum spin --spinner points --title "$(gum style --foreground 39 "Cloning $REPO_NAME repository...")" -- \
        git clone "$DOTFILES_REPO" "$DOTFILES_DIR" || print_error "Failed to clone repository"
    
    # Display success with more visual flair
    gum style --foreground 46 "🌟 Dotfiles repository cloned successfully! 🌟"
    gum style --border normal --margin "0 1" --padding "0 2" --border-foreground 46 "$(gum style --foreground 46 "Dotfiles are now ready at: $(gum style --bold --underline "$DOTFILES_DIR")")"
}

# Run the dedicated dotfiles.sh script
setup_dotfiles() {
    gum style --border rounded --margin "1" --padding "1 2" --border-foreground 147 "$(gum style --foreground 147 --bold "🔧 Setting Up Dotfiles")"
    
    cd "$DOTFILES_DIR" || print_error "Could not change to dotfiles directory"
    
    if [ -f "$DOTFILES_SCRIPT" ]; then
        # Found the dotfiles script in the repository
        chmod +x "$DOTFILES_SCRIPT"
        
        gum style --foreground 147 "Found $(gum style --bold --underline "dotfiles.sh") script in the repository"
        
        # Display script size and modification time
        SCRIPT_SIZE=$(du -h "$DOTFILES_SCRIPT" | cut -f1)
        SCRIPT_MODIFIED=$(stat -c %y "$DOTFILES_SCRIPT" 2>/dev/null || \
                         stat -f "%Sm" "$DOTFILES_SCRIPT" 2>/dev/null)
        
        gum style --foreground 117 "Script info: $(gum style --bold "$SCRIPT_SIZE") | Last modified: $(gum style --italic "$SCRIPT_MODIFIED")"
        
        # Show contents of script (first few lines)
        gum style --foreground 117 "Script preview (first 5 lines):"
        head -n 5 "$DOTFILES_SCRIPT" | gum style --foreground 105 --margin "0 2" --padding "1" --border normal
        
        # Ask for confirmation before running
        gum confirm "Run dotfiles.sh script?" && {
            # Show a fancy progress bar during execution
            gum style --border normal --padding "1 2" --margin "1" "$(gum style --foreground 105 "Running dotfiles installer...")"
            
            # *** FIX: Create a temporary answer file to handle dotfiles.sh prompts automatically ***
            # This avoids the install getting stuck at user prompts
            echo "y" > /tmp/dotfiles_answers
            
            # Execute with spinner and provide automatic answers to any prompts
            gum spin --spinner points --title "$(gum style --foreground 39 "Executing dotfiles.sh...")" -- \
                bash "$DOTFILES_SCRIPT" < /tmp/dotfiles_answers || print_error "Failed to run dotfiles.sh script"
            
            # Remove the temporary file
            rm -f /tmp/dotfiles_answers
            
            # Success animation
            echo -n "$(gum style --foreground 46 "Dotfiles setup complete ")"
            for i in {1..3}; do
                echo -n "$(gum style --foreground 46 "✓")"
                sleep 0.2
            done
            echo ""
            
            print_success "Dotfiles set up successfully!"
        } || {
            gum style --foreground 208 "Skipping dotfiles setup as requested"
        }
    else
        gum style --foreground 208 --border normal --padding "1" --margin "1" --border-foreground 208 "$(gum style --bold "⚠️ Warning"): No dotfiles.sh script found at $DOTFILES_SCRIPT"
        
        # Offer to continue without it
        gum confirm "Continue without dotfiles.sh?" || {
            print_error "Setup cancelled by user due to missing dotfiles.sh script"
        }
    fi
}

# Run the dedicated packages.sh script
install_packages() {
    gum style --border double --margin "1" --padding "1 2" --border-foreground 99 "$(gum style --foreground 99 --bold "📦 Package Installation")"
    
    if [ ! -f "$PACKAGES_SCRIPT" ]; then
        gum style --foreground 196 --border normal --padding "1" --margin "1" --border-foreground 196 "$(gum style --bold "⚠️ Error"): packages.sh not found at $PACKAGES_SCRIPT!"
        
        # Offer to continue without it
        gum confirm "Continue without packages.sh?" || {
            print_error "Setup cancelled by user due to missing packages.sh script"
        }
        return
    fi
    
    gum style --foreground 117 "📋 Found packages script at: $(gum style --underline "$PACKAGES_SCRIPT")"
    chmod +x "$PACKAGES_SCRIPT"
    
    # Display script information
    SCRIPT_SIZE=$(du -h "$PACKAGES_SCRIPT" | cut -f1)
    SCRIPT_MODIFIED=$(stat -c %y "$PACKAGES_SCRIPT" 2>/dev/null || \
                     stat -f "%Sm" "$PACKAGES_SCRIPT" 2>/dev/null)
    
    gum style --foreground 117 "Script info: $(gum style --bold "$SCRIPT_SIZE") | Last modified: $(gum style --italic "$SCRIPT_MODIFIED")"
    
    # Show contents of script (first few lines)
    gum style --foreground 117 "Script preview (first 5 lines):"
    head -n 5 "$PACKAGES_SCRIPT" | gum style --foreground 105 --margin "0 2" --padding "1" --border normal
    
    # Ask for confirmation before running
    gum confirm "Run packages.sh script?" && {
        # *** FIX: Create a temporary answer file to handle packages.sh prompts automatically ***
        echo "y" > /tmp/packages_answers
        
        # Check if we need to run with extra parameters
        if grep -q "PACKAGE_GROUPS" "$PACKAGES_SCRIPT"; then
            # Extract available groups from script
            AVAILABLE_GROUPS=$(grep -o 'PACKAGE_GROUPS=([^)]*' "$PACKAGES_SCRIPT" | sed 's/PACKAGE_GROUPS=(//' | tr -d '"' | tr -d "'" | tr ' ' '\n' | sort)
            
            if [ -n "$AVAILABLE_GROUPS" ]; then
                # Create a fancy selection menu
                gum style --margin "1" --padding "1 2" --border rounded --border-foreground 105 "$(gum style --foreground 105 --bold "📦 Package Categories")\n\n$(gum style --foreground 117 "Select categories to install (space to select, enter to confirm):")"
                
                # Interactive selection experience
                SELECTED_GROUPS=$(echo "$AVAILABLE_GROUPS" | gum choose --no-limit --height 15)
                
                if [ -n "$SELECTED_GROUPS" ]; then
                    gum style --margin "1" --foreground 117 "$(gum style --bold "🚀 Ready to install:")$(gum style --foreground 226 " $SELECTED_GROUPS")"
                    
                    # Start a fancy progress meter
                    TOTAL_GROUPS=$(echo "$SELECTED_GROUPS" | wc -w)
                    CURRENT_GROUP=0
                    
                    for group in $SELECTED_GROUPS; do
                        ((CURRENT_GROUP++))
                        PERCENT=$((CURRENT_GROUP * 100 / TOTAL_GROUPS))
                        
                        # Create a visual progress bar
                        PROGRESS_BAR=""
                        for ((i=0; i<PERCENT/5; i++)); do
                            PROGRESS_BAR="${PROGRESS_BAR}▓"
                        done
                        for ((i=PERCENT/5; i<20; i++)); do
                            PROGRESS_BAR="${PROGRESS_BAR}░"
                        done
                        
                        gum style --foreground 39 "Installing group $(gum style --bold --foreground 105 "$group") [$CURRENT_GROUP/$TOTAL_GROUPS]"
                        gum style --foreground 117 "$PROGRESS_BAR $PERCENT%"
                        
                        # Run with spinner and automatic answers
                        gum spin --spinner dot --title "$(gum style --foreground 39 "Installing $group packages...")" -- \
                            bash "$PACKAGES_SCRIPT" "$group" < /tmp/packages_answers || print_error "Failed to install $group packages"
                        
                        # Show success for this group
                        gum style --foreground 46 "✓ $(gum style --bold "$group") packages installed!"
                    done
                else
                    gum style --foreground 208 "No package groups selected. Skipping package installation."
                    return
                fi
            else
                # If no package groups defined, just run the script
                gum spin --spinner points --title "$(gum style --foreground 39 "Installing packages...")" -- \
                    bash "$PACKAGES_SCRIPT" < /tmp/packages_answers || print_error "Package installation failed"
            fi
        else
            # Just run the script without parameters but with automatic answers
            gum spin --spinner points --title "$(gum style --foreground 39 "Installing packages...")" -- \
                bash "$PACKAGES_SCRIPT" < /tmp/packages_answers || print_error "Package installation failed"
        fi
        
        # Remove temporary file
        rm -f /tmp/packages_answers
        
        # Success message
        gum style --margin "1" --border double --padding "1 2" --border-foreground 46 "$(gum style --foreground 46 --bold "🎉 All packages installed successfully! 🎉")"
    } || {
        gum style --foreground 208 "Skipping package installation as requested"
    }
}

main() {
    # Clear the screen for a clean start
    clear
    
    # Check if running on Arch Linux or an Arch-based distribution
    if ! command -v pacman &> /dev/null; then
        echo "This script is designed only for Arch Linux and Arch-based systems."
        echo "Exiting..."
        exit 1
    fi
    
    # Install Gum first
    install_gum
    
    # Display a fancy header
    print_header "🚀 D3B-0x0's Arch Linux Dotfiles Setup Wizard 🚀"
    
    # Display setup steps
    gum style --margin "1" --padding "1 2" --border normal --border-foreground 105 "$(gum style --foreground 105 "This script will set up your dotfiles and install necessary packages for Arch Linux using the dedicated scripts.")"
    
    # Ask for confirmation before proceeding
    gum confirm "Ready to start?" || {
        gum style --foreground 208 "Setup cancelled by user."
        exit 0
    }
    
    # Run each step with progress indications
    install_dependencies
    clone_dotfiles
    setup_dotfiles
    install_packages
    
    # Display completion message with some flair
    gum style --border double --margin "1" --padding "1 2" --border-foreground 46 "$(gum style --foreground 46 --bold "✨ Setup complete! Your Arch Linux system is now configured. ✨")"
    
    # Ask if user wants to restart shell
    gum confirm "Would you like to restart your shell to apply changes?" && {
        print_status "Restarting shell..."
        exec "$SHELL" -l
    }
}

main
