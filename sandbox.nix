{ 
  system ? builtins.currentSystem,
  pkgs ? import <nixpkgs> { system = system; },
  version ? "1.5.4"
}:

with pkgs.lib;
let
  sha256dict = {
    "1.5.1x86_64-linux" = "sha256-bJ8dOpiIDM+Iubd8IBAkSPsHpJSUdOsiUozuHGHMVyE=";
    "1.5.2x86_64-linux" = "sha256-ABtoJ3ABQl2Ymg5aowB+lkrWYLQKsbgKBFLMzRsD3HY=";
    "1.5.3x86_64-linux" = "sha256-aSL972fMHhR5LZe7HK2VxAur0sWXjfjJY2L2PxR95Po=";
    "1.5.3aarch64-linux" = "sha256-33iXaD2niZaaT7YoIi5XpIjOipk37lfoD6NM6+OICps=";
    "1.5.4x86_64-linux" = "sha256-fpSRP3jQCWebAsEa1K/71Hw+q6pwOfLcrO5f29sa8qk=";
    "1.5.4aarch64-linux" = "sha256-2JZp69BLAwWUJp3EHtAKmuzpt+XsjokSQN/+faTvXCI=";
  };
  systemMap = {
    "x86_64-linux" = "linux_amd64";
    "aarch64-linux" = "linux_arm64";
  };
  versionDetail = concatStrings [version system];
  src = builtins.fetchurl {
    name = "hydro-sandbox-${version}.gz";
    url = "https://kr.hydro.ac/download/executorserver_${version}_${getAttr system systemMap}.gz";
    sha256 = if hasAttr versionDetail sha256dict then getAttr versionDetail sha256dict else "";
  };
in derivation {
  name = "hydro-sandbox-${version}";
  system = system;
  builder = "${pkgs.bash}/bin/bash";
  args = ["-c" ''
    ${pkgs.coreutils}/bin/mkdir -p $out/bin && \
    ${pkgs.gzip}/bin/gzip -d ${src} -c >$out/bin/hydro-sandbox && \
    ${pkgs.coreutils}/bin/chmod +x $out/bin/hydro-sandbox
  ''];
}