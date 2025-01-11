#!/usr/bin/env python3
import subprocess
import os
import sys
from typing import List, Tuple
import time
import fcntl
import re

PACKAGE_FILE = "packages.txt"

def strip_version(package_line: str) -> str:
    """Strip version number from package name"""
    # Match package name before any version number or space
    match = re.match(r'^([a-zA-Z0-9@_+-]+)', package_line)
    if match:
        return match.group(1)
    return package_line.split()[0]  # Fallback: just take first word

def is_package_installed(package_name: str) -> bool:
    """Check if a package is installed"""
    try:
        result = subprocess.run(
            ["pacman", "-Q", package_name],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            check=False
        )
        return result.returncode == 0
    except Exception as e:
        print(f"Error checking package {package_name}: {str(e)}")
        return False

def install_package(package_name: str) -> bool:
    """Install a package with proper locking"""
    lock_file = "/tmp/pacman_install.lock"
    
    try:
        with open(lock_file, 'w') as f:
            try:
                fcntl.flock(f.fileno(), fcntl.LOCK_EX)
                
                # Strip version number if present
                package_name = strip_version(package_name)
                
                result = subprocess.run(
                    ["sudo", "pacman", "-S", "--noconfirm", package_name],
                    stdout=subprocess.PIPE,
                    stderr=subprocess.PIPE,
                    text=True,
                    check=False
                )
                
                if result.returncode != 0:
                    print(f"Failed to install {package_name}: {result.stderr.strip()}")
                    return False
                    
                return True
                
            finally:
                fcntl.flock(f.fileno(), fcntl.LOCK_UN)
                
    except Exception as e:
        print(f"Error installing package {package_name}: {str(e)}")
        return False

def main():
    if os.geteuid() == 0:
        print("Don't run this script as root! It will ask for sudo when needed.")
        sys.exit(1)

    try:
        subprocess.run(["sudo", "-v"], check=True)
    except subprocess.CalledProcessError:
        print("Failed to verify sudo access. Please make sure you have sudo privileges.")
        sys.exit(1)

    if not os.path.exists(PACKAGE_FILE):
        print(f"Package list file '{PACKAGE_FILE}' not found.")
        sys.exit(1)

    try:
        with open(PACKAGE_FILE, "r") as file:
            packages = [line.strip() for line in file if line.strip() and not line.startswith('#')]
    except Exception as e:
        print(f"Error reading package file: {e}")
        sys.exit(1)

    print(f"Found {len(packages)} packages to process")
    
    failed_packages = []
    successful_packages = []
    already_installed = []

    for package_line in packages:
        package_name = strip_version(package_line)
        print(f"\nProcessing package: {package_name}")
        
        if is_package_installed(package_name):
            print(f"✓ {package_name} is already installed")
            already_installed.append(package_name)
            continue
            
        print(f"Installing {package_name}...")
        
        subprocess.run(["sudo", "-v"], check=False)
        
        if install_package(package_name):
            print(f"✓ Successfully installed {package_name}")
            successful_packages.append(package_name)
        else:
            print(f"✗ Failed to install {package_name}")
            failed_packages.append(package_name)
        
        time.sleep(0.5)

    print("\n" + "="*50)
    print("Installation Summary:")
    print(f"Total packages processed: {len(packages)}")
    print(f"Already installed: {len(already_installed)}")
    print(f"Successfully installed: {len(successful_packages)}")
    print(f"Failed installations: {len(failed_packages)}")

    if failed_packages:
        print("\nFailed packages:")
        for pkg in failed_packages:
            print(f"- {pkg}")

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\nProcess interrupted by user")
        sys.exit(1)
    except Exception as e:
        print(f"An unexpected error occurred: {e}")
        sys.exit(1)
