let
  pkgs = import <nixpkgs> { };
in
pkgs.runCommand "hello" { buildInputs = [ ]; }
  ''
    mkdir $out
    hello > $out/hello
  ''
