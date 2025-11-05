{ pkgs, frostix, ...}: {

  services.udev = {
    packages = [
      frostix.mtkclient-git
    ];
    extraRules = ''
      SUBSYSTEM=="usb", ATTR{idVendor}=="1235", ATTR{idProduct}=="0035", MODE="0666"
    '';
  };

  programs.adb.enable = true;

  environment.shellAliases = {
    ls = "eza --color=always --group-directories-first --icons -alg";
  };

  programs.fish = {
    enable = true;
  };

  programs.starship = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
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
    sshpass
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
  ];

}
