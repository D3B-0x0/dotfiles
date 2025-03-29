#!/bin/bash

DOTFILES_DIR="$HOME/dotfiles"
PACKAGES_FILE="$(dirname "$0")/packages.txt"


# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

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

# Check for sudo privileges
if ! sudo -v &> /dev/null; then
    print_error "This script requires sudo privileges"
    exit 1
fi

# Check if pacman is installed
if ! command -v pacman &> /dev/null; then
    print_error "pacman package manager not found"
    exit 1
fi

# Update package database
print_status "Updating package database..."
if ! sudo pacman -Sy &> /dev/null; then
    print_error "Failed to update package database"
    exit 1
fi

# Check if a package is installed
is_package_installed() {
    pacman -Qi "$1" &> /dev/null
    return $?
}

# Install packages from file
install_packages() {
    print_status "Starting package installation process..."

    # Check if packages.txt exists
    if [ ! -f "$PACKAGES_FILE" ]; then
        print_error "packages.txt not found at $PACKAGES_FILE"
        exit 1
    fi

    # Count total packages
    total_packages=$(wc -l < "$PACKAGES_FILE")
    print_status "Found $total_packages packages in packages.txt"

    # Ask for confirmation
    echo
    echo "This script will install all packages listed in packages.txt"
    echo "Packages will be installed using pacman"
    read -p "Do you want to continue? (y/n): " -n 1 -r
    echo

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_status "Installation cancelled"
        exit 0
    fi

    # Create temporary files for package lists
    to_install=$(mktemp)
    already_installed=$(mktemp)
    failed_packages=$(mktemp)

    # Check which packages need to be installed
    print_status "Checking installed packages..."
    while IFS= read -r package || [ -n "$package" ]; do
        # Skip empty lines and comments
        [[ -z "$package" || "$package" =~ ^# ]] && continue

        if is_package_installed "$package"; then
            echo "$package" >> "$already_installed"
        else
            echo "$package" >> "$to_install"
        fi
    done < "$PACKAGES_FILE"

    # Show already installed packages
    if [ -s "$already_installed" ]; then
        echo
        print_warning "The following packages are already installed:"
        while IFS= read -r package; do
            echo "  - $package"
        done < "$already_installed"
    fi

    # Install needed packages
    if [ -s "$to_install" ]; then
        echo
        print_status "The following packages will be installed:"
        while IFS= read -r package; do
            echo "  - $package"
        done < "$to_install"

        echo
        total_to_install=$(wc -l < "$to_install")
        print_status "Installing $total_to_install packages..."

        # Install packages and handle errors
        while IFS= read -r package; do
            echo
            print_status "Installing $package..."
            if sudo pacman -S --needed --noconfirm "$package"; then
                print_success "$package installed successfully"
            else
                print_error "Failed to install $package"
                echo "$package" >> "$failed_packages"
            fi
        done < "$to_install"
    else
        print_success "All packages are already installed!"
    fi

    # Summary
    echo
    print_status "Installation Summary:"
    echo "  Total packages: $total_packages"
    echo "  Already installed: $(wc -l < "$already_installed")"
    echo "  Newly installed: $(($(wc -l < "$to_install") - $(wc -l < "$failed_packages")))"

    # Show failed packages if any
    if [ -s "$failed_packages" ]; then
        echo
        print_error "Failed to install the following packages:"
        while IFS= read -r package; do
            echo "  - $package"
        done < "$failed_packages"
        print_warning "You may want to install these packages manually"
    fi

    # Cleanup
    rm "$to_install" "$already_installed" "$failed_packages"

    echo
    print_success "Package installation process completed!"
}

# Handle script interruption
cleanup() {
    echo
    print_warning "Installation interrupted!"
    exit 1
}

trap cleanup SIGINT SIGTERM

# Allow running as standalone script or being sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_packages
fi
