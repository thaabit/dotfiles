#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

files="bashrc vimrc vim screenrc"    # list of files/folders to symlink in homedir

dotdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"    # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory

##########

# create dotfiles_old in homedir
if [ ! -e $olddir ]; then
    echo "creating $olddir"
    error=`mkdir -p $olddir 2>&1`
    if [ "$error" ]; then echo $error; fi
fi

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks 
for file in $files; do
    if [ ! -h ~/.$file ]; then
        if [ -e ~/.$file ]; then
            echo "moving existing .$file to ~/$olddir"
            error=`mv ~/.$file ~/dotfiles_old/ 2>&1`
            if [ "$error" ]; then echo $error; fi
        fi
        echo "creating symlink to $file in home directory."
        error=`ln -s $dotdir/$file ~/.$file 2>&1`
        if [ "$error" ]; then echo $error; fi
    fi
done

if [ ! -e /usr/bin/fixsshauth ]; then
    echo "creating symlink to fixsshauth in /usr/bin."
    error=`sudo ln -s $dotdir/fixsshauth /usr/bin/fixsshauth 2>&1`
    if [ "$error" ]; then echo $error; fi
fi
