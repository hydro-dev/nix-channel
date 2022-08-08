{ pkgs ? import <nixpkgs> { system = "x86_64-linux"; } }:

pkgs.buildEnv {
  name = "judge";
  paths = [
    pkgs.busybox
    pkgs.gcc_latest
    pkgs.fpc
    pkgs.diffutils
    pkgs.unzip
  ];
  ignoreCollisions = true;
  pathsToLink = [ "/bin" ];
}
