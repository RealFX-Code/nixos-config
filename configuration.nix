{ config, pkgs, inputs, frostix, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./config.d
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.05";
}
