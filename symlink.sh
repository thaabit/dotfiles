#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dotfiles="bashrc vimrc bundles.vim screenrc gitignore"    # list of files/folders to symlink in homedir
vimfiles=$HOME/.vim
bins="zcp fixsshauth compile mysql_dump_remote_db mysql_user_add"            # list of files to put in ~/bin

dotdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"    # dotfiles directory
olddir=$HOME/dotfiles_old                                         # old dotfiles backup directory
bindir=$HOME/bin                                                  # user bin dir
bundle_path=$vimfiles/bundle/

needed_paths="$bindir $vimfiles $bundle_path"
##########

for needed_path in $needed_paths; do
    if [ ! -e $needed_path ]; then
        echo "creating $needed_path"
        error=`mkdir -p $needed_path 2>&1`
        if [ "$error" ]; then echo $error; fi
    fi
done

# install vundle
vundle_path=$bundle_path/Vundle.vim
if [ ! -e $vundle_path/ ]; then
    `git clone https://github.com/VundleVim/Vundle.vim.git $vundle_path`
fi
echo "updating vundle installed at $vundle_path"
start_dir=$pwd
cd $vundle_path
`git pull`
cd $start_dir

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks 
for title in $dotfiles; do
    link="$HOME/.$title"
    path=$dotdir/dotfiles/$title
    if [ ! -h $link ]; then
        if [ -e $link ]; then

            # create dotfiles_old in homedir
            if [ ! -e $olddir ]; then
                echo "creating $olddir"
                error=`mkdir -p $olddir 2>&1`
                if [ "$error" ]; then echo $error; fi
            fi

            echo "moving existing $link to $olddir"
            error=`mv $link $olddir 2>&1`
            if [ "$error" ]; then echo $error; fi
        fi
        echo "creating symlink for $link"
        error=`ln -s $path $link 2>&1`
        if [ "$error" ]; then echo $error; fi
    fi

    # redo symlink if broken
    if [[ -L "$link" ]] && [[ ! -a "$link" ]];then
        echo "fixing symlink $link->$path"
        error=`ln -fs $path $link 2>&1`
    fi
done


for title in $bins; do
    link=$bindir/$title
    path=$dotdir/bin/$title
    if [ ! -h $link ]; then
        if [ ! -e $link ]; then
            echo "creating symlink $link->$path"
            error=`ln -s $path $link 2>&1`
            if [ "$error" ]; then echo $error; fi
        fi
    fi

    # redo symlink if broken
    if [[ -L "$link" ]] && [[ ! -a "$link" ]];then
        echo "fixing symlink $link->$path"
        error=`ln -fs $path $link 2>&1`
    fi
done

echo "installing plugins for vim"
vim -u $HOME/.bundles.vim +BundleInstall +q
