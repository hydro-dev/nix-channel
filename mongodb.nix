{ system ? builtins.currentSystem
, pkgs
, version ? "7.0.28"
, mirrors ? [
    "https://mirrors.nju.edu.cn/mongodb/"
    "https://mirror.iscas.ac.cn/mongodb/"
    "https://mirrors.tuna.tsinghua.edu.cn/mongodb/"
    "https://repo.mongodb.org/"
  ]
}:

let
  major = pkgs.lib.elemAt (pkgs.lib.splitString "." version) 0;
  sha256dict = {
    "4.4.30x86_64-linux" = "sha256-VxbkCMKFIRxyhDzTlXlPcCluPz8MKmUPdCK4QcjvseU=";
    "5.0.32x86_64-linux" = "sha256-eV4rHHPTmcxFRizujWMkjEZ3yxwCetJ2RayKtRuWp2Q=";
    "6.0.27x86_64-linux" = "sha256-kjHJ42mT5+EGIPnM8Vv3j6npeUOGByDc/4yX3d5XUq8=";
    "7.0.28x86_64-linux" = "sha256-3oDvm5PAX6H+85c4P3xdYf/gctb9oAilgrtbLd/QvDc=";
    "8.2.3x86_64-linux" = "sha256-5oGk7dx8cWGU0lyoNSt8Hm9QgbVSzWOdnAKpKtBi5kY=";
    "4.4.30aarch64-linux" = "sha256-tLHuFov47sMmSXf1UeSfZztCNHNwrwk+p6FivjlEyVA=";
    "5.0.32aarch64-linux" = "sha256-qjWBO+JCpe6r+Tx66ojQpEHI88Z0QO8V3AinhPUpRLc=";
    "6.0.27aarch64-linux" = "sha256-oLhX4xO5KnrGnQEam+GM97SuabH7tNLMJbSAI0ZbO2s=";
    "7.0.28aarch64-linux" = "sha256-Pavus1VuK27fe7QExYDpUza6j0+MhVclA7kBtfpeWIo=";
    "8.2.3aarch64-linux" = "sha256-AbG4Xfnqcm+z7AvA2/ltEp58Qdp6EF3UdzHCT5iD9Fs=";
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
      (if nmajor >= 6 then "apt/ubuntu/dists/jammy" else "apt/ubuntu/dists/focal")
      "/mongodb-org/"
      "${major}.${minor}"
      "/multiverse/binary-"
      arch
      "/mongodb-org-server_"
      version
      "_"
      arch
      ".deb"
    ];
  expectedHash = if pkgs.lib.hasAttr versionDetail sha256dict then pkgs.lib.getAttr versionDetail sha256dict else "";
  debFile = pkgs.stdenvNoCC.mkDerivation {
    name = "mongodb-deb-${version}";
    inherit system;
    unpackPhase = "true";
    installPhase = pkgs.lib.concatStringsSep "\n" (map
      (mirror: ''
        echo "Trying to download from ${mirror}${buildDownloadUrl system version}"
        SSL_CERT_FILE="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt" ${pkgs.curl}/bin/curl -o $out ${mirror}${buildDownloadUrl system version} || true
        hash=$(${pkgs.nix}/bin/nix --extra-experimental-features nix-command --extra-experimental-features flakes hash file $out --type sha256)
        echo "Got hash $hash , expect ${expectedHash}"
        if [ "$hash" == "${expectedHash}" ]; then
          echo "Download success"
          exit 0
        fi
        exit 1
      '')
      mirrors);
    outputHashMode = "flat";
    outputHashAlgo = "sha256";
    outputHash = expectedHash;
  };
in
pkgs.stdenvNoCC.mkDerivation {
  name = "hydro-mongodb-${version}";
  inherit system;
  src = debFile;
  # https://github.com/oxalica/rust-overlay/commit/c949d341f2b507857d589c48d1bd719896a2a224
  depsHostHost = pkgs.lib.optional (!pkgs.stdenv.hostPlatform.isDarwin) pkgs.gccForLibs.lib;
  nativeBuildInputs = [
    pkgs.autoPatchelfHook
    pkgs.dpkg
  ];
  buildInputs = [
    pkgs.xz # liblzma.so.5
    pkgs.curl # libcurl.so.4
  ] ++ (if (pkgs.lib.strings.toInt major) <= 5 then [
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
    homepage = "https://www.mongodb.com/";
    maintainers = with pkgs.lib.maintainers; [ undefined-moe ];
    platforms = [ system ];
  };
}
