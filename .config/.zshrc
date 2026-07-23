# ===================================================================
# ZSH Configuration
# ===================================================================

# -------------------------------------------------------------------
# Interactive shell guard — MUST be first
# Without this, everything below runs when any script sources zshrc
# -------------------------------------------------------------------
[[ -o interactive ]] || return

# -------------------------------------------------------------------
# Edit buffer in $EDITOR  (Ctrl+X in insert, v in normal)
# -------------------------------------------------------------------
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X' edit-command-line
bindkey -M vicmd 'v' edit-command-line

# -------------------------------------------------------------------
# Environment & Path Setup
# -------------------------------------------------------------------
[[ -f ~/.zsh_aliases  ]] && source ~/.zsh_aliases
[[ -f ~/.zsh_exports  ]] && source ~/.zsh_exports

# -------------------------------------------------------------------
# Zinit Plugin Manager Setup
# -------------------------------------------------------------------
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -d "$ZINIT_HOME" ]]; then
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone --depth 1 https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# -------------------------------------------------------------------
# History Configuration
# FIX: Was entirely commented out. Native zsh history still backs
#      ^P/^N and within-session zle. Atuin handles cross-session sync,
#      so SHARE_HISTORY is not needed here — INC_APPEND_HISTORY is enough.
# -------------------------------------------------------------------

HISTSIZE=10000   # in-memory only — still needed for ^P/^N in current session
SAVEHIST=0       # don't write anything to disk
unset HISTFILE   # no file, ever

#-------------------------------------------------------------------
# Shell Options
# -------------------------------------------------------------------
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt INTERACTIVE_COMMENTS
setopt NO_BEEP
setopt EXTENDED_GLOB
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END
setopt PATH_DIRS
setopt AUTO_MENU
setopt AUTO_LIST
# GLOB_DOTS intentionally absent — makes * match dotfiles, which means
# `rm -rf *` deletes .git, .env, .ssh. Not a fish-like feature worth having.

# -------------------------------------------------------------------
# Completion System Initialization (MUST be before carapace)
# -------------------------------------------------------------------
autoload -Uz compinit
if [[ -n "${ZDOTDIR:-$HOME}/.zcompdump"(N.mh+24) ]]; then
    compinit
else
    compinit -C
fi

# -------------------------------------------------------------------
# Carapace Completion Setup
# -------------------------------------------------------------------
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
source <(carapace _carapace)

# -------------------------------------------------------------------
# Core Plugins
#
# FIX: Previously only zsh-syntax-highlighting had "wait lucid".
#      "zinit ice" applies to the VERY NEXT zinit call only.
#      All plugins now consistently deferred — loads at first prompt,
#      shell startup feels instant.
#
# FIX: Removed zdharma-continuum/history-search-multi-word — dead weight.
#      It would normally bind ^R, but Atuin owns ^R. Did nothing.
#
# FIX: Removed zsh-history-substring-search — Atuin owns up-arrow and
#      does the same job better. Having both caused a silent bindkey war
#      (up-arrow in viins was defined twice; last one won = Atuin anyway).
# -------------------------------------------------------------------
zinit ice wait lucid
zinit light zsh-users/zsh-syntax-highlighting

# zinit ice wait lucid
zinit light zsh-users/zsh-autosuggestions

# zinit ice wait lucid
zinit light Aloxaf/fzf-tab

# zinit ice wait lucid
zinit light MichaelAquilina/zsh-you-should-use

# OMZ snippets — load eagerly (completions depend on these being present at init)
# FIX: Removed OMZP::archlinux (you're migrating to Fedora)
# FIX: Removed OMZP::aws (not actively in use yet; add back when you start SAA prep)
# FIX: Removed OMZP::kubectx (redundant — kubectl plugin covers enough)
zinit snippet OMZL::git.zsh
zinit snippet OMZP::dnf
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::kubectl

zinit cdreplay -q

# -------------------------------------------------------------------
# Catppuccin Mocha — Syntax Highlighting Colors
# -------------------------------------------------------------------
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main cursor)
typeset -gA ZSH_HIGHLIGHT_STYLES

# Comments
ZSH_HIGHLIGHT_STYLES[comment]='fg=#585b70'

# Functions & Commands
ZSH_HIGHLIGHT_STYLES[alias]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[function]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[command]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#a6e3a1,italic'
ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=#fab387,italic'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#fab387'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#fab387'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#cba6f7'

# Built-ins
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=#a6e3a1'

# Punctuation
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#f38ba8'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg=#cdd6f4'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-unquoted]='fg=#cdd6f4'
ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]='fg=#cdd6f4'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]='fg=#f38ba8'
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#f38ba8'
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=#f38ba8'

# Strings
ZSH_HIGHLIGHT_STYLES[command-substitution-quoted]='fg=#f9e2af'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-quoted]='fg=#f9e2af'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#f9e2af'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument-unclosed]='fg=#eba0ac'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#f9e2af'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]='fg=#eba0ac'
ZSH_HIGHLIGHT_STYLES[rc-quote]='fg=#f9e2af'

