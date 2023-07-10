# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running "nixos-help").

# TODO: proper implementation of all software... E.G.:
# programs.zsh.enable = true;
# programs.sway = {
#   enable = true;
#   wrapperFeatures.gtk = true;
# }
#
# ref this: https://nixos.wiki/wiki/Sway

# TODO: Remove whatever packages require outdated/insecure packages. See line: 128 -> 131. 

{ config, pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfree = true;
  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;

  imports = [
    ./hardware-configuration.nix
  ];

  # grub :D
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "leah-nixos"; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Oslo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    packages=[ pkgs.terminus_font ];
    font="${pkgs.terminus_font}/share/consolefonts/ter-i22b.psf.gz";
    keyMap="no"
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Define a user account. Don't forget to set a password with "passwd".
  users.users.leah = {
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" "kvm" ]; # Enable "sudo" for the user.
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget
    neovim
    starship
    brave
    cargo
    dunst
    flameshot
    fontconfig
    freetype
    gcc
    gh
    git
    github-desktop
    gnugrep
    gnumake
    fdisk
    kitty
    luarocks
    libvirt
    neovim
    ninja
    nodejs
    feh
    pavucontrol
    polkit_gnome
    python3Full
    python.pkgs.pip
    qemu
    terminus-nerdfont
    tldr
    trash-cli
    unzip
    variety
    virt-manager
    xdg-desktop-portal-gtk
    xfce.thunar

    # my packages
    google-chrome # yes i use chrome :D
    hyfetch
    wlroots
    wofi
    hyprland
    hyprpaper
    sway
    vulkan-validation-layers
    waybar
    exa
    hollywood
    jetbrains-mono
    prismlauncher
    temurin-jre-bin
    temurin-jre-bin-8
    wdisplays
    bat
    tree
    xwayland
    wayland
    bash
    zsh
    egl-wayland
    foot
  ];

  # lord forgive me
  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1u"
    "python-2.7.18.6"
  ];

  # List services that you want to enable:
  virtualisation.libvirtd.enable = true; 

  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
  security.polkit.enable = true;
  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
    extraConfig = ''
      DefaultTimeoutStopSec=10s
    '';
  }; 

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;
  networking.enableIPv6 = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;
  system.autoUpgrade.enable = true;  
  system.autoUpgrade.allowReboot = true; 
  system.autoUpgrade.channel = "https://channels.nixos.org/nixos-23.05";
  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
