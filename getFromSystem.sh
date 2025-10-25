#!/usr/bin/env bash

cp -fv /etc/nixos/* .

# We don't want this comitted.
rm hardware-configuration.nix

