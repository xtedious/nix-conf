# Machine Configuration
{
  config,
  pkgs,
  host,
  username,
  options,
  lib,
  inputs,
  system,
  unstable,
  ...
}: {
  imports = [
    ../user.nix
  ];

  environment.systemPackages = with pkgs; [
    # dev tools
    gnumake
    libgcc
    clang
    lldb # llvm debugger
    vim
    wget
    git
    killall
    gnome-disk-utility
    # Audio
    alsa-utils
    pavucontrol
    pamixer
    brightnessctl
    mpc # Music
    kitty # Terminal
    fastfetch # fetcher
    btop
    # Networking
    dunst
    polkit
    polkit_gnome
    libnotify
    nmap # network discovery
    # Archiving
    unzip
    xarchiver
    # Graphics
    mesa
    gpu-viewer
    vulkan-tools
    virtualglLib
  ];

  # Default programs
  programs = {
    git.enable = true;
    dconf.enable = true;

    # Text Editor
    neovim = {
      enable = true;
    };

    # File Manager
    thunar.enable = true;

    # SSH and GPG keys
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    # File Sharing
    localsend = {
      enable = true;
      openFirewall = true;
    };
  };

  # Default Services
  services = {
    # default display manager is xorg
    xserver = {
      enable = true;
      displayManager.lightdm.enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
    };

    # Thumbnails
    tumbler.enable = true;

    # Audio
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    # Daemons
    blueman.enable = true;
    mpd.enable = true;
    upower.enable = true;

    # Networking
    gnome.gnome-keyring.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    syncthing = {
      enable = true;
      user = "${username}";
      dataDir = "/home/${username}";
      configDir = "/home/${username}/.config/syncthing";
    };
  };

  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    fira-code
    jetbrains-mono
    font-awesome
    noto-fonts-cjk-sans
    font-awesome
  ];

  # Set timezone
  time.timeZone = "Africa/Johannesburg";

  # Bluetooth
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General.Enable = "Source,Sink,Media,Socket";
        General.Experimental = true;
      };
    };
  };

  # Security/Polkit
  security.rtkit.enable = true;
  security.polkit.enable = true;
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
    	if (
    		subject.isInGroup("users")
    		&& (
    		action.id == "org.freedesktop.login1.reboot" ||
    		action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
    		action.id == "org.freedesktop.login1.power-off" ||
    		action.id == "org.freedesktop.login1.power-off-multiple-sessions"
    		)
    	)
    		{
    	return polkit.Result.YES;
    		}
    	})
  '';
  security.pam.services.swaylock = {
    text = ''
      auth include login
    '';
  };

  networking = {
    networkmanager.enable = true;
    hostName = "${host}";
    timeServers = options.networking.timeServers.default ++ ["pool.ntp.org"];
  };
  # Open ports in the firewall
  networking.firewall.allowedTCPPorts = [4455 22];
  networking.firewall.allowedUDPPorts = [4455 22];
  # Disable firewall
  # networking.firewall.enable = false;

  # The End
}
