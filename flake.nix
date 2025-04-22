{
  description = "NixOS Config by xtedious";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NVF
    nvf.url = "github:notashelf/nvf";

    # Formatter
    alejandra = {
      url = "github:kamadorueda/alejandra/3.1.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    nvf,
    alejandra,
    ...
  }: let
    system = "x86_64-linux";
    host = "nixos";
    username = "xtedious";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    unstable-pkgs = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    # Neovim NVF
    packages."x86_64-linux".nvf-neovim =
      (nvf.lib.neovimConfiguration {
        pkgs = nixpkgs-unstable.legacyPackages."x86_64-linux";
        modules = [./modules/apps/nvf-neovim.nix];
      })
      .neovim;

    nixosConfigurations = {
      "${host}" = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit system;
          inherit host;
          inherit username;
          inherit inputs;
          unstable = unstable-pkgs;
        };
        modules = [
          {
            # Neovim and alejandra setups
            environment.systemPackages = [
              alejandra.defaultPackage.${system}
              self.packages.${pkgs.stdenv.system}.nvf-neovim
            ];
          }
          nvf.nixosModules.default
          ./common/config.nix
        ];
      };
    };
  };
}
