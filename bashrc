# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi
if [ -n "$STY" ]; then
        export TERM='screen'
elif [ -e /usr/share/terminfo/x/xterm-256color ]; then
        export TERM='xterm-256color'
else
        export TERM='xterm-color'
fi

# User specific aliases and functions
reset="\[$(tput sgr0)\]";
bold="\[$(tput bold)\]";

orange="\[\033[38;5;172m\]";
blue="\[\033[38;5;75m\]";
purple="\[\033[38;5;99m\]";
pink="\[\033[38;5;213m\]";
red="\[\033[38;5;196m\]";
green="\[\033[38;5;76m\]";
yellow="\[\033[38;5;227m\]";
cyan="\[\033[38;5;87m\]";
magenta="\[\033[38;5;171m\]";
white="\[\033[38;5;231m\]";
whatever="\[\033[38;5;33m\]";

spacer="${orange}>";

# git
function _git_branch {
    local gitbranch=`git symbolic-ref HEAD 2>/dev/null | cut -d"/" -f 3,4`;
    if [ $gitbranch ];
        then printf " [%s]" $gitbranch;
    fi
}

function _git_desc {
    local gitbranch=`git symbolic-ref HEAD 2>/dev/null | cut -d"/" -f 3,4`;
    local description=`git config branch.$gitbranch.description`;
    if [ $description ];
        then printf " (%s)" $description;
    fi
}

userprompt="${green}\u@\h"
dirprompt="${whatever}\w"
export PS1="${reset}${userprompt}${dirprompt}${orange}\$(_git_branch)${purple}\$(_git_desc)${reset} \$ "
