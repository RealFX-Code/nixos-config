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
    extraGroups = [ "networkmanager" "wheel" "adbusers" "plugdev" "dialout" "libvirtd" ];
    packages = with pkgs; [];
    shell = pkgs.fish;
  };

  users.users.root = {
    shell = pkgs.bash;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    gh
    eza
    vim
    git
    bat
    zip
    tree
    btop
    wget
    p7zip
    unzip
    floorp
    beeper
    hyfetch
    vesktop
    git-repo
    mangohud
    nodejs_22
    fastfetch
    wdisplays
    rpi-imager
    zed-editor
    egl-wayland
    virt-manager
    telegram-desktop
    xfce.thunar
    xfce.thunar-volman
    xfce.thunar-archive-plugin
    python312Packages.pip
    kdePackages.qtwayland
    frostix.mtkclient-git

    # Themes
    themechanger
    adwaita-icon-theme
    gnome-themes-extra
    frostix.rose-pine-kvantum
    libsForQt5.qt5ct
    kdePackages.qt6ct
    kdePackages.qtstyleplugin-kvantum

    #
    # Games
    #
    prismlauncher
    jre8 # Java 8
    zulu # Java 21

  ];

  # I want mtkclient to install it's udev rules
  services.udev.packages = [
    frostix.mtkclient-git
  ];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = [
    pkgs.stdenv.cc.cc
    pkgs.glibc
    pkgs.libsecret
  ];

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
    extraPackages = with pkgs; [
      mako # Notification Daemon
      wofi # Application launcher
      grim slurp # Screenshot dependencies
      wl-clipboard # I use this all the time
      playerctl # Media keys use this internally
      pavucontrol # Nice to have
    ];
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

  #
  # Background services
  #

  services.openssh.enable = true;

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [(pkgs.OVMF.override {
          secureBoot = true;
          tpmSupport = true;
        }).fd];
      };
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
