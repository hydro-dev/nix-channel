{ pkgs ? import <nixpkgs> { system = "x86_64-linux"; } }:

pkgs.buildEnv {
  name = "judge";
  paths = [
    pkgs.gcc_latest
    pkgs.fpc
  ];
  pathsToLink = [ "/bin" ];
}
