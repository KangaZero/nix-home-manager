{ pkgs, lib, ... }: {
   imports = [
      ./git.nix
      ./ssh.nix
      ./kitty.nix
      ./hyprland.nix
    ];
}
