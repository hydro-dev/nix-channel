{ 
  pkgs ? import <nixpkgs> { system = "x86_64-linux"; },
  version ? "5.0.6"
}:

let
  sversion = pkgs.lib.splitString "." version;
  major = pkgs.lib.elemAt sversion 0;
  minor = pkgs.lib.elemAt sversion 1;
  sha256dict = {
    "4.4.15" = "sha256-BtqsK0A+lL8GajRc2WDMUESVEsTDk4e3ULAhVTIkI8U=";
    "5.0.6" = "sha256-Rk43PNQN8p2/3XDDjWOzJmzBjs39CR06kLrTtr+5ngo=";
  };
in pkgs.stdenv.mkDerivation {
  name = "mongodb-${version}";
  system = "x86_64-linux";
  src = pkgs.fetchurl {
    url = "https://repo.mongodb.org/apt/ubuntu/dists/focal/mongodb-org/${major}.${minor}/multiverse/binary-amd64/mongodb-org-server_${version}_amd64.deb";
    sha256 = if pkgs.lib.hasAttr version sha256dict then pkgs.lib.getAttr version sha256dict else "";
  };
  nativeBuildInputs = [
    pkgs.autoPatchelfHook 
    pkgs.dpkg
  ];
  buildInputs = [
    pkgs.openssl # libcrypto.so.1.1 libssl.so.1.1
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
    platforms = [ "x86_64-linux" ];
  };
}