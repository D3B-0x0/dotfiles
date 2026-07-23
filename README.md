<p align="center">
  <img src="https://img.shields.io/badge/Fedora-44-51A2DA?style=for-the-badge&logo=fedora&logoColor=white" alt="Fedora"/>
  <img src="https://img.shields.io/badge/Niri-DMS-FF6B9D?style=for-the-badge" alt="Niri"/>
  <img src="https://img.shields.io/badge/Zsh-5.9-15C02E?style=for-the-badge&logo=gnu&logoColor=white" alt="Zsh"/>
  <img src="https://img.shields.io/badge/Sync-Script-FFB800?style=for-the-badge" alt="sync.sh"/>
</p>

<h1 align="center">~/.config</h1>

<p align="center">
  <b>My personal dotfiles</b><br>
  <sub>Fedora 44 · Niri · DMS Shell · Catppuccin vibes</sub>
</p>

---

## Quick Start

```bash
git clone git@github.com:D3B-0x0/dotfiles.git ~/dotfiles
cd ~/dotfiles
./sync.sh sync
```

## Usage

```
./sync.sh status    check what's changed
./sync.sh sync      sync, commit, push (with prompts)
./sync.sh quick     sync + auto-commit (ask before push)
```

> **How it works:** `sync.sh` copies selected configs from `~/.config` into the
> repo, shows a diff, and prompts you to commit and push. One direction only —
> system → repo.

## What's Tracked

<details>
<summary><b>Directories (31)</b></summary>

| | | | |
|---|---|---|---|
| `alacritty` | `bat` | `btop` | `cava` |
| `eza` | `fastfetch` | `fish` | `fontconfig` |
| `foot` | `fuzzel` | `herdr` | `hypr` |
| `kde-material-you-colors` | `kitty` | `lazydocker` | `lazygit` |
| `matugen` | `mpv` | `neofetch` | `niri` |
| `nvim` | `qt5ct` | `qt6ct` | `tmux` |
| `wezterm` | `wlogout` | `yazi` | `yt-dlp` |
| `yt-x` | `zathura` | `zellij` | |

</details>

<details>
<summary><b>Files (9)</b></summary>

| | | |
|---|---|---|
| `background` | `chrome-flags.conf` | `code-flags.conf` |
| `kdeglobals` | `resetdocker.sh` | `starship.toml` |
| `.zshrc` | `.zsh_aliases` | `.zsh_exports` |

</details>

## Adding New Configs

1. Add the dir or file to `.config/` in this repo
2. Append its name to `DIRS_TO_SYNC` or `FILES_TO_SYNC` in `sync.sh`
3. Run `./sync.sh sync`

## Structure

```
dotfiles/
├── sync.sh                # the one script
├── installer/
│   └── packages.txt       # reference list of installed packages
├── .config/               # tracked configs
├── .gitignore
├── LICENSE
└── README.md
```

## Packages

`installer/packages.txt` is a **reference-only** list of packages installed on
this system. Not automated — just a snapshot for reproducibility.

```bash
# View
cat installer/packages.txt

# Regenerate from current system
dnf5 repoquery --userinstalled | sed 's/-[0-9].*//' | sort -u > installer/packages.txt
```

## System

| | |
|---|---|
| **OS** | Fedora 44 Workstation |
| **Kernel** | 7.1.x |
| **Shell** | Zsh 5.9 + Starship |
| **Compositor** | Niri + DMS Shell |
| **GPU** | NVIDIA (proprietary) |
| **Disk** | Btrfs + LUKS2 + Snapshots |

## License

[MIT](LICENSE)
