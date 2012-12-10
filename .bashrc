# Initialize environment for both login and non-login-sheels
[ -f ~/.bash_env ] && source ~/.bash_env

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
export HISTSIZE=8000

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Add a macbook battery status indicator to bash prompt. 
# Mac only!
batterystatus() {
    bmax=$(ioreg -rc  AppleSmartBattery |egrep MaxCapacity | cut -f2 -d=)
    bcur=$(ioreg -rc  AppleSmartBattery |egrep CurrentCapacity | cut -f2 -d=)
    filled=$(echo "scale=2;($bcur/$bmax)  * 10 / 2 " | bc -l | xargs printf "%1.0f")
    [ $bcur -lt $bmax ] && for i in {1..5} ; do 
        if [ $i -le $filled ] ; then
            echo -en "\xe2\x96\xa3"  
        else 
            echo -en "\xe2\x96\xa1"
        fi 
    done && echo -n " "
}

function parse_git_branch {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# custom prompt
_PROMPT_PREFIX="${debian_chroot:+($debian_chroot)}${YROOT_PROMPT}"
_UH_COLOR=$(expr $RANDOM % 6 + 31)
_UH_COLOR="\[\033[1;$(expr $RANDOM % 6 + 31)m\]"
_UH_UNDERLINE="\[\033[0;4m\]"
_UH_NONE="\[\033[0m\]";
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${BASH_TITLE-${USER}@${HOSTNAME}} \007"'
    ;;  
screen)
    PROMPT_COMMAND='echo -ne "\033k${BASH_TITLE-${USER}@${HOSTNAME}} \033\\"'
    FLAGS='s'
    ;;  
*)
    ;;  
esac

case "$(uname)" in
    Darwin)
        PS1="$_PROMPT_PREFIX[\$(batterystatus)\[$_UH_COLOR\u(\j$FLAGS)@\h $_UH_UNDERLINE\w\$(parse_git_branch)$_UH_NONE]\$ "
        ;;
    *)
        PS1="$_PROMPT_PREFIX[\[$_UH_COLOR\u(\j$FLAGS)@\h $_UH_UNDERLINE\w\$(parse_git_branch)$_UH_NONE]\$ "
        ;;
esac

eval "$PROMPT_COMMAND"
unset _PROMPT_PREFIX _UH_COLOR _UH_BOLD _UN_UNDERLINE

[ -f ~/.bash_aliases ] && source ~/.bash_aliases
