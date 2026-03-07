{
  description = "My Ubuntu Nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-go.url = "github:nixos/nixpkgs/de0fe301211c267807afd11b12613f5511ff7433";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    nixpkgs,
    nixpkgs-go,
    home-manager,
    fenix,
    ...
  }: let
    system = builtins.currentSystem;
    pkgs = nixpkgs.legacyPackages.${system};
    pkgs-go = nixpkgs-go.legacyPackages.${system};
    pkgs-rust = fenix.packages.${system};
  in {
    homeConfigurations.marcodellemarche = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = { inherit pkgs-go pkgs-rust; };
      modules = [
        ./home-manager/home.nix
      ];
    };
  };
}
