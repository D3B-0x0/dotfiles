# Source aliases and exports
source ~/.zsh_aliases
source ~/.zsh_exports

# Create .zsh_aliases file if it doesn't exist
if [ ! -f ~/.zsh_aliases ]; then
    cat > ~/.zsh_aliases << 'EOL'
EOL
fi

# Create .zsh_exports file if it doesn't exist
if [ ! -f ~/.zsh_exports ]; then
    cat > ~/.zsh_exports << 'EOL'
    # Check the previous response for the comprehensive exports content
EOL
fi

# Starship prompt
eval "$(starship init zsh)"

# Zinit setup
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# Add environment specific scripts
source /home/ghost/.config/zshrc.d

# Enhanced plugins for fish-like experience
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light zdharma/history-search-multi-word

# Plugin snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit
zinit cdreplay -q

# Fish-like keybindings
bindkey -e
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
bindkey '^[[C' forward-char
bindkey '^[[D' backward-char
bindkey '^[[3~' delete-char
bindkey '^H' backward-delete-char
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^W' kill-region
bindkey '^[d' kill-word
bindkey '^U' kill-whole-line

# History settings
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY

# Fish-like features
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

# Enhanced completion styling
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%F{#f5c2e7}-- %d --%f'
zstyle ':completion:*:messages' format '%F{#cba6f7}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{#f38ba8}-- no matches found --%f'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color=always $realpath'

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

# Fish-like syntax highlighting colors
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[command]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[command-substitution]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'

# Auto-suggestions style
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

# Show ghosts function
function show_ghosts() {
    echo -e "  \e[31m󰊠 \e[35m󰊠 \e[32m󰊠 \e[34m󰊠 \e[36m󰊠 \e[37m󰊠 \e[0m"
}
show_ghosts

fortune -a | gum style --border rounded --margin "1" --padding "1 2" --bold --foreground 9
