{ 
  system ? builtins.currentSystem,
  pkgs ? import <nixpkgs> { system = system; },
  version ? "1.5.3"
}:

let
  sha256dict = {
    "1.5.1x86_64-linux" = "sha256-bJ8dOpiIDM+Iubd8IBAkSPsHpJSUdOsiUozuHGHMVyE=";
    "1.5.2x86_64-linux" = "sha256-ABtoJ3ABQl2Ymg5aowB+lkrWYLQKsbgKBFLMzRsD3HY=";
    "1.5.3x86_64-linux" = "sha256-aSL972fMHhR5LZe7HK2VxAur0sWXjfjJY2L2PxR95Po=";
    "1.5.3aarch64-linux" = "sha256-33iXaD2niZaaT7YoIi5XpIjOipk37lfoD6NM6+OICps=";
  };
  systemMap = {
    "x86_64-linux" = "linux_amd64";
    "aarch64-linux" = "linux_arm64";
  };
  versionDetail = pkgs.lib.concatStrings [version system];
in pkgs.stdenv.mkDerivation {
  name = "hydro-sandbox-${version}";
  system = system;
  src = pkgs.fetchurl {
    url = "https://kr.hydro.ac/download/executorserver_${version}_${pkgs.lib.getAttr system systemMap}.gz";
    sha256 = if pkgs.lib.hasAttr versionDetail sha256dict then pkgs.lib.getAttr versionDetail sha256dict else "";
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
    platforms = [ system ];
  };
}