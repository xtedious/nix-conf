# User Configuration
{
  pkgs,
  unstable,
  username,
  ...
}: {
  imports = [
    ./modules/nix-modules.nix
  ];

  # Enabled Modules
  xmonad-module.enable = true; # WM

  # Apps
  steam-module.enable = true;
  virt-manager-module.enable = true;

  # Dev Modules
  rpi-pico-module.enable = true;

  # xtedious
  users = {
    mutableUsers = true;
    users."${username}" = {
      homeMode = "755";
      isNormalUser = true;
      description = "${username}";
      extraGroups = ["networkmanager" "wheel" "libvirtd" "scanner" "lp" "video" "input" "audio"];
      packages = with pkgs; [
        # Dev Stuff
        ikos
        unstable.arduino-ide
        # 3D printing
        unstable.orca-slicer
        unstable.freecad
        # Audio
        mpv
        # Work
        discord
        librewolf
        obs-studio
        unstable.gimp3
        qbittorrent
        unstable.obsidian
        anki
        unstable.libreoffice
        krita
        blender
        # Password Manager
        unstable.keepassxc
        # Screenshots utility
        ksnip
        # Wine Stuff
        wineWowPackages.stable
        # Games
        lutris
        unstable.bluez
        unstable.retroarch
        cava # Music Visualizer
        # IoT development
        unstable.platformio
        unstable.rpi-imager
        unstable.realvnc-vnc-viewer
        # Haskell
        ghc
        haskell-language-server
      ];
    };

    defaultUserShell = pkgs.zsh;
  };

  environment.shells = with pkgs; [zsh];
  environment.systemPackages = with pkgs; [lsd fzf];

  programs = {
    # Zsh configuration
    zsh = {
      enable = true;
      enableCompletion = true;
      ohMyZsh = {
        enable = true;
        plugins = ["git"];
        theme = "agnoster";
      };

      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
    };
  };
}
