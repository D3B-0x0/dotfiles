#!/usr/bin/env python3
import os
import subprocess
import sys
from pathlib import Path
import shutil
from typing import List, Dict
import json

class DotfilesInstaller:
    def __init__(self):
        self.home_dir = Path.home()
        self.config_dir = self.home_dir / '.config'
        self.repo_url = "https://github.com/Kalidude69/dotfiles.git"
        self.clone_dir = Path("/tmp/dotfiles")
        
        # Define all directories and files to copy
        self.config_dirs = [
            'ags', 'alacritty', 'hyprpanel', 'bat', 'cava', 
            'fastfetch', 'fish', 'fontconfig', 'foot', 'fuzzel',
            'hypr', 'mpv', 'neofetch', 'nvim', 'qt5ct', 'tmux',
            'wezterm', 'wlogout','btop'
        ]
        
        self.config_files = [
            'chrome-flags.conf',
            'code-flags.conf',
            'starship.toml',
            'thorium-flags.conf'
        ]
        
        self.home_files = [
            ('.zshrc', '.zshrc'),
            ('zshrc.d', 'zshrc.d')
        ]

    def check_git_installed(self) -> bool:
        """Check if git is installed"""
        try:
            subprocess.run(['git', '--version'], check=True, capture_output=True)
            return True
        except subprocess.CalledProcessError:
            print("Error: git is not installed. Please install git first.")
            return False
        except FileNotFoundError:
            print("Error: git is not installed. Please install git first.")
            return False

    def backup_existing_configs(self):
        """Backup existing configuration files"""
        backup_dir = self.home_dir / '.config_backup'
        timestamp = subprocess.check_output(['date', '+%Y%m%d_%H%M%S']).decode().strip()
        backup_dir = backup_dir / timestamp
        
        print(f"\nBacking up existing configurations to {backup_dir}")
        
        # Backup .config directories
        for dir_name in self.config_dirs:
            src = self.config_dir / dir_name
            if src.exists():
                dst = backup_dir / '.config' / dir_name
                dst.parent.mkdir(parents=True, exist_ok=True)
                shutil.copytree(src, dst, dirs_exist_ok=True)

        # Backup config files
        for file_name in self.config_files:
            src = self.config_dir / file_name
            if src.exists():
                dst = backup_dir / '.config' / file_name
                dst.parent.mkdir(parents=True, exist_ok=True)
                shutil.copy2(src, dst)

        # Backup home directory files
        for src_name, _ in self.home_files:
            src = self.home_dir / src_name
            if src.exists():
                dst = backup_dir / src_name
                dst.parent.mkdir(parents=True, exist_ok=True)
                if src.is_dir():
                    shutil.copytree(src, dst, dirs_exist_ok=True)
                else:
                    shutil.copy2(src, dst)

    def create_directories(self):
        """Create necessary directories"""
        print("\nCreating necessary directories...")
        for dir_name in self.config_dirs:
            dir_path = self.config_dir / dir_name
            dir_path.mkdir(parents=True, exist_ok=True)

    def clone_repository(self):
        """Clone the dotfiles repository"""
        print("\nCloning dotfiles repository...")
        if self.clone_dir.exists():
            shutil.rmtree(self.clone_dir)
        
        try:
            subprocess.run(['git', 'clone', self.repo_url, str(self.clone_dir)], check=True)
        except subprocess.CalledProcessError as e:
            print(f"Error cloning repository: {e}")
            sys.exit(1)

    def copy_configurations(self):
        """Copy configuration files to their respective locations"""
        print("\nCopying configuration files...")
        
        # Copy .config directories
        for dir_name in self.config_dirs:
            src = self.clone_dir / dir_name
            dst = self.config_dir / dir_name
            if src.exists():
                print(f"Copying {dir_name} configuration...")
                shutil.copytree(src, dst, dirs_exist_ok=True)
            else:
                print(f"Warning: {dir_name} configuration not found in repository")

        # Copy config files
        for file_name in self.config_files:
            src = self.clone_dir / file_name
            dst = self.config_dir / file_name
            if src.exists():
                print(f"Copying {file_name}...")
                shutil.copy2(src, dst)
            else:
                print(f"Warning: {file_name} not found in repository")

        # Copy home directory files
        for src_name, dst_name in self.home_files:
            src = self.clone_dir / src_name
            dst = self.home_dir / dst_name
            if src.exists():
                print(f"Copying {src_name} to home directory...")
                if src.is_dir():
                    shutil.copytree(src, dst, dirs_exist_ok=True)
                else:
                    shutil.copy2(src, dst)
            else:
                print(f"Warning: {src_name} not found in repository")

    def set_permissions(self):
        """Set correct permissions for configuration files"""
        print("\nSetting correct permissions...")
        for dir_name in self.config_dirs:
            dir_path = self.config_dir / dir_name
            if dir_path.exists():
                os.chmod(dir_path, 0o755)
                for root, dirs, files in os.walk(dir_path):
                    for d in dirs:
                        os.chmod(Path(root) / d, 0o755)
                    for f in files:
                        os.chmod(Path(root) / f, 0o644)

    def cleanup(self):
        """Clean up temporary files"""
        print("\nCleaning up...")
        if self.clone_dir.exists():
            shutil.rmtree(self.clone_dir)

    def install(self):
        """Main installation process"""
        print("Starting dotfiles installation...")
        
        if not self.check_git_installed():
            return

        try:
            self.backup_existing_configs()
            self.create_directories()
            self.clone_repository()
            self.copy_configurations()
            self.set_permissions()
            self.cleanup()
            
            print("\n✓ Dotfiles installation completed successfully!")
            print("Note: You may need to restart your shell/applications for changes to take effect.")
            
        except Exception as e:
            print(f"\nError during installation: {e}")
            print("Installation failed. Your original configurations have been backed up.")
            self.cleanup()
            sys.exit(1)

def main():
    if os.geteuid() == 0:
        print("Don't run this script as root!")
        sys.exit(1)

    installer = DotfilesInstaller()
    installer.install()

if __name__ == "__main__":
    main()
