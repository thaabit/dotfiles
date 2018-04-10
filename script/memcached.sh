#!/bin/bash
dotdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"    # dotfiles directory
mc=$dotdir/script/memcached
mc_init='/etc/init.d/memcached'
if ! sudo test -h $mc_init; then
    error=`sudo ln -s $mc $mc_init 2>&1`
    if [ "$error" ]; then echo $error; fi
fi
