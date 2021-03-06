# Autocompletion for bash shell.
#
# You may put this file to a directory used by bash-completion:
#
#     mkdir -p ~/.local/share/bash-completion/completions
#     ln -s "/path/to/lf.bash" ~/.local/share/bash-completion/completions
#

_lf () {
    local -a opts=(
        -command
        -cpuprofile
        -doc
        -last-dir-path
        -memprofile
        -remote
        -selection-path
        -server
        -version
        -help
    )
    if [[ $2 == -* ]]; then
        COMPREPLY=( $(compgen -W "${opts[*]}" -- "$2") )
    else
        COMPREPLY=( $(compgen -f -d -- "$2") )
    fi
}

complete -o filenames -F _lf lf lfcd
