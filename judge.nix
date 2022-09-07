# Note: this file is used to construct HydroOJ judge rootfs.
{ 
  pkgs ? import <nixpkgs> { system = "x86_64-linux"; },
  minimal ? false
}:

let
  gcc = import ./gccWithCache.nix {};
in pkgs.buildEnv {
  name = "judge${if minimal then "-minimal" else ""}";
  paths = [
    pkgs.coreutils
    pkgs.bash
    pkgs.diffutils
    pkgs.unzip
    gcc
    pkgs.fpc
  ] ++ (if !minimal then [
    pkgs.nix
    pkgs.gdb
    pkgs.ghc
    pkgs.rustc
    pkgs.python2
    pkgs.pythonPackages.numpy
    pkgs.python3Minimal
    pkgs.python3Packages.numpy
    pkgs.python3Packages.tkinter
    pkgs.python3Packages.pillow
    pkgs.ghostscript
    pkgs.php
    pkgs.go
    pkgs.nodejs
    pkgs.esbuild
    pkgs.openjdk_headless
    pkgs.ruby
    pkgs.mono
    pkgs.julia_17-bin
    pkgs.verilog
    pkgs.gbenchmark
    pkgs.xvfb-run
  ] else []);
  ignoreCollisions = true;
  pathsToLink = [ "/" ];
  postBuild = ''
    mkdir $out/buildInfo
    echo 'root:x:0:0:root:/root:/bin/bash' >$out/etc/passwd
    date >$out/buildInfo/timestamp
  '';
}
