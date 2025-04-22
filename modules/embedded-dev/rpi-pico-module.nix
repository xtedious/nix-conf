# Raspberry Pi Pico Development
{
  pkgs,
  config,
  lib,
  unstable,
  ...
}: let
  cfg = config.rpi-pico-module;
  pico-sdk-210 = unstable.pkgs.pico-sdk.overrideAttrs (oldAttrs: rec {
    src = pkgs.fetchFromGitHub {
      owner = "raspberrypi";
      repo = "pico-sdk";
      rev = "2.1.0"; # Replace with your desired tag or revision.
      sha256 = "sha256-nLn6H/P79Jbk3/TIowH2WqmHFCXKEy7lgs7ZqhqJwDM"; # Replace with the correct hash.
      fetchSubmodules = true;
    };
  });
in {
  options.rpi-pico-module = {
    enable = lib.mkEnableOption "Install rpi pico development environment and packages";

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "Additional packages to install";
    };

    env-variables = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {
        PICO_SDK_PATH = "${pico-sdk-210}/lib/pico-sdk";
      };
      description = "Additional environment variables";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      [
        pico-sdk-210
        unstable.picotool
        clang-tools
        python3
        cmake
        gcc-arm-embedded
        screen
        # Add a debugger
      ]
      ++ config.rpi-pico-module.extraPackages;

    environment.variables = config.rpi-pico-module.env-variables;
  };
}
