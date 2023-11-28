{ system ? builtins.currentSystem
, pkgs ? import <nixpkgs> { system = system; }
, version ? "6.0.12"
, mirror ? "https://repo.mongodb.org/"
}:

let
  major = pkgs.lib.elemAt (pkgs.lib.splitString "." version) 0;
  sha256dict = {
    "4.4.16x86_64-linux" = "sha256-JZjGYCF5Ip0wqr+GTlHw9jdY0ZsswPN0aLdFAK1C35M=";
    "5.0.10x86_64-linux" = "sha256-NV+a1bBdY5z2559cJYgNYlTvoRfGHVWrvmyWcCLgxls=";
    "6.0.0x86_64-linux" = "sha256-AJUQ8Jo/T4PDnYtFg3njUZyoH9XXzleZ+nj/knCBKzg=";
    "6.0.12x86_64-linux" = "sha256-7HHYBSMYudDUg/8HiCRkn4iCAjIkLpZLCeokLTHLgUA=";
    "7.0.4x86_64-linux" = "sha256-6C/K+SwEMAX1wsJH1ltQAVWjKY2aNqfqv5EXcER4WCY=";
    "4.4.16aarch64-linux" = "sha256-8L+4uwIvhuVw9t4N1CuStHnwIZhOdZqiBsjcN+iIyBI=";
    "5.0.10aarch64-linux" = "sha256-phLLCL1wXE0pjrb4n1xQjoTVDYuFFRz5RQdfmYj9HPY=";
    "6.0.0aarch64-linux" = "sha256-nEmpS2HUeQdehQAiFgxKLnnYVV9aPKtUtb/GRS9f+4M=";
    "6.0.12aarch64-linux" = "sha256-OEZKPsvDARZOBECg083inqfqPc6jnjckY1IY2Yb3IbE=";
  };
  versionDetail = pkgs.lib.concatStrings [ version system ];
  buildDownloadUrl = system: version:
    let
      archDict = {
        "x86_64-linux" = "amd64";
        "aarch64-linux" = "arm64";
      };
      arch = pkgs.lib.getAttr system archDict;
      sversion = pkgs.lib.splitString "." version;
      major = pkgs.lib.elemAt sversion 0;
      minor = pkgs.lib.elemAt sversion 1;
      nmajor = pkgs.lib.strings.toInt major;
    in
    pkgs.lib.concatStrings [
      mirror
      # Prefer debian bookworm as its package was built with openssl3
      (if nmajor >= 7 then "apt/debian/dists/bookworm" else "apt/ubuntu/dists/bionic")
      "/mongodb-org/"
      "${major}.${minor}"
      (if nmajor >= 7 then "/main" else "/multiverse")
      "/binary-"
      arch
      "/mongodb-org-server_"
      version
      "_"
      arch
      ".deb"
    ];
in
pkgs.stdenvNoCC.mkDerivation {
  name = "hydro-mongodb-${version}";
  inherit system;
  src = pkgs.fetchurl {
    url = buildDownloadUrl system version;
    sha256 = if pkgs.lib.hasAttr versionDetail sha256dict then pkgs.lib.getAttr versionDetail sha256dict else "";
  };
  # https://github.com/oxalica/rust-overlay/commit/c949d341f2b507857d589c48d1bd719896a2a224
  depsHostHost = pkgs.lib.optional (!pkgs.hostPlatform.isDarwin) pkgs.gccForLibs.lib;
  nativeBuildInputs = [
    pkgs.autoPatchelfHook
    pkgs.dpkg
  ];
  buildInputs = [
    pkgs.xz # liblzma.so.5
    pkgs.curl # libcurl.so.4
  ] ++ (if (pkgs.lib.strings.toInt major) <= 6 then [
    pkgs.openssl_1_1 # libcrypto.so.1.1 libssl.so.1.1
  ] else [ ]);
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
    maintainers = with pkgs.lib.maintainers; [ undefined-moe ];
    platforms = [ system ];
  };
}
