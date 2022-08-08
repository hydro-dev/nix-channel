let
  # Import sources
  sources = import ./nix/sources.nix;

  hello = pkgs.writeShellScriptBin "hello" ''
    echo "Hello from the Nix channel overlay!"
  '';

  pkgs = import sources.nixpkgs {
    overlays = [
      (self: super: {
        inherit hello;
      })
    ];
  };

# And return that specific nixpkgs
in sources.nixpkgs