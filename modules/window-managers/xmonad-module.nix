# Xmonad Config and packages
{
  pkgs,
  config,
  lib,
  unstable,
  ...
}: let
  cfg = config.xmonad-module;
in {
  options.xmonad-module.enable = lib.mkEnableOption "Enable Xmonad and related packages";

  config = lib.mkIf cfg.enable {
    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # Install xmonad
    services.xserver = {
      enable = true;
      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
      };
      displayManager.defaultSession = "none+xmonad";
    };

    # System packages related to xmonad
    environment.systemPackages = with pkgs; [
      unstable.rofi
      scrot # Screenshots
      feh
      trayer
      xfce.xfce4-power-manager
      xscreensaver
      # Dock
      unstable.eww
      xmobar
      xdotool
      # Clipboard
      xclip
      unstable.picom-pijulius # Compositer
    ];
  };
}
