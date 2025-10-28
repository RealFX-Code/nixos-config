{ config, pkgs, inputs, frostix, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Oslo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # I'm norwegian, and speak english, but I like dates and other values in Norwrgian
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nb_NO.UTF-8";
    LC_IDENTIFICATION = "nb_NO.UTF-8";
    LC_MEASUREMENT = "nb_NO.UTF-8";
    LC_MONETARY = "nb_NO.UTF-8";
    LC_NAME = "nb_NO.UTF-8";
    LC_NUMERIC = "nb_NO.UTF-8";
    LC_PAPER = "nb_NO.UTF-8";
    LC_TELEPHONE = "nb_NO.UTF-8";
    LC_TIME = "nb_NO.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "no";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "no";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.leah = {
    isNormalUser = true;
    description = "Leah";
    extraGroups = [ "networkmanager" "wheel" "adbusers" "plugdev" "dialout" "libvirtd" "docker" "audio"];
    packages = with pkgs; [];
    shell = pkgs.fish;
  };

  users.users.root = {
    shell = pkgs.bash;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [

    #
    # Terminal apps
    #

    gh
    lz4
    eza
    vim
    git
    bat
    zip
    edl
    file
    grim
    tree
    btop
    wget
    slurp
    p7zip
    unzip
    psmisc
    screen
    hyfetch
    openssl
    usbutils
    heimdall
    git-repo # Repo for AOSP
    playerctl
    python313
    nodejs_22
    fastfetch
    wl-clipboard
    frostix.odin4
    wireguard-tools
    multipath-tools
    python312Packages.pip
    frostix.mtkclient-git

    #
    # Gui Apps
    #

    mpv
    mako
    wofi
    ghex
    beeper
    vesktop
    bottles
    cardinal
    wdisplays
    audacious
    vscode-fhs
    floorp-bin
#    rpi-imager
    zed-editor
    obs-studio
    gnome-boxes
    xfce.thunar
    pavucontrol
    qbittorrent
    virt-manager
    themechanger
    audacious-plugins
    telegram-desktop

    #
    # Gui Libs
    #

    egl-wayland
    libsForQt5.qt5ct
    kdePackages.qt6ct
    adwaita-icon-theme
    gnome-themes-extra
    xfce.thunar-volman
    kdePackages.qtwayland
    frostix.rose-pine-kvantum
    xfce.thunar-archive-plugin
    kdePackages.qtstyleplugin-kvantum

    #
    # Games
    #
    jre8 # Java 8
    zulu # Java 21
    mangohud
    prismlauncher

  ];

  # I want mtkclient to install it's udev rules
  services.udev.packages = [
    frostix.mtkclient-git
  ];

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="1235", ATTR{idProduct}=="0035", MODE="0666"
  '';

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = [
    pkgs.stdenv.cc.cc
    pkgs.glibc
    pkgs.libsecret
  ];

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  environment.variables = {
    GTK_THEME = "Adwaita:dark";
  };

  # Steam :D
  programs.steam = {
    enable = true;
    protontricks.enable = true;
  };

  # Fonts :D
  fonts = {
    packages = with pkgs; [
      nerd-fonts.iosevka
      nerd-fonts.iosevka-term
    ];
    fontDir.enable = true;
  };

  qt = {
    enable = true;
    style = "kvantum";
    platformTheme = "qt5ct";
  };

  # Terminal stuff !! :D

  # Autologin
  #systemd.user.services.sway-autostart = {
  #  enable = true;
  #  description = "Autologin";
  #  after = [ "graphical-session.target" ];
  #  wantedBy = [ "default.target" ];
  #  serviceConfig = {
  #    ExecStart = "${pkgs.uwsm}/bin/uwsm start ${pkgs.swayfx}/bin/sway";
  #  };
  #};
  services.getty = {
    autologinUser = "leah";
    autologinOnce = true;
  };

  programs.adb.enable = true;

  programs.thunderbird.enable = true;

  environment.shellAliases = {
    ls = "eza --color=always --group-directories-first --icons -alg";
    # Temporary alias to "hot-reload" nixos from my test machine
    updatenix = "wget http://192.168.1.14:3000/configuration.nix; sudo mv configuration.nix /etc/nixos/configuration.nix";
  };

  programs.fish = {
    enable = true;
  };

  programs.starship = {
    enable = true;
  };

  # Desktop environment

  programs.uwsm = {
    enable = true;
    waylandCompositors = {
      sway = {
        prettyName = "Sway";
        comment = "Run Sway with UWSM";
        binPath = "/run/current-system/sw/bin/sway";
      };
    };
  };

  programs.sway = {
    enable = true;
    wrapperFeatures = {
      base = true;
      gtk = true;
    };
    package = pkgs.swayfx; # SwayFX ftw
    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland-egl
      export _JAVA_AWT_WM_NONREPARENTING=1
    '';
  };

  programs.waybar.enable = true;

  programs.foot = {
    enable = true;
    theme = "rose-pine";
    settings = {
      main = {
        font = "IosevkaTerm Nerd Font Mono:size=14";
        pad = "16x16";
      };
      scrollback = {
        # 10 Million
        lines = 10000000;
      };
      cursor = {
        style = "beam";
        blink = "yes";
      };
      colors = {
        alpha = 0.8;
      };
    };
  };

  services.gvfs.enable = true;

  # Soteria is a polkit agent
  security.soteria.enable = true;

  # XDG Desktop Portal crap
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    wlr.enable = true; # Use WLR xdg desktop portal for a wlr session
  };

  # Pipewire :D
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  networking.firewall.enable = false;
  networking.wireguard.enable = true;

  #
  # Background services
  #

  services.openssh.enable = true;

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
      };
    };
    docker = {
      enable = true;
      enableOnBoot = true;
    };
  };

  #
  # Nix stuff
  #

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 15d";
    };
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  system.stateVersion = "25.05";

}
