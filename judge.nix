# Note: this file is used to construct HydroOJ judge rootfs.
{
  system ? builtins.currentSystem,
  pkgs ? import <nixpkgs> { system = system; },
  minimal ? false
}:

let
  gcc = import ./gccWithCache.nix {};
  php = pkgs.php.withExtensions ({ enabled, all }: []);
in pkgs.buildEnv {
  name = "judge${if minimal then "-minimal" else ""}";
  paths = [
    pkgs.coreutils
    pkgs.bash
    pkgs.diffutils
    pkgs.nix
    pkgs.zip
    pkgs.unzip
    gcc
    pkgs.fpc
  ] ++ (if !minimal then [
    pkgs.gdb
    pkgs.ghc
    pkgs.rustc
    pkgs.difftastic
    pkgs.sqlite
    pkgs.cimg
    pkgs.python3
    pkgs.python3Packages.pandas
    pkgs.python3Packages.numpy
    pkgs.python3Packages.tkinter
    pkgs.python3Packages.pillow
    pkgs.ghostscript
    php
    pkgs.go
    pkgs.nodejs
    pkgs.esbuild
    pkgs.openjdk_headless
    pkgs.ruby
    pkgs.mono
    pkgs.verilog
    pkgs.gbenchmark
    pkgs.xvfb-run
  ] else []) ++ (if system == "x86_64-linux" then [
    pkgs.julia-bin
  ] else []);
  ignoreCollisions = true;
  pathsToLink = [ "/" ];
  postBuild = ''
    mkdir $out/buildInfo
    echo 'root:x:0:0:root:/root:/bin/bash' >$out/etc/passwd
    date >$out/buildInfo/timestamp
  '';
}
