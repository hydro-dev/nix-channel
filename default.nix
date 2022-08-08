{ system ? builtins.currentSystem }:

let
  pkgs = import <nixpkgs> { inherit system; };

  callPackage = pkgs.lib.callPackageWith (pkgs // self);

  self = {
    mongodb = callPackage ./mongodb.nix {};
    judge = callPackage ./judge.nix {};
  };
in
self