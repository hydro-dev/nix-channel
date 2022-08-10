{ 
  pkgs ? import <nixpkgs> { system = "x86_64-linux"; },
  gcc ? pkgs.gcc-unwrapped
}:

let
  gccPatched = pkgs.runCommand "gcc" {} ''
    cp -r ${gcc} $out
    function gchgen {
      echo $2 $3
      ${gcc}/bin/g++ -x c++-header -lm -fno-stack-limit -fdiagnostics-color=always -std=$2 -c $1 -o $1.gch/$2.gch $3
    }
    function ensureSingleCache {
      echo "Creating cache for $1"
      cd $(dirname $1)
      filename=$(basename $1)
      chmod 755 .
      mkdir $1.gch -p
      gchgen $filename c++98
      gchgen $filename c++03
      gchgen $filename c++11
      gchgen $filename c++14
      gchgen $filename c++17
      gchgen $filename c++2a
      gchgen $filename c++98 -O2
      gchgen $filename c++03 -O2
      gchgen $filename c++11 -O2
      gchgen $filename c++14 -O2
      gchgen $filename c++17 -O2
      gchgen $filename c++2a -O2
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
in pkgs.wrapCC gccPatched