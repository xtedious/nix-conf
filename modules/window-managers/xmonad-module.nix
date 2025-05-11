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
      unstable.xmonad-log # Dbus
      unstable.rofi
      scrot # Screenshots
      trayer
      xfce.xfce4-power-manager
      xscreensaver
      # Status Bar
      polybar
      xmobar
      xdotool
      # Clipboard
      xclip
      unstable.picom-pijulius # Compositer
      # Theming
      feh
      unstable.pywal16
    ];
  };
}
