{
  description = "NixOS flake config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "git+file:///home/lachlan/Hyprland";
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs: {
    nixosConfigurations.nixos-btw = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      # Make flake inputs available to NixOS modules
      specialArgs = {
        inherit inputs;
      };

      modules = [
        ./boot.nix
        ./system.nix
        ./pkgs.nix
        ./drivers.nix
        ./gui.nix
        ./hardware-configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];
    };
  };
}
