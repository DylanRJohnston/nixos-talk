let
  pkgs = import <nixpkgs> { };
in
pkgs.runCommand "hello" { buildInputs = [ ]; }
  ''
    mkdir $out
    ${pkgs.hello}/bin/hello > $out/hello
  ''
