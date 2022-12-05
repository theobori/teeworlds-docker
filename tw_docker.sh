#!/usr/bin/env bash

filename=$(echo $0 | rev | cut -d "/" -f 1 | rev)
# Possible values for $USERDIR
userdirs=(
    "$HOME/.local/share/teeworlds"
)
userdir="$HOME/.teeworlds"

# Finding the $USERDIR to mount the teeworlds user data (settings, etc..)
for dir in ${userdirs[*]}; do
    if [[ -d $dir ]]; then
        userdir=$dir
        break
    fi
done

function x11 {
    docker run -it -e DISPLAY=$DISPLAY \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -v $userdir:/root/.local/share/teeworlds \
        --device /dev/snd \
        --device /dev/dri:/dev/dri \
        $TW_IMG
}

function wayland {
    echo "TODO: wayland"
}

function help {
    echo "Usage:"
    echo "    It requires an env variable TW_IMG, its the image name"
    echo "    TW_IMG=teeworlds ./$filename option"
    echo
    echo "Options:"
    echo "     --help, -h      Show this message"
    echo "     --x11, -x       Using X11"
    echo "     --wayland, -w   Using Wayand"
}

# Error handling
[[ $# -lt 1 || ! $TW_IMG ]] && help && exit

# Parsing CLI arguments
for arg in $*; do
    case $arg in
        "-h"|"--help")
            help
            break
            ;;
        
        "-x"|"--x11")
            x11
            break
            ;;

        "-w"|"--wayland")
            wayland
            break
            ;;
    esac
done
