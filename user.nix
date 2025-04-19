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
  hyprland-module.enable = true;

  # xtedious
  users  = {
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
        freecad-wayland
        # Audio
        mpv
        # Work
        discord
        librewolf
        obs-studio
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
        cava # Music Visualizer
        # IoT development
        unstable.platformio
        unstable.rpi-imager
        # Haskell
        ghc
        haskell-language-server
      ];
    };

    defaultUserShell = pkgs.zsh;
  };

  environment.shells = with pkgs; [ zsh ];
  environment.systemPackages = with pkgs; [ lsd fzf ]; 

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

    neovim.enable = true;
  };
}

