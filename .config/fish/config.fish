if status is-interactive
    # Commands to run in interactive sessions can go here

    # Getting rid of "last login" message and fish's greeting
    touch ~/.hushlogin
    set -U fish_greeting
    # activate https://starship.rs/
    # starship init fish | source

    # add ./bin to path for bundler binstubs
    set -gx PATH ./bin $PATH
end
