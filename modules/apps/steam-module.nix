# Steam Config and packages
{
  pkgs,
  config,
  lib,
  unstable,
  ...
}: let
  cfg = config.steam-module;
in {
  options.steam-module.enable = lib.mkEnableOption "Enable Steam and any related options";

  config = lib.mkIf cfg.enable {
    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # Install Steam
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };
}
