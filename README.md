# My NixOS configuration!

I love nixos, it's great. i want to use it, but to use it i have to have a configuration. (which will be in this repo)


- [My NixOS configuration!](#my-nixos-configuration)
  - [many many thanks to Chris Titus](#many-many-thanks-to-chris-titus)
  - [installation](#installation)
    - [things you might want to change to your specific setup](#things-you-might-want-to-change-to-your-specific-setup)
    - [this setup's quirks (important)](#this-setups-quirks-important)


## many many thanks to Chris Titus

i used his conig as a sort of template to build my own.

if u wanna see his config, it's
[here](https://github.com/ChrisTitusTech/nixos-titus/blob/main/configuration.nix)
.

## installation

(assuming you followed the [NixOS Installation Manual](https://nixos.org/manual/nixos/stable/index.html#sec-installation-manual-installing) up until "Installing" point 4)

- Generate NixOS Config using `nixos-generate-config --root /mnt`
  - This is important to generate the Hardware Configuration (`hardware-configuration.nix`) as this is machine-specific and won't be included in this repo.
- Remove NixOS Configuration using `rm /mnt/etc/nixos/configuration.nix`
- Clone git repo to replce existing nix configuration using `git clone --depth 1 https://github.com/RealFX-Code/nixos-config /mnt/etc/nixos/`
- Install NixOS with `nixos-install`
- Finish setup with the script (in this repo) named `postInstall.sh` while passing 1 argument which is the username to set up.
  - This copies my dotfiles to the directory of the specified user.
  - Example for setting up the user "leah":
    - `$ ./postInstall.sh leah`
- Reboot your system using `reboot now`
- Log into your `root` account using the password you set when you ran `nixos-install`
- Set the password for your unpriviliged account using `passwd <user>` where `<user>` is the username of the account you set up.
- It is important to give your user account ownership of your home folder using the following command: `chown -R <user>:users /home/<user>`.
- Done! You can now log out of your root account by simply typing `exit` and start using NixOS!
- NOTE: My wrapper scripts have moved to my dotfiles repo.

### things you might want to change to your specific setup

- Hostname is by-default set to: `leah-nixos`
- By default, it's configured to use EFI with GRUB.
  - Make sure to enable EFI if running in a VM
- Timezone is set to: `Europe/Oslo`
- A user named `leah` is created with sudo access.
- If you really don't want it, You can disable GRUB's OS-Prober in `configuration.nix`.
- Keyboard layout is set to `no`.

### this setup's quirks (important)

- This setup is supposed to be a "wayland-only" setup. It contains no packages for X11/xorg **except** for xwayland.
- Uses hyprland and sway by default
- This setup comes with NO desktop manager, you'll be dumped into a TTY upon boot. From there you can run amy of my wrapper scripts (`startSway`) to open a WM.
