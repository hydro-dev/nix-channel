{ pkgs ? import <nixpkgs> { system = "x86_64-linux"; } }:

pkgs.stdenv.mkDerivation {
  name = "mongodb-5.0.6";
  system = "x86_64-linux";
  src = pkgs.fetchurl {
    url = "https://repo.mongodb.org/apt/ubuntu/dists/focal/mongodb-org/5.0/multiverse/binary-amd64/mongodb-org-server_5.0.6_amd64.deb";
    hash = "sha256-Rk43PNQN8p2/3XDDjWOzJmzBjs39CR06kLrTtr+5ngo=";
  };
  nativeBuildInputs = [
    pkgs.autoPatchelfHook 
    pkgs.dpkg
  ];
  buildInputs = [
    pkgs.glibc
    pkgs.openssl # libcrypto.so.1.1 libssl.so.1.1
    pkgs.xz # liblzma.so.5
    pkgs.curl # libcurl.so.4
    pkgs.gcc-unwrapped
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
    platforms = [ "x86_64-linux" ];
  };
}