{ pkgs, frostix, ...}: {

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

  # For thumbnails in Thunar
  services.tumbler.enable = true;

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

  programs.thunderbird.enable = true;

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

  environment.systemPackages = with pkgs; [
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
    remmina
    cardinal
    wdisplays
    audacious
    ghidra-bin
    vscode-fhs
    floorp-bin
    rpi-imager
    zed-editor
    obs-studio
    blender-hip
    gnome-boxes
    xfce.thunar
    pavucontrol
    qbittorrent
    arduino-ide
    lunar-client
    virt-manager
    themechanger
    universal-ctags
    telegram-desktop
    audacious-plugins
    ghidra-extensions.lightkeeper
    ghidra-extensions.machinelearning

    #
    # Gui Libs
    #

    libnotify
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

    zulu
    mangohud
    prismlauncher
  ];

}
