{
  description = "Samuel's NixOS config with Home Manager and LazyVim";
  inputs = { 
    # Main NixOS packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
# Ensure nixos packages and home-manager version matches
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # LazyVim Nix module
    lazyvim.url = "github:pfassina/lazyvim-nix";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
        url = "github:hyprwm/hyprland-plugins";
        inputs.hyprland.follows = "hyprland";
      };
  };

  outputs = { self, nixpkgs, home-manager, hyprland, lazyvim, ... } @ inputs: let
    inherit (self) outputs;
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    forAllSystems = nixpkgs.lib.genAttrs systems;
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
   
  in {
    # Accessible through 'nix build', 'nix shell', etc
    packages = forAllSystems (system: nixpkgs.legacyPackages.${system});
    # Formatter for your nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.sam);
# Your custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};
    # Reusable nixos modules you might want to export
    # These are usually stuff you would upstream into nixpkgs
    nixosModules = import ./modules/nixos;
    # Reusable home-manager modules you might want to export
    # These are usually stuff you would upstream into home-manager
    homeManagerModules = import ./modules/home-manager;
 
    nixosConfigurations.sam = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs outputs;};
      # inherit system;
     modules = [
        # Your main NixOS system config
        ./configuration.nix
      ];
    };

    homeConfigurations.sam = home-manager.lib.homeManagerConfiguration {
	pkgs = nixpkgs.legacyPackages.x86_64-linux;
	modules = [./home.nix
  lazyvim.homeManagerModules.default
{
          wayland.windowManager.hyprland = {
            enable = true;
            # set the flake package
            package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
            portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
            plugins = [
              inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
              inputs.hyprland-plugins.packages.${pkgs.system}.hyprscrolling              
            ];
          };
        }
  ];
  extraSpecialArgs = {inherit inputs outputs;};
   };
    };
}
