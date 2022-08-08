{ system ? builtins.currentSystem }:

let
  pkgs = import <nixpkgs> { inherit system; };

  callPackage = pkgs.lib.callPackageWith (pkgs // self);

  self = {
    mongodb = import ./mongodb.nix;
    mongodb6 = callPackage ./mongodb.nix { version = "6.0.0"; };
    mongodb5 = callPackage ./mongodb.nix { version = "5.0.10"; };
    mongodb4 = callPackage ./mongodb.nix { version = "4.4.15"; };
    # mongosh6 = callPackage ./mongodb.nix { version = "6.0.0"; type = "shell"; };
    mongosh5 = callPackage ./mongodb.nix { version = "5.0.10"; type = "shell"; };
    mongosh4 = callPackage ./mongodb.nix { version = "4.4.15"; type = "shell"; };
    judge = callPackage ./judge.nix {};
  };
in
self