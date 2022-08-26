{ 
  pkgs ? import <nixpkgs> { system = "x86_64-linux"; },
  version ? "1.5.2"
}:

let
  sha256dict = {
    "1.5.1" = "sha256-bJ8dOpiIDM+Iubd8IBAkSPsHpJSUdOsiUozuHGHMVyE=";
    "1.5.2" = "sha256-ABtoJ3ABQl2Ymg5aowB+lkrWYLQKsbgKBFLMzRsD3HY=";
  };
in pkgs.stdenv.mkDerivation {
  name = "hydro-sandbox-1.5.0";
  system = "x86_64-linux";
  src = pkgs.fetchurl {
    url = "https://kr.hydro.ac/download/executorserver_${version}_linux_amd64.gz";
    sha256 = if pkgs.lib.hasAttr version sha256dict then pkgs.lib.getAttr version sha256dict else "";
  };
  unpackPhase = "true";
  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/hydro-sandbox.gz
    gzip -d $out/bin/hydro-sandbox.gz
    chmod +x $out/bin/hydro-sandbox
  '';

  meta = {
    description = "HydroSandbox";
    homepage = https://github.com/criyle/go-judge;
    maintainers = [ "undefined <i@undefined.moe>" ];
    platforms = [ "x86_64-linux" ];
  };
}