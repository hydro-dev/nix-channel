{ system ? builtins.currentSystem
, pkgs ? import <nixpkgs> { system = system; }
}:
let
  xeger = pkgs.python3Packages.buildPythonPackage rec {
    pname = "xeger";
    version = "0.4.0";
    format = "wheel";
    propagatedBuildInputs = with pkgs.python3Packages; [
      setuptools
    ];
    src = pkgs.fetchPypi {
      inherit pname version format;
      sha256 = "sha256-oPVE+vRaxWopr05ii9HmmWM08JBFjXimFYFJDfGq0lI=";
      python = "py3";
      dist = "py3";
    };
  };
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
