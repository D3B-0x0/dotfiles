function fish_prompt -d "Write out the prompt"
    # This shows up as USER@HOST /home/user/ >, with the directory colored
    # $USER and $hostname are set by fish, so you can just use them
    # instead of using `whoami` and `hostname`
    printf '%s@%s %s%s%s > ' $USER $hostname \
        (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
end

if status is-interactive
    # Commands to run in interactive sessions can go here
    set fish_greeting

end

if test -f ~/.cache/ags/user/generated/terminal/sequences.txt
    cat ~/.cache/ags/user/generated/terminal/sequences.txt
end

alias pamcan=pacman
alias vim=nvim
alias ins='sudo pacman -S'
alias openfile="fzf | xargs -o xdg-open"

abbr -a ls lsd
abbr -a cat bat
# function fish_prompt
#   set_color cyan; echo (pwd)
#   set_color green; echo '> '
# end
fish_add_path /home/deb/.spicetify
set -gx EDITOR nvim
set -gx TERMINAL kitty
set -g HISTFILE /dev/null
alias term='kitty'

starship init fish | source
source /usr/share/cachyos-fish-config/cachyos-config.fish
set _OLD_VIRTUAL_PATH "$PATH"
zoxide init --cmd cd fish | source


set -x LANG en_US.UTF-8
set -x LANGUAGE en_US.UTF-8
set -x LC_ALL en_US.UTF-8
