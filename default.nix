{ 
  system ? builtins.currentSystem,
  pkgs ? import <nixpkgs> { inherit system; }
}:

let
  callPackage = pkgs.lib.callPackageWith (pkgs // self);

  self = {
    mongodb = import ./mongodb.nix;
    mongodb7 = callPackage ./mongodb.nix { version = "7.0.11"; inherit system; };
    mongodb6 = callPackage ./mongodb.nix { version = "6.0.12"; inherit system; };
    mongodb5 = callPackage ./mongodb.nix { version = "5.0.10"; inherit system; };
    mongodb4 = callPackage ./mongodb.nix { version = "4.4.16"; inherit system; };
    mongodb7-cn = callPackage ./mongodb.nix { version = "7.0.11"; inherit system; };
    mongodb6-cn = callPackage ./mongodb.nix { version = "6.0.12"; inherit system; };
    mongodb5-cn = callPackage ./mongodb.nix { version = "5.0.10"; inherit system; };
    mongodb4-cn = callPackage ./mongodb.nix { version = "4.4.16"; inherit system; };
    cyaron = callPackage ./cyaron.nix { inherit system; };
    xeger = callPackage ./xeger.nix { inherit system; };
    gcc = callPackage ./gccWithCache.nix { inherit system; };
    judge = callPackage ./judge.nix { inherit system; };
  };
in
self