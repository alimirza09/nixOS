{
  description = "nixos configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    catppuccin.url = "github:catppuccin/nix";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, catppuccin, home-manager, quickshell, ... }@inputs: {
      nixosConfigurations.nixosBTW = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = { inherit inputs; };

        modules = [
          ./configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.users.ali = {
              imports = [ ./home.nix catppuccin.homeModules.catppuccin ];
            };
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
      };
    };
}
