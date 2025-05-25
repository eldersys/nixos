{
  description = "NixOs Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    home-manager = {
       url = "github:nix-community/home-manager/release-24.05";
       inputs.nixpkgs.follows = "nixpkgs";
     };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { home-manager, nixpkgs, nur, ... }@inputs: 

  let

    system = "x86_64-linux";
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    lib = nixpkgs.lib; 
    
    # Lets us reuse the code to "create" a system
    # Credits sioodmy and notusknot
    # https://github.com/notusknot/dotfiles-nix/blob/main/flake.nix

    mkSystem = pkgs: system: hostname:
      pkgs.lib.nixosSystem {
        system = system;
        modules = [

          { networking.hostName = hostname; }
          ./modules/system/configuration.nix
          ./hosts/${hostname}/hardware-configuration.nix

          home-manager.nixosModules.home-manager 
          {
            home-manager = {
              useUserPackages = true;
              useGlobalPkgs = true;
              extraSpecialArgs = { inherit inputs; };
              users.iohannes = (./. + "/hosts/${hostname}/user.nix");
            };

	    nixpkgs.overlays = [
	      nur.overlays.default
	    ];
          }
        ];

        specialArgs = {inherit inputs;};
      };

  in {
      nixosConfigurations = {
        aegis = mkSystem inputs.nixpkgs "x86_64-linux" "aegis";
	orion = mkSystem inputs.nixpkgs "x86_64-linux" "orion";
      };
    };
}
