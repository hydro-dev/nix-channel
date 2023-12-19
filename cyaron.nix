{ system ? builtins.currentSystem
, pkgs ? import <nixpkgs> { system = system; }
}:
let
  xeger = import ./xeger.nix { inherit system pkgs; };
in
pkgs.python3Packages.buildPythonPackage rec {
  pname = "cyaron";
  version = "0.5.0";
  propagatedBuildInputs = with pkgs.python3Packages; [
    setuptools
    colorful
    xeger
  ];
  doCheck = false;
  src = pkgs.fetchPypi {
    inherit pname version;
    sha256 = "sha256-B0kLUoP7YstDckfAdVmuB4rUmw+g9l/6It6boTuSsII=";
  };
}
