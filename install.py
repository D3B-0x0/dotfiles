#!/usr/bin/env python3
import subprocess
import sys
from pathlib import Path

def main():
    print("Starting complete system setup...")
    
    # First install packages
    print("\n=== Installing packages ===")
    try:
        subprocess.run([sys.executable, "pkginstaller.py"], check=True)
    except subprocess.CalledProcessError:
        print("Package installation failed!")
        sys.exit(1)
    
    # Then setup dotfiles
    print("\n=== Setting up dotfiles ===")
    try:
        subprocess.run([sys.executable, "dotfiles.py"], check=True)
    except subprocess.CalledProcessError:
        print("Dotfiles setup failed!")
        sys.exit(1)
    
    print("\n✓ Complete system setup finished successfully!")

if __name__ == "__main__":
    if os.geteuid() == 0:
        print("Don't run this script as root!")
        sys.exit(1)
    main()
