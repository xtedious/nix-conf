# Collection of Modules and their default settings
{
  pkgs,
  unstable,
  lib,
  ...
}: {
  imports = [
    ./window-managers/hyprland-module.nix
    ./window-managers/xmonad-module.nix
    ./apps/steam-module.nix
    ./apps/virt-manager-module.nix
    ./embedded-dev/rpi-pico-module.nix
  ];

  # Window Managers
  hyprland-module.enable = lib.mkDefault false;
  xmonad-module.enable = lib.mkDefault false;

  # Apps
  steam-module.enable = lib.mkDefault false;
  virt-manager-module.enable = lib.mkDefault false;

  # Dev Modules
  rpi-pico-module.enable = lib.mkDefault false;
}
