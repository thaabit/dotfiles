#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

files="bashrc vimrc vim screenrc gitignore"    # list of files/folders to symlink in homedir
bins="fixsshauth compile"            # list of files to put in ~/bin

dotdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"    # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory
bindir=~/bin             # user bin dir

##########


# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks 
for file in $files; do
    if [ ! -h ~/.$file ]; then
        if [ -e ~/.$file ]; then

            # create dotfiles_old in homedir
            if [ ! -e $olddir ]; then
                echo "creating $olddir"
                error=`mkdir -p $olddir 2>&1`
                if [ "$error" ]; then echo $error; fi
            fi

            echo "moving existing .$file to ~/$olddir"
            error=`mv ~/.$file ~/dotfiles_old/ 2>&1`
            if [ "$error" ]; then echo $error; fi
        fi
        echo "creating symlink to $file in home directory."
        error=`ln -s $dotdir/$file ~/.$file 2>&1`
        if [ "$error" ]; then echo $error; fi
    fi
done

if [ ! -e $bindir ]; then
    echo "creating $bindir"
    error=`mkdir -p $bindir 2>&1`
    if [ "$error" ]; then echo $error; fi
fi

for bin in $bins; do
    if [ ! -e $bindir/$bin ]; then
        echo "creating symlink to $bin in ~/bin."
        error=`ln -s $dotdir/$bin $bindir/$bin 2>&1`
        if [ "$error" ]; then echo $error; fi
    fi
done

mc=$dotdir/memcached
mc_init='/etc/init.d/memcached'
if ! sudo test -h $mc_init; then
    error=`sudo ln -s $mc $mc_init 2>&1`
    if [ "$error" ]; then echo $error; fi
fi
