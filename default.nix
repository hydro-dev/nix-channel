{ system ? builtins.currentSystem }:

let
  pkgs = import <nixpkgs> { inherit system; };
  callPackage = pkgs.lib.callPackageWith (pkgs // self);
  tuna = "https://mirrors.tuna.tsinghua.edu.cn/mongodb/";

  self = {
    mongodb = import ./mongodb.nix;
    mongodb6 = callPackage ./mongodb.nix { version = "6.0.0"; inherit system; };
    mongodb5 = callPackage ./mongodb.nix { version = "5.0.10"; inherit system; };
    mongodb4 = callPackage ./mongodb.nix { version = "4.4.16"; inherit system; };
    mongosh5 = callPackage ./mongodb.nix { version = "5.0.10"; type = "shell"; inherit system; };
    mongosh4 = callPackage ./mongodb.nix { version = "4.4.16"; type = "shell"; inherit system; };
    mongodb6-cn = callPackage ./mongodb.nix { version = "6.0.0"; mirror = tuna; inherit system; };
    mongodb5-cn = callPackage ./mongodb.nix { version = "5.0.10"; mirror = tuna; inherit system; };
    mongodb4-cn = callPackage ./mongodb.nix { version = "4.4.16"; mirror = tuna; inherit system; };
    mongosh5-cn = callPackage ./mongodb.nix { version = "5.0.10"; type = "shell"; mirror = tuna; inherit system; };
    mongosh4-cn = callPackage ./mongodb.nix { version = "4.4.16"; type = "shell"; mirror = tuna; inherit system; };
    sandbox = callPackage ./sandbox.nix { inherit system; };
    gcc = callPackage ./gccWithCache.nix { inherit system; };
    judge = callPackage ./judge.nix { inherit system; };
  };
in
self