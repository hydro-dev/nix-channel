{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      {
        packages = let
          tuna = "https://mirrors.tuna.tsinghua.edu.cn/mongodb/";
          iscas = "https://mirror.iscas.ac.cn/mongodb/";
          nju = "https://mirrors.nju.edu.cn/mongodb/";
          callPackage = file: args: import file (args // { pkgs = nixpkgs.legacyPackages.${system}; system = system; });
        in {
          judge = callPackage ./judge.nix {};
          cyaron = callPackage ./cyaron.nix {};
          xeger = callPackage ./xeger.nix {};
          mongodb = callPackage ./mongodb.nix {};
          gcc = callPackage ./gccWithCache.nix {};
          mongodb7 = callPackage ./mongodb.nix { version = "7.0.11"; inherit system; };
          mongodb6 = callPackage ./mongodb.nix { version = "6.0.12"; inherit system; };
          mongodb5 = callPackage ./mongodb.nix { version = "5.0.10"; inherit system; };
          mongodb4 = callPackage ./mongodb.nix { version = "4.4.16"; inherit system; };
          mongodb7-cn = callPackage ./mongodb.nix { version = "7.0.11"; mirror = tuna; inherit system; };
          mongodb6-cn = callPackage ./mongodb.nix { version = "6.0.12"; mirror = tuna; inherit system; };
          mongodb5-cn = callPackage ./mongodb.nix { version = "5.0.10"; mirror = tuna; inherit system; };
          mongodb4-cn = callPackage ./mongodb.nix { version = "4.4.16"; mirror = tuna; inherit system; };
          mongodb7-iscas = callPackage ./mongodb.nix { version = "7.0.11"; mirror = iscas; inherit system; };
          mongodb6-iscas = callPackage ./mongodb.nix { version = "6.0.12"; mirror = iscas; inherit system; };
          mongodb5-iscas = callPackage ./mongodb.nix { version = "5.0.10"; mirror = iscas; inherit system; };
          mongodb4-iscas = callPackage ./mongodb.nix { version = "4.4.16"; mirror = iscas; inherit system; };
          mongodb7-nju = callPackage ./mongodb.nix { version = "7.0.11"; mirror = nju; inherit system; };
          mongodb6-nju = callPackage ./mongodb.nix { version = "6.0.12"; mirror = nju; inherit system; };
          mongodb5-nju = callPackage ./mongodb.nix { version = "5.0.10"; mirror = nju; inherit system; };
          mongodb4-nju = callPackage ./mongodb.nix { version = "4.4.16"; mirror = nju; inherit system; };
        };
        mongodb = import ./mongodb.nix;
      }
    );
}
