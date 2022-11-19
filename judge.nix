# Note: this file is used to construct HydroOJ judge rootfs.
{ 
  system ? builtins.currentSystem,
  pkgs ? import <nixpkgs> { system = system; },
  minimal ? false
}:

let
in pkgs.buildEnv {
  name = "judge${if minimal then "-minimal" else ""}";
  paths = [
    pkgs.coreutils
    pkgs.bash
    pkgs.diffutils # For default checker
    pkgs.nix # For nix-store info
    pkgs.unzip # For submit answer
    (import ./gccWithCache.nix {})
    pkgs.fpc
    pkgs.python2
    pkgs.python3
  ] ++ (if !minimal then [
    pkgs.zip
    pkgs.gdb
    pkgs.ghc
    pkgs.rustc
    pkgs.cimg
    pkgs.python3Packages.numpy
    pkgs.python3Packages.tkinter
    pkgs.python3Packages.pillow
    pkgs.ghostscript
    (pkgs.php.withExtensions ({ enabled, all }: []))
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
