let
  pkgs = import <nixpkgs> { };
in
pkgs.runCommand "hello" { buildInputs = [ ]; }
  ''
    mkdir $out
    /nix/store/yjvrgqmhv6mzxjgnx4dcc25g1dla8l37-hello-2.12/bin/hello > $out/hello
  ''
