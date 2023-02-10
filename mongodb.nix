{ 
  system ? builtins.currentSystem,
  pkgs ? import <nixpkgs> { system = system; },
  version ? "5.0.6",
  mirror ? "https://repo.mongodb.org/"
}:

let
  sversion = pkgs.lib.splitString "." version;
  major = pkgs.lib.elemAt sversion 0;
  minor = pkgs.lib.elemAt sversion 1;
  sha256dict = {
    "4.4.16x86_64-linux" = "sha256-JZjGYCF5Ip0wqr+GTlHw9jdY0ZsswPN0aLdFAK1C35M=";
    "5.0.10x86_64-linux" = "sha256-NV+a1bBdY5z2559cJYgNYlTvoRfGHVWrvmyWcCLgxls=";
    "6.0.0x86_64-linux" = "sha256-AJUQ8Jo/T4PDnYtFg3njUZyoH9XXzleZ+nj/knCBKzg=";
    "4.4.16aarch64-linux" = "sha256-8L+4uwIvhuVw9t4N1CuStHnwIZhOdZqiBsjcN+iIyBI=";
    "5.0.10aarch64-linux" = "sha256-phLLCL1wXE0pjrb4n1xQjoTVDYuFFRz5RQdfmYj9HPY=";
    "6.0.0aarch64-linux" = "sha256-nEmpS2HUeQdehQAiFgxKLnnYVV9aPKtUtb/GRS9f+4M=";
  };
  archDict = {
    "x86_64-linux" = "amd64";
    "aarch64-linux" = "arm64";
  };
  arch = pkgs.lib.getAttr system archDict;
  versionDetail = pkgs.lib.concatStrings [version system];
in pkgs.stdenv.mkDerivation {
  name = "hydro-mongodb-${version}";
  system = system;
  src = pkgs.fetchurl {
    url = "${mirror}apt/ubuntu/dists/focal/mongodb-org/${major}.${minor}/multiverse/binary-${arch}/mongodb-org-server_${version}_${arch}.deb";
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
    mv $out/usr/bin/mongod $out/bin/mongod
  '';

  meta = {
    description = "MongoDB";
    homepage = https://www.mongodb.com/;
    maintainers = [ "undefined <i@undefined.moe>" ];
    platforms = [ system ];
  };
}