#! /bin/bash

# enable color support of ls, grep and also add handy aliases
if [ "$TERM" != "dumb" ];then
    case "$(uname)" in
        Linux)
            which dircolors > /dev/null && eval "`dircolors -b`"
            alias ls='ls --color=auto'
            (grep --help | grep -- --color >/dev/null) && alias grep='grep --color=auto'
        ;;
        FreeBSD|Darwin)
            export LSCOLORS='ExGxcxdxCxegedabagacad'
            alias ls='ls -G'
            (grep --help 2>&1 | grep -- --color >/dev/null) && alias grep='grep --color=auto'
        ;;
    esac
fi

alias ll='ls -lrt'
alias lla='ls -alrt'
alias 'ps?'='ps ax | grep'
alias tmux="tmux a"
