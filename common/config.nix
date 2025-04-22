# System Management
{
  config,
  pkgs,
  host,
  options,
  lib,
  inputs,
  system,
  ...
}: {
  imports = [
    ./default.nix
    ./hardware.nix
  ];

  # Booting
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    initrd = {
      availableKernelModules = ["xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod"];
      kernelModules = [];
    };

    # Boot Loader
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 10;
    };
  };

  # Video drivers
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
    ];
  };

  # Locales (need to be variable for later)
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services = {
    # File Management
    gvfs.enable = true;
    udev.enable = true;
    envfs.enable = true;
    dbus.enable = true;

    # NFS
    rpcbind.enable = false;
    nfs.server.enable = false;

    # SSD
    fstrim = {
      enable = true;
    };

    # Input Devices
    libinput.enable = true;

    # Firmware Updates
    fwupd.enable = true;
  };

  # Memory Management
  zramSwap = {
    enable = true;
    priority = 100;
    memoryPercent = 30;
    swapDevices = 1;
    algorithm = "zstd";
  };

  # Power Management
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "schedutil";
  };

  # Nix Management
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # should be a variable
  console.keyMap = "us";
  # This value detemines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # You did not read the comment!!!
}
