{ system ? builtins.currentSystem
, pkgs
, version ? "7.0.11"
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
    "4.4.16x86_64-linux" = "sha256-JZjGYCF5Ip0wqr+GTlHw9jdY0ZsswPN0aLdFAK1C35M=";
    "5.0.10x86_64-linux" = "sha256-NV+a1bBdY5z2559cJYgNYlTvoRfGHVWrvmyWcCLgxls=";
    "6.0.0x86_64-linux" = "sha256-AJUQ8Jo/T4PDnYtFg3njUZyoH9XXzleZ+nj/knCBKzg=";
    "6.0.12x86_64-linux" = "sha256-Fgk42wwdKLDZJsE1GxB4fcB1z22P0zkDxDb0HXu1ZsM=";
    "7.0.11x86_64-linux" = "sha256-NCRNvYnR0GfJ9q9pDmQWR7Cs6GgGalMxuTF0mdfXsZs=";
    "4.4.16aarch64-linux" = "sha256-8L+4uwIvhuVw9t4N1CuStHnwIZhOdZqiBsjcN+iIyBI=";
    "5.0.10aarch64-linux" = "sha256-phLLCL1wXE0pjrb4n1xQjoTVDYuFFRz5RQdfmYj9HPY=";
    "6.0.0aarch64-linux" = "sha256-nEmpS2HUeQdehQAiFgxKLnnYVV9aPKtUtb/GRS9f+4M=";
    "6.0.12aarch64-linux" = "sha256-0xAOKjFYVIIoRtDm6Cdqq+WP+ArpVlOna/YqePF3XKI=";
    "7.0.11aarch64-linux" = "sha256-g+7fCH4KWxDCsCtlkrts8i+ARy3jigF3O2tEINVE5b0=";
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
      (if nmajor >= 7 then "apt/ubuntu/dists/jammy" else "apt/ubuntu/dists/focal")
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
        hash=$(${pkgs.busybox}/bin/busybox sha256sum $out | ${pkgs.gawk}/bin/awk '{print $1}')
        if [ "$hash" == "${expectedHash}" ]; then
          echo "Download success"
          exit 0
        fi
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
    homepage = "https://www.mongodb.com/";
    maintainers = with pkgs.lib.maintainers; [ undefined-moe ];
    platforms = [ system ];
  };
}
