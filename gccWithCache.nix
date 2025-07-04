{ system ? builtins.currentSystem
, pkgs ? import <nixpkgs> { system = system; }
, gccUnwrapped ? pkgs.gcc-unwrapped
}:

let
  gccPatched = pkgs.runCommand "gcc"
    {
      outputs = [ "out" "lib" "libgcc" ];
    } ''
    cp -r ${gccUnwrapped} $out
    cp -a ${gccUnwrapped.lib} $lib
    cp -a ${gccUnwrapped.libgcc} $libgcc
    function gchgen {
      ${gccUnwrapped}/bin/g++ -x c++-header -lm -fno-stack-limit -fdiagnostics-color=always -std=$3 -c $1 -o $1.gch/$2.gch $4 &
    }
    function ensureSingleCache {
      echo "Creating cache for $1"
      cd $(dirname $1)
      filename=$(basename $1)
      chmod 755 .
      mkdir $1.gch -p
      gchgen $filename 98 c++98
      gchgen $filename 03 c++03
      gchgen $filename 11 c++11
      gchgen $filename 14 c++14
      gchgen $filename 17 c++17
      gchgen $filename 2a c++2a
      wait
      gchgen $filename 98o2 c++98 -O2
      gchgen $filename 03o2 c++03 -O2
      gchgen $filename 11o2 c++11 -O2
      gchgen $filename 14o2 c++14 -O2
      gchgen $filename 17o2 c++17 -O2
      gchgen $filename 2ao2 c++2a -O2
      gchgen $filename 23o2 c++23 -O2
      wait
    }
    function ensureCache {
      filename=$(basename $1)
      found=$(find $out -name $filename | grep $1)
      echo $found
      ensureSingleCache $found
    }
    ensureCache bits/stdc++.h
    ensureCache iostream
    ensureCache cstdio
  '';
in
pkgs.wrapCC gccPatched
