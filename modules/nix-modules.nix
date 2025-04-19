# Collection of Modules and their default settings
{
  pkgs,
  unstable,
  lib,
  ...
}: {
  imports = [
    ./window-managers/hyprland-module.nix
  ];
}
