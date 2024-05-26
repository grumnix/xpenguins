{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";

    xpenguins_src.url = "http://xpenguins.seul.org/xpenguins-2.2.tar.gz";
    xpenguins_src.flake = false;
  };

  outputs = { self, nixpkgs, flake-utils, xpenguins_src }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages = rec {
          default = xpenguins;

          xpenguins = pkgs.stdenv.mkDerivation rec {
            pname = "xpenguins";
            version = "2.2";

            src = xpenguins_src;

            patches = [
              ./fix-snprintf-error.diff
            ];

            buildInputs = with pkgs; [
              xorg.libX11
              xorg.libXpm
              xorg.libXt
              xorg.libXext
            ];
          };
        };
      }
    );
}
