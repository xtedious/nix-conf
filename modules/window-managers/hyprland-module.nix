# Hyprland Config and packages
{
  pkgs,
  config,
  lib,
  inputs,
  unstable,
  ...
}:
let
  cfg = config.hyprland-module;
in
  {
  options.hyprland-module.enable = lib.mkEnableOption "Enable Hyprland and related packages";

  config = lib.mkIf cfg.enable {

    nixpkgs.config.allowUnfree = true;

    # System packages related to hyprland
    environment.systemPackages = with pkgs; [
      # Hypr ecosystem
      hyprpaper
      hyprpicker
      hypridle
      hyprlock
      xdg-desktop-portal-hyprland
      hyprsunset
      unstable.hyprsysteminfo
      unstable.hyprland-qt-support
      hyprcursor
      hyprutils
      wl-clipboard

      mpc # MPD Utility
      playerctl
      nwg-look # settings look
      cliphist # Clipboard Manager
      waybar # Status Bar
      networkmanagerapplet # Network Manager
      rofi-wayland

      # System packages to be replaced to wayland 
    ];

    programs = {
      hyprland.enable = true;
      xwayland.enable = true;
    };

    # For Electron apps to use wayland
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

  };
}
