# Starship prompt
eval "$(starship init zsh)"
# Zinit setup
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

#add some environment specific scripts
source /home/deb/.config/zshrc.d

# Enhanced plugins for fish-like experience
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light zdharma/history-search-multi-word  # Fish-like history search

# Your existing snippets
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
bindkey '^[[A' history-search-backward  # Up arrow
bindkey '^[[B' history-search-forward   # Down arrow
bindkey '^[[C' forward-char             # Right arrow
bindkey '^[[D' backward-char            # Left arrow
bindkey '^[[3~' delete-char             # Delete
bindkey '^H' backward-delete-char       # Backspace
bindkey '^[[1;5C' forward-word          # Ctrl + Right
bindkey '^[[1;5D' backward-word         # Ctrl + Left
bindkey '^W' kill-region
bindkey '^[d' kill-word                 # Alt + d (like fish)
bindkey '^U' kill-whole-line           # Ctrl + U

# Enhanced History settings
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
setopt EXTENDED_HISTORY          # Add timestamps
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt SHARE_HISTORY            # Share history between sessions
setopt APPEND_HISTORY           # Append rather than overwrite
setopt INC_APPEND_HISTORY      # Add commands as they are typed

# Fish-like features
setopt AUTO_CD                  # Just type directory name to cd
setopt AUTO_PUSHD              # Make cd push old dir onto stack
setopt PUSHD_IGNORE_DUPS       # No duplicates in dir stack
setopt PUSHD_SILENT            # No dir stack after pushd/popd
setopt INTERACTIVE_COMMENTS     # Allow comments in interactive mode
setopt NO_BEEP                 # No beep on error
setopt EXTENDED_GLOB           # Extended globbing
setopt COMPLETE_IN_WORD        # Complete from both ends
setopt ALWAYS_TO_END           # Move cursor to end on complete
setopt PATH_DIRS               # Perform path search even on commands with /
setopt AUTO_MENU              # Show completion menu on tab
setopt AUTO_LIST              # List choices on ambiguous completion

# Enhanced completion styling
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format '%F{purple}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches found --%f'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Your aliases
alias vim='nvim'
alias c='clear'
alias pamcan=pacman
alias vim=nvim
alias ins='sudo pacman -S'
alias openfile="fzf | xargs -o xdg-open"
alias gsc="git status"
alias minecraft="java -jar ~/Downloads/minecraft/TLauncher.v10/TLauncher.jar"
alias term='kitty'
alias ls='eza --icons=always'
alias cat='bat'
alias man='batman'

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

# Auto-suggestions style (more fish-like)
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

#Setting some env varibles
export EDITOR="nvim"
export TERMINAL="kitty"
export PATH="/home/deb/.spicetify:$PATH"
#export MANPAGER="nvim -c 'set ft=man' -"

# Add to your .zshrc
function show_ghosts() {
    echo -e "  \e[31m󰊠 \e[35m󰊠 \e[32m󰊠 \e[34m󰊠 \e[36m󰊠 \e[37m󰊠 \e[0m"
}

# Add this at the end of your .zshrc after all other configurations
show_ghosts
