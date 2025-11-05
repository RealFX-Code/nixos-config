{ pkgs, ... }: {

  networking.firewall.enable = false;
  networking.wireguard.enable = true;
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

  services.getty = {
    autologinUser = "leah";
    autologinOnce = true;
  };
}
