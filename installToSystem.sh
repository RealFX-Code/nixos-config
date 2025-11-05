#!/usr/bin/env bash

set -e

echo "!!! WARNING !!! This will override your current configuration !!!"
echo "You have a 5 second grace period to exit!"

sleep 5

sudo cp -fv flake.nix /etc/nixos/
sudo cp -fv flake.lock /etc/nixos/
sudo cp -fv configuration.nix /etc/nixos/
sudo cp -rfv config.d /etc/nixos/
