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
alias ll='ls -alh'
alias elog='tail -f /etc/httpd/logs/error_log'
alias sr='screen -d -R'
alias hr='sudo /etc/init.d/httpd graceful'
alias mc='sudo /etc/init.d/memcached restart'
alias mv='mv -i'
alias rm='rm -i'
alias cp='cp -i'
alias clean='find . -name .#* | xargs rm -f && find . -name *.swp | xargs rm -f'
alias vv="du --max-depth=1 -k | sort -nr | cut -f2 | xargs -d '\n' du -sh"
alias gitlog="git log --graph --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(bold white). %an%C(reset)%C(bold yellow)%d%C(reset)' --abbrev-commit --date=relative"

export GREP_OPTIONS='-rI --exclude=*{swp,Entries} --color'
export GREP_COLOR=32

export CVSEDITOR='vim'
export EDITOR="vim"
export VISUAL="vim"
alias vi='vim'

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


# server specific unmanaged definitions
if [ -f ~/.bash_extra ]; then
	. ~/.bash_extra
fi
