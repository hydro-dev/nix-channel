{ 
  system ? builtins.currentSystem,
  pkgs ? import <nixpkgs> { inherit system; }
}:

let
  callPackage = pkgs.lib.callPackageWith (pkgs // self);

  self = {
    mongodb = import ./mongodb.nix;
    mongodb8 = callPackage ./mongodb.nix { version = "8.2.3"; inherit system; };
    mongodb7 = callPackage ./mongodb.nix { version = "7.0.28"; inherit system; };
    mongodb6 = callPackage ./mongodb.nix { version = "6.0.27"; inherit system; };
    mongodb5 = callPackage ./mongodb.nix { version = "5.0.32"; inherit system; };
    mongodb4 = callPackage ./mongodb.nix { version = "4.4.30"; inherit system; };
    mongodb8-cn = callPackage ./mongodb.nix { version = "8.2.3"; inherit system; };
    mongodb7-cn = callPackage ./mongodb.nix { version = "7.0.28"; inherit system; };
    mongodb6-cn = callPackage ./mongodb.nix { version = "6.0.27"; inherit system; };
    mongodb5-cn = callPackage ./mongodb.nix { version = "5.0.32"; inherit system; };
    mongodb4-cn = callPackage ./mongodb.nix { version = "4.4.30"; inherit system; };
    cyaron = callPackage ./cyaron.nix { inherit system; };
    xeger = callPackage ./xeger.nix { inherit system; };
    gcc = callPackage ./gccWithCache.nix { inherit system; };
    judge = callPackage ./judge.nix { inherit system; };
  };
in
self