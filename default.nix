{ system ? builtins.currentSystem }:

let
  pkgs = import <nixpkgs> { inherit system; };

  callPackage = pkgs.lib.callPackageWith (pkgs // self);

  self = {
    mongodb = import ./mongodb.nix;
    mongodb5 = callPackage ./mongodb.nix { version = "5.0.6"; };
    mongodb4 = callPackage ./mongodb.nix { version = "4.4.15"; };
    judge = callPackage ./judge.nix {};
  };
in
self