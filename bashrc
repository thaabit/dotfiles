# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi


# server specific unmanaged definitions
if [ -f ~/.bash_extra ]; then
	. ~/.bash_extra
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
alias htest="sudo /usr/sbin/apachectl configtest"
alias mc='sudo /etc/init.d/memcached restart'
alias mv='mv -i'
alias rm='rm -i'
alias cp='cp -i'
alias clean='find . -name .#* | xargs rm -f && find . -name *.swp | xargs rm -f'
alias vv="du --max-depth=1 -k | sort -nr | cut -f2 | xargs -d '\n' du -sh"
alias gitlog="git log --graph --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(bold white). %an%C(reset)%C(bold yellow)%d%C(reset)' --abbrev-commit --date=relative"

export GREP_OPTIONS='-rI --exclude=*{swp,Entries} --color --perl-regexp'
export GREP_COLOR=32

export CVSEDITOR='vim'
export EDITOR="vim"
export VISUAL="vim"
alias vi='vim'


# git
function _git_branch {
    local branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
    if [ $branch ];
        then printf " [%s]" $branch;
    fi
}

function _git_desc {
    local branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
    local description="$(git config branch.$branch.description)";
    if [[ ! -z $description ]]; then
        echo " ($description)";
    fi
}

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

bluebg="\[\033[48;5;21m\]\[\033[38;5;15m\]";
redbg="\[\033[48;5;001m\]\[\033[38;5;15m\]";
greenbg="\[\033[48;5;22m\]\[\033[38;5;46m\]";
yellowbg="\[\033[48;5;003m\]\[\033[38;5;226m\]";

bg=$reset
dirprompt="${blue}\w"
spacer="${orange}>"

if [[ $(hostname) =~ beta ]]; then
    bg="${yellowbg}"
elif [[ $(hostname) =~ macbook ]]; then
    bg="${white}"
elif [[ $(hostname) =~ alpha|dev ]]; then
    bg="${green}"
elif [[ $(hostname) =~ roster|projects ]]; then
    bg="${greenbg}"
elif [[ $(hostname) =~ zugzug ]]; then
    bg="${bluebg}"
elif [[ $(hostname) =~ bluehost.com|gnhill.net|box984|jarth.org ]]; then
    bg="${redbg}"
else
    bg="${redbg}UNKNOWN!!!";
fi
userprompt="${bg}\H${reset}"

if git --version &>/dev/null; then
    export PS1="${userprompt}${dirprompt}${orange}\$(_git_branch)${purple}\$(_git_desc)${reset} \$ "
else 
    #export PS1="\[\e[1;37;41m\][\\u@\\h \\W]\[\e[m\]\\$ "
    export PS1="${userprompt}${dirprompt}${reset} \$ "
fi
export MYSQL_PS1="\\u@\\h:\\d> "
#export MYSQL_PS1=$(echo -e "\x1B[1;37;43m\\u@\\h:\\d>\x1B[0m ")


