#!/usr/bin/env bash

# Enhanced dotfiles setup script with Gum for beautiful CLI interfaces
# https://github.com/charmbracelet/gum

# Configuration
DOTFILES_REPO="https://github.com/yourusername/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"
PACKAGES_SCRIPT="$DOTFILES_DIR/installer/packages.sh"

# Colors and styling are now handled by Gum

# Install Gum if not already installed
install_gum() {
    if ! command -v gum &> /dev/null; then
        echo "Installing Gum for beautiful CLI interfaces..."
        
        if command -v brew &> /dev/null; then
            brew install gum
        elif command -v apt &> /dev/null; then
            sudo mkdir -p /etc/apt/keyrings
            curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
            echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
            sudo apt update && sudo apt install gum
        else
            echo "Could not install Gum. Please install it manually: https://github.com/charmbracelet/gum#installation"
            exit 1
        fi
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
    
    DEPS=("git" "curl")
    MISSING_DEPS=()
    
    for dep in "${DEPS[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            MISSING_DEPS+=("$dep")
        fi
    done
    
    if [ ${#MISSING_DEPS[@]} -gt 0 ]; then
        gum confirm "$(gum style --foreground 208 "Missing dependencies: ${MISSING_DEPS[*]}. Install them now?")" && {
            if command -v apt &> /dev/null; then
                sudo apt update && sudo apt install -y "${MISSING_DEPS[@]}"
            elif command -v brew &> /dev/null; then
                brew install "${MISSING_DEPS[@]}"
            else
                print_error "Could not install dependencies automatically. Please install them manually."
            fi
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

install_dotfiles() {
    print_step "Installing dotfiles..."
    
    cd "$DOTFILES_DIR" || print_error "Could not change to dotfiles directory"
    
    if [ -f "$DOTFILES_DIR/install.sh" ]; then
        print_status "Found install.sh script, running it now"
        
        # Show a fancy progress bar during installation
        gum style --border normal --padding "1 2" --margin "1" "$(gum style --foreground 105 "Running dotfiles installer...")"
        bash "$DOTFILES_DIR/install.sh" || print_error "Dotfiles installation failed"
    else
        print_error "No install.sh script found in dotfiles repository"
    fi
    
    print_success "Dotfiles installed successfully!"
}

install_packages() {
    gum style --border double --margin "1" --padding "1 2" --border-foreground 99 "$(gum style --foreground 99 --bold "📦 Package Installation")"
    
    if [ ! -f "$PACKAGES_SCRIPT" ]; then
        gum style --foreground 196 --border normal --padding "1" --margin "1" --border-foreground 196 "$(gum style --bold "⚠️ Error"): packages.sh not found in $DOTFILES_DIR/installer!"
        
        # Offer a solution instead of just erroring out
        gum confirm "Would you like to create a basic packages script?" && {
            mkdir -p "$(dirname "$PACKAGES_SCRIPT")"
            gum style --foreground 226 "Creating a basic packages script..."
            
            # Let user select their package manager
            PKG_MANAGER=$(gum choose --height 10 "apt (Debian/Ubuntu)" "brew (macOS)" "pacman (Arch)" "dnf (Fedora)" "other")
            PKG_MANAGER=$(echo "$PKG_MANAGER" | cut -d' ' -f1)
            
            # Create packages categories for selection
            cat > "$PACKAGES_SCRIPT" << EOF
#!/bin/bash
# Auto-generated packages script

# Package groups
PACKAGE_GROUPS=("essential" "development" "productivity" "media" "gaming")

# Package definitions
essential=("git" "curl" "vim" "htop")
development=("build-essential" "python3" "nodejs")
productivity=("tmux" "neofetch")
media=("vlc" "ffmpeg")
gaming=("steam")

# Install function
install_packages() {
    local category=\$1
    echo "Installing \$category packages..."
    
    case "$PKG_MANAGER" in
        apt)     sudo apt update && sudo apt install -y \${!category[@]} ;;
        brew)    brew install \${!category[@]} ;;
        pacman)  sudo pacman -S --noconfirm \${!category[@]} ;;
        dnf)     sudo dnf install -y \${!category[@]} ;;
        *)       echo "Unsupported package manager. Please install manually: \${!category[@]}" ;;
    esac
}

# Main
if [ \$# -eq 0 ]; then
    echo "No package groups specified. Available: \${PACKAGE_GROUPS[*]}"
    exit 1
fi

for group in "\$@"; do
    if [[ " \${PACKAGE_GROUPS[*]} " == *" \$group "* ]]; then
        install_packages "\$group"
    else
        echo "Unknown package group: \$group"
    fi
done
EOF
            chmod +x "$PACKAGES_SCRIPT"
            gum style --foreground 46 --bold "Basic packages script created at $PACKAGES_SCRIPT"
        } || {
            print_error "packages.sh not found in $DOTFILES_DIR/installer!"
        }
    fi
    
    gum style --foreground 117 "📋 Found packages script at: $(gum style --underline "$PACKAGES_SCRIPT")"
    chmod +x "$PACKAGES_SCRIPT"
    
    # Enhanced package group selection
    if grep -q "PACKAGE_GROUPS" "$PACKAGES_SCRIPT"; then
        # Extract available groups from script
        AVAILABLE_GROUPS=$(grep -o 'PACKAGE_GROUPS=([^)]*' "$PACKAGES_SCRIPT" | sed 's/PACKAGE_GROUPS=(//' | tr -d '"' | tr -d "'" | tr ' ' '\n' | sort)
        
        # Create a fancy selection menu with descriptions
        gum style --margin "1" --padding "1 2" --border rounded --border-foreground 105 "$(gum style --foreground 105 --bold "📦 Package Categories")\n\n$(gum style --foreground 117 "Select categories to install (space to select, enter to confirm):")"
        
        # Create a more interactive selection experience
        SELECTED_GROUPS=$(echo "$AVAILABLE_GROUPS" | gum choose --no-limit --height 15)
        
        if [ -z "$SELECTED_GROUPS" ]; then
            gum style --foreground 208 "No package groups selected. Skipping package installation."
            return
        fi
        
        # Show what's going to be installed with a preview
        gum style --margin "1" --foreground 117 "$(gum style --bold "🚀 Ready to install:")$(gum style --foreground 226 " $SELECTED_GROUPS")"
        
        # Create a live progress tracker for package installation
        TOTAL_GROUPS=$(echo "$SELECTED_GROUPS" | wc -w)
        CURRENT_GROUP=0
        
        # Start a fancy progress meter
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
            
            # Run the installation with a spinner and live output
            TEMP_LOG=$(mktemp)
            gum spin --spinner dot --title "$(gum style --foreground 39 "Installing $group packages...")" -- \
                bash "$PACKAGES_SCRIPT" "$group" > "$TEMP_LOG" 2>&1 || {
                    cat "$TEMP_LOG"
                    rm "$TEMP_LOG"
                    print_error "Failed to install $group packages"
                }
            rm "$TEMP_LOG"
            
            # Show success for this group
            gum style --foreground 46 "✓ $(gum style --bold "$group") packages installed!"
        done
    else
        # If no package groups defined, ask if user wants to see live output
        gum confirm "$(gum style --foreground 117 "Would you like to see live installation output?")" && {
            # Run with live output
            gum style --foreground 39 --bold "📦 Installing packages with live output:"
            gum style --border normal --margin "1" --padding "0" --border-foreground 105
            bash "$PACKAGES_SCRIPT" || print_error "Package installation failed"
        } || {
            # Run silently with a fun spinner
            SPINNERS=("points" "line" "meter" "moon" "monkey" "dot" "hamburger")
            RANDOM_SPINNER=${SPINNERS[$RANDOM % ${#SPINNERS[@]}]}
            
            gum spin --spinner "$RANDOM_SPINNER" --title "$(gum style --foreground 39 "🔄 Installing packages... Grab a coffee! ☕")" -- \
                bash "$PACKAGES_SCRIPT" || print_error "Package installation failed"
        }
    fi
    
    # Celebratory success message
    gum style --margin "1" --border double --padding "1 2" --border-foreground 46 "$(gum style --foreground 46 --bold "🎉 All packages installed successfully! 🎉")"
    
    # Show a quick animation
    echo -n "$(gum style --foreground 46 "Finalizing... ")"
    for i in {1..5}; do
        echo -n "$(gum style --foreground 46 "✨")"
        sleep 0.15
    done
    echo ""
}

main() {
    # Clear the screen for a clean start
    clear
    
    # Display a fancy header
    print_header "🚀 Dotfiles Setup Wizard 🚀"
    
    # Install Gum first
    install_gum
    
    # Display setup steps
    gum style --margin "1" --padding "1 2" --border normal --border-foreground 105 "$(gum style --foreground 105 "This script will set up your dotfiles and install necessary packages.")"
    
    # Ask for confirmation before proceeding
    gum confirm "Ready to start?" || {
        gum style --foreground 208 "Setup cancelled by user."
        exit 0
    }
    
    # Run each step with progress indications
    install_dependencies
    clone_dotfiles
    install_dotfiles
    install_packages
    
    # Display completion message with some flair
    gum style --border double --margin "1" --padding "1 2" --border-foreground 46 "$(gum style --foreground 46 --bold "✨ Setup complete! Your system is now configured. ✨")"
    
    # Ask if user wants to restart shell
    gum confirm "Would you like to restart your shell to apply changes?" && {
        print_status "Restarting shell..."
        exec "$SHELL" -l
    }
}

main
