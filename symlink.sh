#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"    # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory
files="bashrc vimrc vim screenrc"    # list of files/folders to symlink in homedir

##########

# create dotfiles_old in homedir
echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p $olddir
echo "...done"

# change to the dotfiles directory
echo "Changing to the $dir directory"
cd $dir
echo "...done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks 
for file in $files; do
    if [ ! -h ~/.$file ]; then
        if [ -e ~/.$file ]; then
            echo "moving existing .$file to ~/$olddir"
            mv ~/.$file ~/dotfiles_old/
        fi
        echo "creating symlink to $file in home directory."
        ln -s $dir/$file ~/.$file
    fi
done
