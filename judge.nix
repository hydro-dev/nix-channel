# Note: this file is used to construct HydroOJ judge rootfs.
{ system ? builtins.currentSystem
, pkgs
, minimal ? false
}:

let
  gcc = import ./gccWithCache.nix { inherit pkgs; inherit system; };
  php = pkgs.php.withExtensions ({ ... }: [ ]);
  cyaron = import ./cyaron.nix { inherit pkgs; inherit system; };
  xeger = import ./xeger.nix { inherit pkgs; inherit system; };
  locales = (pkgs.glibcLocales.override { locales = [ "zh_CN.UTF-8" "en_US.UTF-8" ]; });
in
pkgs.buildEnv {
  name = "judge${if minimal then "-minimal" else ""}";
  paths = [
    pkgs.coreutils
    pkgs.bash
    pkgs.diffutils
    pkgs.nix
    pkgs.zip
    pkgs.unzip
    gcc
    pkgs.testlib
    pkgs.gawk
    pkgs.fpc
    pkgs.glibc
    locales
  ] ++ (if !minimal then
    ((with pkgs; [
      gdb
      ghc
      rustc
      sqlite
      kotlin
      go
      nodejs
      esbuild
      openjdk_headless
      ruby
      mono
      iverilog
      gbenchmark
      python3
      pypy3
      ghostscript
      xvfb-run
      cimg
      qemu
    ]) ++ [
      php
    ] ++ (with pkgs.python3Packages; [
      pandas
      pytz
      python-dateutil
      six
      numpy
      tkinter
      pillow
      xeger
      cyaron
    ])) ++ (if system == "x86_64-linux" then [
    pkgs.julia-bin
    pkgs.R
  ] else [ ]) else [ ]) ;
  ignoreCollisions = true;
  pathsToLink = [ "/" ];
  postBuild = ''
    mkdir $out/buildInfo
    echo 'root:x:0:0:root:/root:/bin/bash' >$out/etc/passwd
    date >$out/buildInfo/timestamp
  '';
}
