{
  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-23.11;
  inputs.flake-utils.url = github:numtide/flake-utils;

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      {
        packages.judge = (import ./judge.nix)
          { pkgs = nixpkgs.legacyPackages.${system}; system = system; };
        packages.cyaron = (import ./cyaron.nix)
          { pkgs = nixpkgs.legacyPackages.${system}; system = system; };
        packages.xeger = (import ./xeger.nix)
          { pkgs = nixpkgs.legacyPackages.${system}; system = system; };
        packages.mongodb = (import ./mongodb.nix)
          { pkgs = nixpkgs.legacyPackages.${system}; system = system; };
      }
    );
}
