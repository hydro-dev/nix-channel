{ 
  pkgs ? import <nixpkgs> { system = "x86_64-linux"; }
}:

let
in pkgs.stdenv.mkDerivation {
  name = "hydro-sandbox-1.5.0";
  system = "x86_64-linux";
  src = pkgs.fetchurl {
    url = "https://kr.hydro.ac/download/sandbox";
    sha256 = "sha256-WDMzG4TIxfnfaWPhfw5SlgFcNQTj/Jys45b4R5jKzpw=";
  };
  unpackPhase = "true";
  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/hydro-sandbox
  '';

  meta = {
    description = "HydroSandbox";
    homepage = https://github.com/criyle/go-judge;
    maintainers = [ "undefined <i@undefined.moe>" ];
    platforms = [ "x86_64-linux" ];
  };
}