# Variables
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#cdd6f4'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument-unclosed]='fg=#eba0ac'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#cdd6f4'
ZSH_HIGHLIGHT_STYLES[assign]='fg=#cdd6f4'
ZSH_HIGHLIGHT_STYLES[named-fd]='fg=#cdd6f4'
ZSH_HIGHLIGHT_STYLES[numeric-fd]='fg=#cdd6f4'

# Misc
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#eba0ac'
ZSH_HIGHLIGHT_STYLES[path]='fg=#cdd6f4,underline'
ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=#f38ba8,underline'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#cdd6f4,underline'
ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]='fg=#f38ba8,underline'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#cdd6f4'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#cba6f7'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-unclosed]='fg=#eba0ac'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=#cdd6f4'
ZSH_HIGHLIGHT_STYLES[arg0]='fg=#cdd6f4'
ZSH_HIGHLIGHT_STYLES[default]='fg=#cdd6f4'
ZSH_HIGHLIGHT_STYLES[cursor]='fg=#cdd6f4'

# -------------------------------------------------------------------
# Completion Styling (Catppuccin Mocha)
# -------------------------------------------------------------------
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%F{#f5c2e7}-- %d --%f'
zstyle ':completion:*:messages'     format '%F{#cba6f7}-- %d --%f'
zstyle ':completion:*:warnings'     format '%F{#f38ba8}-- no matches found --%f'
# single quotes correct here: $realpath is fzf-tab's variable, not shell's
zstyle ':fzf-tab:complete:cd:*'          fzf-preview 'eza --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*'  fzf-preview 'eza --color=always $realpath'

# -------------------------------------------------------------------
# Auto-suggestions Configuration
# Note: Atuin's init will prepend "atuin" to this strategy automatically,
#       making it effectively: (atuin history completion)
# -------------------------------------------------------------------
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#7f849c'

# -------------------------------------------------------------------
# Vi Mode Configuration
# -------------------------------------------------------------------
bindkey -v

# FIX: Was 1 (10ms). Too aggressive — escape sequences drop under SSH/tmux.
#      5 = 50ms, still fast enough for snappy mode switching.
export KEYTIMEOUT=5

# Cursor shape: block in normal mode, beam in insert mode
function zle-keymap-select {
    if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
        echo -ne '\e[1 q'
    else
        echo -ne '\e[5 q'
    fi
}
zle -N zle-keymap-select

function zle-line-init {
    echo -ne '\e[5 q'
    zle -K viins
}
zle -N zle-line-init

echo -ne '\e[5 q'   # Reset cursor to beam at shell startup

# Emacs-style bindings in insert mode (keep muscle memory for Ctrl combos)
bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^E' end-of-line
bindkey -M viins '^K' kill-line
bindkey -M viins '^U' kill-whole-line
bindkey -M viins '^W' backward-kill-word
bindkey -M viins '^Y' yank
bindkey -M viins '^P' up-line-or-history
bindkey -M viins '^N' down-line-or-history

# Navigation
bindkey -M viins '^[[C'   forward-char
bindkey -M viins '^[[D'   backward-char
bindkey -M viins '^[[3~'  delete-char
bindkey -M viins '^H'     backward-delete-char
bindkey -M viins '^[[1;5C' forward-word
bindkey -M viins '^[[1;5D' backward-word
bindkey -M viins '^[d'    kill-word
bindkey -M viins '^T'     fzf-file-widget

# FIX: ^[[A (up-arrow) NOT bound here for viins or vicmd anymore.
#      Atuin's init (eval below) owns up-arrow for history search.
#      Previously binding it to history-substring-search-up here
#      caused a silent conflict — one of them was always dead.

# -------------------------------------------------------------------
# Shell Integrations
# -------------------------------------------------------------------
command -v fzf      >/dev/null 2>&1 && eval "$(fzf --zsh)"
command -v zoxide   >/dev/null 2>&1 && eval "$(zoxide init --cmd cd zsh)"
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"
command -v atuin    >/dev/null 2>&1 && eval "$(atuin init zsh)"

# Command-not-found handler
# Works on both Arch (pkgfile) and Fedora (PackageKit-command-not-found)
if [[ -f /usr/share/zsh/site-functions/command_not_found_handler ]]; then
    source /usr/share/zsh/site-functions/command_not_found_handler
elif [[ -f /usr/share/doc/pkgfile/command-not-found.zsh ]]; then
    source /usr/share/doc/pkgfile/command-not-found.zsh
fi

# -------------------------------------------------------------------
# Source Additional Scripts
# -------------------------------------------------------------------
ZSHRC_D_DIR="$HOME/.config/zshrc.d"
if [[ -d "$ZSHRC_D_DIR" ]]; then
    for script in "$ZSHRC_D_DIR"/*.zsh; do
        [[ -f "$script" ]] && source "$script"
    done
fi

# -------------------------------------------------------------------
# Create Config Files if Missing
# -------------------------------------------------------------------
[[ ! -f ~/.zsh_aliases ]] && touch ~/.zsh_aliases
[[ ! -f ~/.zsh_exports ]] && touch ~/.zsh_exports

# -------------------------------------------------------------------
# Welcome Message
# -------------------------------------------------------------------
function show_ghosts() {
    echo -e "  \e[31m󰊠 \e[35m󰊠 \e[32m󰊠 \e[34m󰊠 \e[36m󰊠 \e[37m󰊠 \e[0m"
}
show_ghosts
