derivation {
  name = "MyFirstDerivation";
  builder = "/bin/sh";
  system = builtins.currentSystem;
}
