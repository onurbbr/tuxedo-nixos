{
  description = "System Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-compat,
    }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;

        config = {
          permittedInsecurePackages = [
            "electron-42.11.18"
          ];
        };
      };
    in
    {
      packages.${system}.default =
        pkgs.callPackage ./nix/tuxedo-control-center { };

      nixosModules.default =
        { config, pkgs, ... }:
        {
          _module.args.tuxedo-control-center = self.packages.${system}.default;
          imports = [ ./nix/module.nix ];
        };
    };
}
