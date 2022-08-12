{ system ? builtins.currentSystem }:

let
  pkgs = import <nixpkgs> { inherit system; };
  callPackage = pkgs.lib.callPackageWith (pkgs // self);
  tuna = "https://mirrors.tuna.tsinghua.edu.cn/mongodb/";

  self = {
    mongodb = import ./mongodb.nix;
    mongodb6 = callPackage ./mongodb.nix { version = "6.0.0"; };
    mongodb5 = callPackage ./mongodb.nix { version = "5.0.10"; };
    mongodb4 = callPackage ./mongodb.nix { version = "4.4.15"; };
    mongosh5 = callPackage ./mongodb.nix { version = "5.0.10"; type = "shell"; };
    mongosh4 = callPackage ./mongodb.nix { version = "4.4.15"; type = "shell"; };
    mongodb6-cn = callPackage ./mongodb.nix { version = "6.0.0"; mirror = tuna; };
    mongodb5-cn = callPackage ./mongodb.nix { version = "5.0.10"; mirror = tuna; };
    mongodb4-cn = callPackage ./mongodb.nix { version = "4.4.15"; mirror = tuna; };
    mongosh5-cn = callPackage ./mongodb.nix { version = "5.0.10"; type = "shell"; mirror = tuna; };
    mongosh4-cn = callPackage ./mongodb.nix { version = "4.4.15"; type = "shell"; mirror = tuna; };
    sandbox = callPackage ./sandbox.nix {};
    gcc = callPackage ./gccWithCache.nix {};
    judge = callPackage ./judge.nix {};
  };
in
self