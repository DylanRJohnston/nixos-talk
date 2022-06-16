# MySecondDerivation.nix
let
  pkgs = import <nixpkgs> { };
in
pkgs.runCommand "hello" { buildInputs = [ ]; } ''
  mkdir $out
  echo hello > $out/hello
''
