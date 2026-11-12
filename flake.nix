{
  description = "NixOS flake config";

  inputs = {
    # Keep the base NixOS module set on the existing stable release.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    # Selectively use current nixos-unstable packages where requested.
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Keep the existing local HDR-patched Hyprland source.
    hyprland.url = "git+file:///home/lachlan/Hyprland";
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs:
    let
      system = "x86_64-linux";
      pkgsUnstable = import inputs."nixpkgs-unstable" {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      nixosConfigurations.nixos-btw = nixpkgs.lib.nixosSystem {
        inherit system;

        # Make both flake inputs and the targeted unstable package set
        # available to the NixOS modules.
        specialArgs = {
          inherit inputs pkgsUnstable;
        };

        modules = [
          ./boot.nix
          ./system.nix
          ./pkgs.nix
          ./upkgs.nix
          ./drivers.nix
          ./hardware-configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              inherit pkgsUnstable;
            };
          }
          ./gui.nix
        ];
      };
    };
}
