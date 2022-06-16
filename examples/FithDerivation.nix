let
  pkgs = import <nixpkgs> { };
in
pkgs.runCommand "hello" { buildInputs = [ pkgs.hello ]; }
  ''
    mkdir $out
    hello > $out/hello
  ''
