{pkgs, ...}: {
  users.users.leah = {
    isNormalUser = true;
    description = "Leah";
    extraGroups = [ "networkmanager" "wheel" "adbusers" "plugdev" "dialout" "libvirtd" "docker" "audio"];
    shell = pkgs.fish;
  };

  users.users.root = {
    shell = pkgs.bash;
  };
}
