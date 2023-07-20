#!/usr/bin/env bash

# TODO: add check for running under NixOS

# Welcome and ability to bail

echo -e "-- Post Installation Script!"

if [ -n "$1" ]; then
    echo -e " [VV] The user you're about to set up is $1."
else
    echo -e "You have to supply a username to set up! Run this script with a username as the first argument."
    return 1
fi

while true; do
read -p " [??] Do you want to proceed? (y/n) " yn
    case $yn in 
        [yY] ) echo -e " [VV] Continuing."
            break;;
        [nN] ) echo -e " [XX] Exiting.";
            return;;
        * ) echo -e " [XX] Invalid Response.";;
    esac
done

echo -e " [!!] Starting setup for user $1."

# Directory declarations

HOME_DIR=/mnt/home/$1
echo -e " [..] Home directory for this script will be: $HOME_DIR"

echo -e " [..] Creating $HOME_DIR/.tmp/"
mkdir -p $HOME_DIR/.tmp/
DOTFILES_DIR=$HOME_DIR/.tmp/dotfiles

echo -e " [..] Script ran from $PWD"
SCRIPTS_DIR=$PWD/scripts

# NixOS check

echo -e " [..] Checking if this script is ran from NixOS."

cat /etc/os-release | grep -i "NAME=NixOS">/dev/null2>&1

if [ $? -ne 0 ]; then
    echo -e " [xx] Script isn't ran under NixOS!"
    while true; do
    read -p " [xx] Only proceed if you know what you're doing. Proceed? (y/n) " yn2
        case $yn2 in 
            [yY] ) echo -e " [VV] Continuing."
                break;;
            [nN] ) echo -e " [XX] Exiting.";
                return;;
            * ) echo -e " [XX] Invalid Response.";;
        esac
    done
else
    echo -e " [..] NixOS is detected, continuing."
fi

# Dotfiles cloning and installation

if [ -d "$DOTFILES_DIR" ]; then
    while true; do
    read -p " [xx] $DOTFILES_DIR exists, Remove it? (y/n) " yn1
        case $yn1 in 
            [yY] ) echo -e " [VV] Continuing."
                break;;
            [nN] ) echo -e " [XX] Exiting.";
                return;;
            * ) echo -e " [XX] Invalid Response.";;
        esac
    done
    rm -rf $DOTFILES_DIR
fi

echo -e " [..] Cloning dotfiles into $DOTFILES_DIR"

nix-shell -p git --command "git clone --depth 1 https://github.com/RealFX-Code/dotfiles.git $DOTFILES_DIR"

if [ "$(uname -o)" = "Msys" ]; then
    echo -e " [!!] Msys detected, not running dotfiles install script for your own safety."
else
    echo -e " [..] Installing dotfiles for: Hyprland, Hyprpaper, i3, Kitty, Rofi, Sway, Waybar, and Wofi."
    cp -R $DOTFILES_DIR/Linux/.config $HOME_DIR
    cp -r $DOTFILES_DIR/Linux/Pictures $HOME_DIR
    cp $DOTFILES_DIR/Linux/.zshrc $HOME_DIR/.zshrc
    cp $DOTFILES_DIR/Linux/.profile $HOME_DIR/.profile
fi

# Wrapper scripts

echo -e " [..] Installing wrapper-scripts"

mkdir -p $HOME_DIR/.local
mkdir -p $HOME_DIR/.local/bin

cp $SCRIPTS_DIR/* $HOME_DIR/.local/bin/

chmod +x $HOME_DIR/.local/bin/startSway

echo -e " [!!] You've successfully installed NixOS! You can now reboot."
