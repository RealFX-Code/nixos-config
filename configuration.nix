# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running "nixos-help").

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
  boot.loader.grub.default = "2";
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
    keyMap="no";
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Define a user account. Don't forget to set a password with "passwd".
  users.users.leah = {
    isNormalUser = true;
    shell= pkgs.zsh;
    extraGroups = [ "wheel" "libvirtd" "kvm" ]; # Enable "sudo" for the user.
  };

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = ["JetBrainsMono"];})
    font-awesome
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    terminus-nerdfont
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  programs.zsh.enable = true; # temp fix for zsh to be available as a default shell
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
    bat
    htop
    btop
    wlroots
    wofi
    hyprland
    hyprpaper
    sway
    vulkan-validation-layers
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
    egl-wayland
    foot
    slurp
    wl-clipboard
    grim
    discord
    firefox # incase chrome breaks itself
    cider # apple music :D
    usbutils
    networkmanagerapplet
    vscode.fhs
    yaru-theme
    glib
  ];
  
  # dconf :D
  programs.dconf.enable = true;

  # Experimental support for Hyprland with Waybar
  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs(old: {
      mesonFlags = (old.mesonFlags or []) ++ [ "-Dexperimental=true" ];
      patches = (old.patches or []) ++ [
        (pkgs.fetchpatch {
          name = "fix waybar hyprctl";
          url = "https://aur.archlinux.org/cgit/aur.git/plain/hyprctl.patch?h=waybar-hyprland-git";
          sha256 = "sha256-pY3+9Dhi61Jo2cPnBdmn3NUTSA8bAbtgsk2ooj4y7aQ=";
        })
      ];
    });
  };  

  # Set defualt browser
  xdg.mime.enable = true;
  xdg.mime.defaultApplications = {
    "text/html" = "/home/leah/.local/bin/google-chrome";
    "x-scheme-handler/http" = "/home/leah/.local/bin/google-chrome";
    "x-scheme-handler/https" = "/home/leah/.local/bin/google-chrome";
    "x-scheme-handler/about" = "/home/leah/.local/bin/google-chrome";
    "x-scheme-handler/unknown" = "/home/leah/.local/bin/google-chrome";
  };

  environment.sessionVariables.DEFAULT_BROWSER = "/home/leah/.local/bin/google-chrome";

  # lord forgive me
  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1u"
    "python-2.7.18.6"
  ];

  # Fix for Electron apps to run under wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Enable SSH Remote Login
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };

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
  system.autoUpgrade.allowReboot = false; 
  system.autoUpgrade.channel = "https://channels.nixos.org/nixos-23.05";
  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
