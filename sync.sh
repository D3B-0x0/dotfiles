#!/usr/bin/env bash
# sync.sh — Sync selected ~/.config items into the dotfiles repo
# Usage: ./sync.sh [sync|status|quick]

set -euo pipefail

# --- Resolve repo root from script location ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$SCRIPT_DIR"
SOURCE_DIR="$HOME/.config"

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
ok()      { echo -e "${GREEN}[OK]${NC} $1"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }
fail()    { echo -e "${RED}[FAIL]${NC} $1"; }

# --- Sync lists ---
DIRS_TO_SYNC=(
    alacritty
    bat
    btop
    cava
    eza
    fastfetch
    fish
    fontconfig
    foot
    fuzzel
    herdr
    hypr
    kde-material-you-colors
    kitty
    lazydocker
    lazygit
    matugen
    mpv
    neofetch
    niri
    nvim
    qt5ct
    qt6ct
    tmux
    wezterm
    wlogout
    yazi
    yt-dlp
    yt-x
    zathura
    zellij
)

FILES_TO_SYNC=(
    background
    chrome-flags.conf
    code-flags.conf
    kdeglobals
    resetdocker.sh
    starship.toml
    .zshrc
    .zsh_aliases
    .zsh_exports
)

# --- Helpers ---
sync_dir() {
    local name="$1"
    local src="$SOURCE_DIR/$name"
    local dst="$REPO_DIR/.config/$name"

    if [[ ! -d "$src" ]]; then
        warn "$name: not found in ~/.config, skipping"
        return 0
    fi

    mkdir -p "$dst"
    rsync -a --delete "$src/" "$dst/"
    ok "Synced dir:  $name"
}

sync_file() {
    local name="$1"
    local src="$SOURCE_DIR/$name"
    local dst="$REPO_DIR/.config/$name"

    if [[ ! -e "$src" ]]; then
        warn "$name: not found in ~/.config, skipping"
        return 0
    fi

    mkdir -p "$(dirname "$dst")"
    cp "$src" "$dst"
    ok "Synced file: $name"
}

do_sync() {
    info "Syncing configs from ~/.config -> $REPO_DIR/.config"
    echo

    for d in "${DIRS_TO_SYNC[@]}"; do
        sync_dir "$d"
    done

    for f in "${FILES_TO_SYNC[@]}"; do
        sync_file "$f"
    done

    echo
    ok "Sync complete"
}

# --- Status ---
show_status() {
    info "Status: $REPO_DIR/.config vs $SOURCE_DIR"
    echo "========================================"

    local has_changes=false

    for d in "${DIRS_TO_SYNC[@]}"; do
        local src="$SOURCE_DIR/$d"
        local dst="$REPO_DIR/.config/$d"

        if [[ ! -d "$src" ]]; then
            warn "$d: not in ~/.config"
            continue
        fi
        if [[ ! -d "$dst" ]]; then
            echo -e "  ${CYAN}NEW${NC}      $d/"
            has_changes=true
            continue
        fi
        if diff -rq "$src" "$dst" &>/dev/null; then
            echo -e "  ${GREEN}UP-TO-DATE${NC} $d/"
        else
            echo -e "  ${YELLOW}CHANGED${NC}   $d/"
            has_changes=true
        fi
    done

    for f in "${FILES_TO_SYNC[@]}"; do
        local src="$SOURCE_DIR/$f"
        local dst="$REPO_DIR/.config/$f"

        if [[ ! -e "$src" ]]; then
            warn "$f: not in ~/.config"
            continue
        fi
        if [[ ! -e "$dst" ]]; then
            echo -e "  ${CYAN}NEW${NC}      $f"
            has_changes=true
            continue
        fi
        if diff -q "$src" "$dst" &>/dev/null; then
            echo -e "  ${GREEN}UP-TO-DATE${NC} $f"
        else
            echo -e "  ${YELLOW}CHANGED${NC}   $f"
            has_changes=true
        fi
    done

    echo
    if [[ "$has_changes" == true ]]; then
        info "Run './sync.sh sync' to update repo"
    else
        ok "All tracked configs are up to date"
    fi

    # Git status
    echo
    info "Git repo status:"
    cd "$REPO_DIR"
    if git diff --quiet && git diff --cached --quiet; then
        ok "No uncommitted changes"
    else
        warn "Uncommitted changes:"
        git status --short
    fi
}

# --- Commit helper ---
do_commit() {
    cd "$REPO_DIR"

    if git diff --quiet && git diff --cached --quiet; then
        info "No changes to commit"
        return 0
    fi

    echo
    info "Changes to commit:"
    git diff --stat
    echo

    read -rp "Commit these changes? [Y/n]: " confirm || true
    if [[ "$confirm" =~ ^[Nn]$ ]]; then
        warn "Skipped commit"
        return 0
    fi

    read -rp "Commit message [Enter for timestamp]: " msg || true
    if [[ -z "$msg" ]]; then
        msg="Update configs: $(date '+%Y-%m-%d %H:%M:%S')"
    fi

    git add -A
    git commit -m "$msg"
    ok "Committed: $msg"

    read -rp "Push to remote? [y/N]: " push_confirm || true
    if [[ "$push_confirm" =~ ^[Yy]$ ]]; then
        git push && ok "Pushed to remote" || fail "Push failed"
    else
        info "Skipped push"
    fi
}

# --- Quick (no prompts except push) ---
do_quick() {
    cd "$REPO_DIR"
    do_sync

    if git diff --quiet && git diff --cached --quiet; then
        info "No changes to commit"
        return 0
    fi

    git add -A
    git commit -m "Quick sync: $(date '+%Y-%m-%d %H:%M:%S')" || true
    ok "Auto-committed"

    read -rp "Push to remote? [y/N]: " push_confirm || true
    if [[ "$push_confirm" =~ ^[Yy]$ ]]; then
        git push && ok "Pushed to remote" || fail "Push failed"
    else
        info "Skipped push"
    fi
}

# --- Main ---
cmd="${1:-sync}"

case "$cmd" in
    sync)
        do_sync
        do_commit
        ;;
    status)
        show_status
        ;;
    quick)
        do_quick
        ;;
    *)
        echo "Usage: $0 [sync|status|quick]"
        echo
        echo "  sync    Sync ~/.config -> repo, prompt to commit & push"
        echo "  status  Show what's changed vs repo"
        echo "  quick   Sync + auto-commit, ask before push"
        exit 1
        ;;
esac
