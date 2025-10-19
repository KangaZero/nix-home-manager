{
  description = "Samuel's NixOS config with Home Manager and LazyVim";

  inputs = {
    # Main NixOS packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # LazyVim Nix module
    lazyvim.url = "github:pfassina/lazyvim-nix";
  };

  outputs = { self, nixpkgs, home-manager, lazyvim, ... }: let
    system = "x86_64-linux";
  in {
    nixosConfigurations.sam = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        # Your main NixOS system config
        ./configuration.nix

        # Integrate Home Manager with NixOS
        home-manager.nixosModules.home-manager

        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          # Define the user's home config
          home-manager.users.sam = {
            imports = [
              ./home.nix
              lazyvim.homeManagerModules.default
            ];

            programs.lazyvim.enable = true;
          };
        }
      ];
    };
  };
}

