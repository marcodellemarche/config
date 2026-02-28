{
  description = "My Ubuntu Nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-go.url = "github:nixos/nixpkgs/de0fe301211c267807afd11b12613f5511ff7433";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    nixpkgs,
    nixpkgs-go,
    home-manager,
    ...
  }: let
    # system = "aarch64-linux"; If you are running on ARM powered computer
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    pkgs-go = nixpkgs-go.legacyPackages.${system};
  in {
    homeConfigurations = {
      marcodellemarche = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit pkgs-go; };
        modules = [
          ./home-manager/home.nix
        ];
      };
    };
  };
}

