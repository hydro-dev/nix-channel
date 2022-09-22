{ 
  system ? builtins.currentSystem,
  pkgs ? import <nixpkgs> { system = system; },
  version ? "5.0.6",
  type ? "server",
  mirror ? "https://repo.mongodb.org/"
}:

let
  sversion = pkgs.lib.splitString "." version;
  major = pkgs.lib.elemAt sversion 0;
  minor = pkgs.lib.elemAt sversion 1;
  sha256dict = {
    "server4.4.16x86_64-linux" = "sha256-JZjGYCF5Ip0wqr+GTlHw9jdY0ZsswPN0aLdFAK1C35M=";
    "server5.0.10x86_64-linux" = "sha256-NV+a1bBdY5z2559cJYgNYlTvoRfGHVWrvmyWcCLgxls=";
    "server6.0.0x86_64-linux" = "sha256-AJUQ8Jo/T4PDnYtFg3njUZyoH9XXzleZ+nj/knCBKzg=";
    "shell4.4.16x86_64-linux" = "sha256-0u+YKd3Wsw67NE865ks3WgyKpEex0tpJ9FrXAJOMEiM=";
    "shell5.0.10x86_64-linux" = "sha256-tXcN0/Q4XZsQHGjpXSxT+wg52QlKKleJElwEb/CEMuQ=";
    "server4.4.16aarch64-linux" = "sha256-8L+4uwIvhuVw9t4N1CuStHnwIZhOdZqiBsjcN+iIyBI=";
    "server5.0.10aarch64-linux" = "sha256-phLLCL1wXE0pjrb4n1xQjoTVDYuFFRz5RQdfmYj9HPY=";
    "server6.0.0aarch64-linux" = "sha256-nEmpS2HUeQdehQAiFgxKLnnYVV9aPKtUtb/GRS9f+4M=";
    "shell4.4.16aarch64-linux" = "sha256-iaYhzCI7b4OwtqfWBtJEJqFVp+aXu7RG97lqKCTQjtI=";
    "shell5.0.10aarch64-linux" = "sha256-DM8P/QnrYYFdKvmg9HAf9lAmcVG0FI+XIMUi2iiCjwo=";
    # "shell6.0.0" = "sha256-ONTxTi7ezZi0BwPq+tjAuVS0HUw0sLW9u+883BfjNZo=";
  };
  namedict = {
    "server" = "mongodb";
    "shell" = "mongosh";
  };
  binaryName = {
    "server" = "mongod";
    "shell" = "mongo";
  };
  archDict = {
    "x86_64-linux" = "amd64";
    "aarch64-linux" = "arm64";
  };
  arch = pkgs.lib.getAttr system archDict;
  versionDetail = pkgs.lib.concatStrings [type version system];
in pkgs.stdenv.mkDerivation {
  name = "${pkgs.lib.getAttr type namedict}-${version}";
  system = system;
  src = pkgs.fetchurl {
    url = "${mirror}apt/ubuntu/dists/focal/mongodb-org/${major}.${minor}/multiverse/binary-${arch}/mongodb-org-${type}_${version}_${arch}.deb";
    sha256 = if pkgs.lib.hasAttr versionDetail sha256dict then pkgs.lib.getAttr versionDetail sha256dict else "";
  };
  nativeBuildInputs = [
    pkgs.autoPatchelfHook 
    pkgs.dpkg
  ];
  buildInputs = [
    pkgs.openssl_1_1 # libcrypto.so.1.1 libssl.so.1.1
    pkgs.xz # liblzma.so.5
    pkgs.curl # libcurl.so.4
  ];
  unpackPhase = "true";
  installPhase = ''
    mkdir -p $out
    dpkg -x $src $out
    mkdir $out/bin
    mv $out/usr/bin/${pkgs.lib.getAttr type binaryName} $out/bin/${pkgs.lib.getAttr type binaryName}
  '';

  meta = {
    description = "MongoDB";
    homepage = https://www.mongodb.com/;
    maintainers = [ "undefined <i@undefined.moe>" ];
    platforms = [ system ];
  };
}