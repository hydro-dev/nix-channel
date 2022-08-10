# Note: this file is used to construct HydroOJ judge rootfs.
{ 
  pkgs ? import <nixpkgs> { system = "x86_64-linux"; },
  minimal ? false
}:

let
  gcc = import ./gcc.nix {};
in pkgs.buildEnv {
  name = "judge${if minimal then "-minimal" else ""}";
  paths = [
    pkgs.busybox
    pkgs.bash
    pkgs.diffutils
    pkgs.unzip
    gcc
    pkgs.fpc
  ] ++ (if !minimal then [
    pkgs.gdb
    pkgs.ghc
    pkgs.rustc
    pkgs.python2
    pkgs.pythonPackages.numpy
    pkgs.python3Minimal
    pkgs.python3Packages.numpy
    pkgs.php
    pkgs.go
    pkgs.nodejs
    pkgs.esbuild
    pkgs.openjdk_headless
    pkgs.ruby
    pkgs.mono
    pkgs.julia_17-bin
    pkgs.verilog
  ] else []);
  ignoreCollisions = true;
  pathsToLink = [ "/bin" ];
}
