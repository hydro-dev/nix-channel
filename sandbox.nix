{ 
  system ? builtins.currentSystem,
  pkgs ? import <nixpkgs> { system = system; },
  version ? "1.6.2"
}:

with pkgs.lib;
let
  sha256dict = {
    "1.5.4x86_64-linux" = "sha256-fpSRP3jQCWebAsEa1K/71Hw+q6pwOfLcrO5f29sa8qk=";
    "1.5.4aarch64-linux" = "sha256-2JZp69BLAwWUJp3EHtAKmuzpt+XsjokSQN/+faTvXCI=";
    "1.6.2x86_64-linux" = "sha256:1mlxxx27zax0r0ikny0sjk85a6mbkhaz2b11670sjckp9j659pvs";
    "1.6.2aarch64-linux" = "sha256:0wlf8q93hbmn3qyg577v2r9vbvyqvlsk36r10mwxyddf784yb3kg";
  };
  systemMap = {
    "x86_64-linux" = "linux_amd64";
    "aarch64-linux" = "linux_arm64";
  };
  versionDetail = concatStrings [version system];
  src = builtins.fetchurl {
    name = "hydro-sandbox-${version}.gz";
    url = "https://hydro.ac/download/executorserver_${version}_${getAttr system systemMap}.gz";
    sha256 = if hasAttr versionDetail sha256dict then getAttr versionDetail sha256dict else "";
  };
in derivation {
  name = "hydro-sandbox-${version}";
  system = system;
  # https://github.com/NixOS/nix/issues/2176
  builder = "${pkgs.busybox}/bin/sh";
  args = ["-c" ''
    ${pkgs.busybox}/bin/mkdir -p $out/bin && \
    ${pkgs.busybox}/bin/gunzip -d ${src} -c >$out/bin/hydro-sandbox && \
    ${pkgs.busybox}/bin/chmod +x $out/bin/hydro-sandbox
  ''];
}