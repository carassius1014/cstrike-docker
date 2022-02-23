{ }:

let pkgs = import ./nix/pkgs.nix;
in pkgs.mkShell { buildInputs = [ pkgs.nixfmt ]; }
