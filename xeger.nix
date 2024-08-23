{ pkgs, ... }:
pkgs.python3Packages.buildPythonPackage rec {
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
}
