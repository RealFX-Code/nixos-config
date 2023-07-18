# todos!

## configuration.nix

### Properly integrate some software that support the `programs.{...} = { enable = true;}` implementation type.

E.G.:
```nix
programs.zsh.enable = true;
programs.sway = {
  enable = true;
  wrapperFeatures.gtk = true;
}
# ref this: https://nixos.wiki/wiki/Sway
```

### Remove software that requires outdated / insecure package versions of Python and OpenSSL.

See line: 117 -> 120 in configuration.nix.
