# Dotfiles

Fedora 44 + Niri/DMS Shell configurations.

## Usage

```bash
# Check what's changed
./sync.sh status

# Sync ~/.config -> repo, prompt to commit & push
./sync.sh sync

# Quick sync + auto-commit (ask before push)
./sync.sh quick
```

## Synced configs

**Directories:** alacritty, bat, btop, cava, eza, fastfetch, fish, fontconfig,
foot, fuzzel, herdr, hypr, kde-material-you-colors, kitty, lazydocker, lazygit,
matugen, mpv, neofetch, niri, nvim, qt5ct, qt6ct, tmux, wezterm, wlogout,
yazi, yt-dlp, yt-x, zathura, zellij

**Files:** background, chrome-flags.conf, code-flags.conf, kdeglobals,
resetdocker.sh, starship.toml, .zshrc, .zsh_aliases, .zsh_exports

## Adding new configs

1. Copy the dir/file into `.config/` in this repo
2. Add the name to the `DIRS_TO_SYNC` or `FILES_TO_SYNC` array in `sync.sh`
3. Run `./sync.sh sync`

## Package reference

`installer/packages.txt` is a reference list of installed packages (not automated).

## Repo structure

```
dotfiles/
├── sync.sh              # Sync script
├── installer/
│   └── packages.txt     # Package reference list
├── .config/             # Tracked configs
├── .local/bin/          # Custom scripts
├── .gitignore
└── README.md
```
