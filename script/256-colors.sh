#!/bin/bash
    
# This program is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What The Fuck You Want
# To Public License, Version 2, as published by Sam Hocevar. See
# http://sam.zoy.org/wtfpl/COPYING for more details.
    
for fgbg in 48 ; do #Foreground/Background
    for color in {0..256} ; do #Colors
        for bg in {0..256} ; do #Colors
            #Display the color
            var=$(printf '%03d-%03d' "$color" "$bg")
            echo -en "\e[38;5;${color}m\e[48;5;${bg}m ${var}\e[0m"
            #Display 10 colors per lines
            if [ $((($color + 1) % 50)) == 0 ] ; then
                echo #New line
            fi
        done
    done
    echo #New line
done
    
exit 0
