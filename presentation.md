---
theme: uncover
marp: true
paginate: true
class: lead invert
footer: Source: https://github.com/dylanrjohnston/nixos-talk
---

<style>
  section figure {
    margin-right: 10% !important;
  }
  code {
    white-space: pre-wrap;
  }
  footer {
    text-align: left;
    font-size: .30em;
  }
</style>

![bg contain right:50%](https://upload.wikimedia.org/wikipedia/commons/2/28/Nix_snowflake.svg)

# **Nix**

DevOps Swiss Army Knife

---

# **Why**

---

# **Why**

- Onboarding new devs onto a project
- Differences between **local**, **staging**, **prod**
- Vendoring dependencies is language specific

---

# **What**

---

# **What**

- Reproducible
- Declarative
- Reliable
- Cross language

---

# **How**

---

# **Nix** is How!

---

# What is **Nix?**

---

# What is **Nix**?

<style scoped>
ul { columns: 2; column-gap: 200px;}
</style>

- Nix Language
- Nix Build Tool
- nixpkgs
- NixOS
- Hydra Build Farm
- Nix-Darwin
- NixOps
- nix-hardware
- Flakes
- Nix Binary Cache

---

# **Reproducibility**

---

# **Reproducibility**

_unifies the nix ecosystem_

---

# Ok, but how?

---

# **From Small Things**

# **Big Things Grow**

---

# The **Derivation**

_examples/FirstDerivation.nix_

```nix
derivation {
  name = "MyFirstDerivation";
  builder = "/bin/sh";
  system = builtins.currentSystem;
}
```

---

<style scoped>
pre {
  font-size: 58%;
}
</style>

# The **Derivation**

```sh
$ nix-build ./MyFirstDerivation.nix

this derivation will be built:
  /nix/store/x4va60xrqlcl4ghk43hglc767ldjb8kv-MyFirstDerivation.drv
building '/nix/store/x4va60xrqlcl4ghk43hglc767ldjb8kv-MyFirstDerivation.drv'...

error: builder for '/nix/store/x4va60xrqlcl4ghk43hglc767ldjb8kv-MyFirstDerivation.drv' failed to produce output path for output 'out' at '/nix/store/nh8qhbgn87lpxn87lzwd83qlbmazpqkg-MyFirstDerivation'
```

---

<style scoped>
pre {
  font-size: 50%;
}
</style>

```sh
$ nix show "/nix/store/x4va60xrqlcl4ghk43hglc767ldjb8kv-MyFirstDerivation.drv"

{
  "/nix/store/x4va60xrqlcl4ghk43hglc767ldjb8kv-MyFirstDerivation.drv": {
    "outputs": {
      "out": {
        "path": "/nix/store/nh8qhbgn87lpxn87lzwd83qlbmazpqkg-MyFirstDerivation"
      }
    },
    "inputSrcs": [],
    "inputDrvs": {},
    "system": "aarch64-darwin",
    "builder": "/bin/sh",
    "args": [],
    "env": {
      "builder": "/bin/sh",
      "name": "MyFirstDerivation",
      "out": "/nix/store/nh8qhbgn87lpxn87lzwd83qlbmazpqkg-MyFirstDerivation",
      "system": "aarch64-darwin"
    }
  }
}
```

---

_examples/SecondDerivation.nix_

```nix
let
  pkgs = import <nixpkgs> { };
in
pkgs.runCommand "hello" { buildInputs = [ ]; } ''
  mkdir $out
  echo hello > $out/hello
''
```

---

<style scoped>
pre {
  font-size: 60%;
}
</style>

```sh
$ nix-build ./SecondDerivation.nix
this derivation will be built:
  /nix/store/zhd7xx6383b29prbh1n3ahmg6gh5dyww-hello.drv
building '/nix/store/zhd7xx6383b29prbh1n3ahmg6gh5dyww-hello.drv'...
/nix/store/agsqs1gn98q07r0pq4f8czdc91jcjv5r-hello

$ nix show-derivation "/nix/store/zhd7xx6383b29prbh1n3ahmg6gh5dyww-hello.drv"
```

---

<style scoped>
pre {
  font-size: 45%;
}
</style>

```json
{
  "/nix/store/zhd7xx6383b29prbh1n3ahmg6gh5dyww-hello.drv": {
    "outputs": {
      "out": {
        "path": "/nix/store/agsqs1gn98q07r0pq4f8czdc91jcjv5r-hello"
      }
    },
    "inputSrcs": [
      "/nix/store/9krlzvny65gdc8s7kpb6lkx8cd02c25b-default-builder.sh"
    ],
    "inputDrvs": {
      "/nix/store/g3mr5qyg20r88ilq3cwgn7q0v6n29pyj-stdenv-darwin.drv": ["out"],
      "/nix/store/ns4bvhwbwjjwizgvm4h0yf5gz2p7x7mf-bash-5.1-p16.drv": ["out"]
    },
    "system": "aarch64-darwin",
    "builder": "/nix/store/63a4li401f423jl8v5pwjwmyzlwd3lk9-bash-5.1-p16/bin/bash",
    "args": [
      "-e",
      "/nix/store/9krlzvny65gdc8s7kpb6lkx8cd02c25b-default-builder.sh"
    ],
    "env": {
      "buildCommand": "mkdir $out\necho hello > $out/hello\n",
      "builder": "/nix/store/63a4li401f423jl8v5pwjwmyzlwd3lk9-bash-5.1-p16/bin/bash",
      "name": "hello",
      "out": "/nix/store/agsqs1gn98q07r0pq4f8czdc91jcjv5r-hello",
      "outputs": "out",
      "passAsFile": "buildCommand",
      "stdenv": "/nix/store/ykn4zsm8apska5gbdlm5ci39j4l5lcah-stdenv-darwin",
      "system": "aarch64-darwin"
    }
  }
}
```

---

_examples/ThirdDerivation.nix_

```nix
let
  pkgs = import <nixpkgs> { };
in
pkgs.runCommand "hello" { buildInputs = [ ]; }
  ''
    mkdir $out
    hello > $out/hello
  ''
```

---

<style scoped>
pre {
  font-size: 50%;
}
</style>

```sh
$ nix-build ./ThirdDerivation.nix

this derivation will be built:
  /nix/store/mglq7szgs1ln317kn03g6i432s45lqjh-hello.drv
building '/nix/store/mglq7szgs1ln317kn03g6i432s45lqjh-hello.drv'...

/private/tmp/nix-build-hello.drv-0/.attr-0l2nkwhif96f51f4amnlf414lhl4rv9vh8iffyp431v6s28gsr90: line 2: hello: command not found

error: builder for '/nix/store/mglq7szgs1ln317kn03g6i432s45lqjh-hello.drv' failed with exit code 127;
       last 1 log lines:
       > /private/tmp/nix-build-hello.drv-0/.attr-0l2nkwhif96f51f4amnlf414lhl4rv9vh8iffyp431v6s28gsr90: line 2: hello: command not found
       For full logs, run 'nix log /nix/store/mglq7szgs1ln317kn03g6i432s45lqjh-hello.drv'.
```

---

_examples/FourthDerivation.nix_

```nix
let
  pkgs = import <nixpkgs> { };
in
pkgs.runCommand "hello" { buildInputs = [ ]; }
  ''
    mkdir $out
    ${pkgs.hello}/bin/hello > $out/hello
  ''
```

---

```sh
$ nix-build ./FourthDerivation.nix

this derivation will be built:
  /nix/store/s8jbqqgk886dafzcxh1vzkk5n56swm24-hello.drv
building '/nix/store/s8jbqqgk886dafzcxh1vzkk5n56swm24-hello.drv'...
/nix/store/w06g6hi7dcfyfm6hcnpbamqzjbxbi1gv-hello
```

---

_examples/FifthDerivation.nix_

```nix
let
  pkgs = import <nixpkgs> { };
in
pkgs.runCommand "hello" { buildInputs = [ pkgs.hello ]; }
  ''
    mkdir $out
    hello > $out/hello
  ''
```

---

<style scoped>
pre {
  font-size: 60%;
}
</style>

_examples/SixthDerivation.nix_

```sh
$ hello
Hello, world!

$ which hello
/nix/store/yjvrgqmhv6mzxjgnx4dcc25g1dla8l37-hello-2.12/bin/hello
```

```nix
let
  pkgs = import <nixpkgs> { };
in
pkgs.runCommand "hello" { buildInputs = [ ]; }
  ''
    mkdir $out
    /nix/store/yjvrgqmhv6mzxjgnx4dcc25g1dla8l37-hello-2.12/bin/hello > $out/hello
  ''
```

---

```sh
nix-build ./SixthDerivation.nix

this derivation will be built:
  /nix/store/5xdiy0nkn4kjy2jgzshnq44i3fa4038p-hello.drv
building '/nix/store/5xdiy0nkn4kjy2jgzshnq44i3fa4038p-hello.drv'...

/private/tmp/nix-build-hello.drv-0/.attr-0l2nkwhif96f51f4amnlf414lhl4rv9vh8iffyp431v6s28gsr90: line 2: /nix/store/yjvrgqmhv6mzxjgnx4dcc25g1dla8l37-hello-2.12/bin/hello:
Operation not permitted
error: builder for '/nix/store/5xdiy0nkn4kjy2jgzshnq44i3fa4038p-hello.drv' failed with exit code 126;
```

---

# **nixpkgs**

---

# **nixpkgs**

- https://github.com/nixos/nixpkgs
- 80,000+ packages ready to build
- Tools for building almost any language
- Free binary cache https://cache.nixos.org
- Hydra Continuos Build Farm

---

# **nixpkgs**

- Branches (nixpkgs|nixos)-(YY.MM|unstable)
- LTS release every 6 months e.g. 21.11
  - Only updates for CVEs
- **unstable** follows master after tests pass
- **nixpkgs** ensures all packages build
- **nixos** ensures additional NixOS tests pass

---

# Example: **_Go_**

---

<style scoped>
pre {
  font-size: 50%;
}
</style>

```nix
{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-outline";
  version = "unstable-2021-06-08";

  src = fetchFromGitHub {
    owner = "ramya-rao-a";
    repo = "go-outline";
    rev = "9736a4bde949f321d201e5eaa5ae2bcde011bf00";
    sha256 = "sha256-5ns6n1UO9kRSw8iio4dmJDncsyvFeN01bjxHxQ9Fae4=";
  };

  vendorSha256 = "sha256-jYYtSXdJd2eUc80UfwRRMPcX6tFiXE3LbxV3NAdKVKE=";

  meta = with lib; {
    description = "Utility to extract JSON representation of declarations from a Go source file";
    homepage = "https://github.com/ramya-rao-a/go-outline";
    maintainers = with maintainers; [ SuperSandro2000 vdemeester ];
    license = licenses.mit;
  };
}
```

---

# **NixOS**

---

# **NixOS**

- Declarative OS Configuration
- Nix Build System applied to Linux
- Easy rollback in OS and through Grub
- Easily turn config into VM or Cloud Image

---

![bg](https://miro.medium.com/max/1322/0*N-0qKZwmEtqVMQ0V.png)

---

# **NixOS**

Easily configure complex services

```nix
{
  virtualisation.libvirtd.enable = true;
}
```

---

# **NixOS**

Easily configure complex services

```nix
{
  services.kubernetes.roles = ["master" "node"];
}
```

---

# **NixOS**

Easily configure complex services

```nix
{
  services.minecraft-server = {
    enable = true;
    eula = true;
  };
}
```

---

# **NixOS**

Turn into AMI

```
nix build .#config.system.build.amazonImage.x86_64-linux
```

---

# **NixOS**

Turn into VM

```
nix build .#config.system.build.vm
```

---

# **NixOS**

Turn into SD Card Image

```
nix build .#config.system.build.sdImage
```

---

# **nix-hardware**

---

# **nix-hardware**

- https://github.com/NixOS/nixos-hardware
- NixOS modules for better hardware support
- GPU, Audio, Network config for laptops
- Even supports Raspberry PI, etc

---

# **nix-hardware**

Raspberry PI Hardware Support

```nix
{ hardware, modulesPath, lib, ... }: {
  imports = [
    "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"
    hardware.nixosModules.raspberry-pi-4
  ];

  hardware.raspberry-pi."4" = {
    dwc2.enable = true;
    fkms-3d.enable = true;
  };
}
```

---

# **Nix-Darwin**

---

# **Nix-Darwin**

- Nix Build System applied to OS X
- More limited configuration than NixOS
- Easily provision developer machines
- Integrates with Homebrew for GUI apps

---

# **Flakes**

---

# **Flakes**

- A new standard for building and distributing packages
- Directly interacts with git
- Removes the centralised dependence on **nixpkgs**
- A new unified and improved dev UX cli

---

<style scoped>
pre {
  font-size: 50%;
}
</style>

# **Flakes**

https://nixos.wiki/wiki/Flakes#Flake_schema

```nix
{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }: {
    defaultPackage.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.hello;
  };
}
```

---

<style scoped>
pre {
  font-size: 45%;
}
</style>

```json
{
  "nodes": {
    "nixpkgs": {
      "locked": {
        "lastModified": 1655332021,
        "narHash": "sha256-LZcCR0/4oQUrmmyBBGdGcMYz0fJA0pdhb4PLaPvjrq0=",
        "owner": "nixos",
        "repo": "nixpkgs",
        "rev": "f649383c5a34f3599f1142f0756535dceed2eb31",
        "type": "github"
      },
      "original": {
        "owner": "nixos",
        "ref": "nixpkgs-unstable",
        "repo": "nixpkgs",
        "type": "github"
      }
    },
    "root": {
      "inputs": {
        "nixpkgs": "nixpkgs"
      }
    }
  },
  "root": "root",
  "version": 7
}
```

---

<style scoped>
pre {
  font-size: 65%;
}
</style>

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };


  outputs = { self, nixpkgs utils }: utils.lib.eachSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      defaultPackage = pkgs.hello;
    }
  );
}
```

---

# **Dev Env**

---

# **Dev Env**

direnv ❤️ nix

---

# **Dev Env**

- flake.nix
- .envrc

---

<style scoped>
pre {
  font-size: 40%;
}
</style>

```nix
{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShell = pkgs.mkShell {
        buildInputs = with pkgs;
          [
            # Golang Dev Tools
            air
            delve
            go_1_18
            go-outline
            go-swagger
            golangci-lint
            gopkgs
            gopls
            gotests
            impl

            # Local Dev Depedencies
            postgresql
            yq-go
            docker-compose
          ];
      };
    });
}
```

---

# **Dev Env**

`pkgs.mkShell` is not special

```sh
nix develop nixpkgs#postgresql
```

---

# **Docker?**

---

# **Docker** ❤️ **Nix**

---

# **Docker** ❤️ **Nix**

- Docker is three different things
  - Build system (Dockerfile)
  - Packaging (OCI Spec)
  - Sandbox (Cgroup)

---

# **Docker** ❤️ **Nix**

Dockerfiles kinda suck

[![invert w:300px](https://chart.googleapis.com/chart?cht=qr&chl=https%3A%2F%2Fyoutu.be%2FpfIDYQ36X0k&chs=180x180&choe=UTF-8&chld=L|2')](https://youtu.be/pfIDYQ36X0k)

---

# **Docker** ❤️ **Nix**

- Docker images are often bloated and even bootable
- Dockerfile is not actually reproducible
  - `sudo apt get update`
  - `wget https://mutable.url`
- Caching strategy is coarse
- "Best practice" multi-stage builds

---

# **Docker** ❤️ **Nix**

![invert](https://grahamc.com/resources/2018-09-28-docker-images/docker.svg)

---

# **Docker** ❤️ **Nix**

![invert](https://grahamc.com/resources/2018-09-28-docker-images/nix.svg)

---

# **Docker** ❤️ **Nix**

![invert](https://grahamc.com/resources/2018-09-28-docker-images/bash-weighted-step0.svg)

---

# **Docker** ❤️ **Nix**

https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/docker/examples.nix

```nix
pkgs.dockerTools.buildLayeredImage {
    name = "layered-image";
    tag = "latest";
    config.Cmd = [ "${pkgs.hello}/bin/hello" ];
    contents = [ pkgs.hello pkgs.bash pkgs.coreutils ];
};
```

---

# **Docker** ❤️ **Nix**

- Use Nix to build Docker Container
- Incremental adoption of Nix tooling
- Nix "evaporates" once container is built
- Use best parts of Nix and best parts of Docker

---

# **Cool stuff**

---

<style scoped>
pre {
  font-size: 50%;
}
</style>

# **nix-store**

```sh
$ nix-store --query --tree /run/current-system

/nix/store/s5hcbifa8sz7j9bv9vd1s1dj6z3z6dwv-darwin-system-22.05.20220518.52dc75a+darwin4.2f2bdf6
├───/nix/store/2f9rvfncfhry735y62wm5xq7iq5q523w-system-path
│   ├───/nix/store/1iicyyi4kbkxp6lc2crif84hh771h2yw-pam-reattach
│   │   └───/nix/store/ss49hlzi8ylf25qlz0kad53w3sb7v3wc-apple-framework-CoreFoundation-11.0.0
│   │       └───/nix/store/jdd0m28njvjmkcnj896276j9zihjpkwx-libobjc-11.0.0
│   ├───/nix/store/46bh97byarr1w1037kc8rkb4xhknjwc6-bash-interactive-5.1-p16-man
│   ├───/nix/store/4gv9ardyaqrjbvycp3zm0wy6vh7j4mci-darwin-help
│   │   ├───/nix/store/hdisxsi8vybqvwqs22kjrpb58jxs163b-bash-5.1-p16
│   │   │   └───/nix/store/hdisxsi8vybqvwqs22kjrpb58jxs163b-bash-5.1-p16 [...]
│   │   └───/nix/store/xy1vwiiymgsyx4a1k20hzqkl6ya8r8ak-darwin-manual-html
│   │       └───/nix/store/xy1vwiiymgsyx4a1k20hzqkl6ya8r8ak-darwin-manual-html [...]
│   ├───/nix/store/6kmx0q0qdf8a9i02nk5hrv104ra7szdm-darwin-option
│   │   └───/nix/store/hdisxsi8vybqvwqs22kjrpb58jxs163b-bash-5.1-p16 [...]
```

---

<style scoped>
pre {
  font-size: 60%;
}
</style>

# **nix why-depends**

```sh
nix why-depends /run/current-system /nix/store/71rnnfggiqfqijlwaip1jw7yar9rgbvn-perl5.34.1-URI-5.05

/nix/store/s5hcbifa8sz7j9bv9vd1s1dj6z3z6dwv-darwin-system-22.05.20220518.52dc75a+darwin4.2f2bdf6
└───/nix/store/2f9rvfncfhry735y62wm5xq7iq5q523w-system-path
    └───/nix/store/zri01pzds0ay08l1ycrw57y6w3c1w9z9-git-2.36.0
        └───/nix/store/71rnnfggiqfqijlwaip1jw7yar9rgbvn-perl5.34.1-URI-5.05
```

---

# **nix bundle**

packs the closure of the installable into a single self-extracting executable

```sh
nix bundle nixpkgs#hello
```

---

# **nix copy**

- Copy the entire current NixOS system closure to another machine via SSH:
  ```
  nix copy -s --to ssh://server /run/current-system
  ```
- Copy Hello to a binary cache in an Amazon S3 bucket
  ```
  nix copy --to s3://my-bucket?region=eu-west-1 nixpkgs#hello
  ```

---

# **nix repl**

Start an interactive nix shell

```
$ nix repl
nix-repl> 1 + 2
3
nix-repl> pkgs = builtins.getFlake "nixpkgs"
nix-repl> pkgs.legacyPackages.aarch64-darwin.hello
«derivation /nix/store/9f38cibp8lx5x8dig0gi5g33jkm3qlav-hello-2.12.drv»
```

---

<style scoped>
pre {
  font-size: 55%;
}
</style>

# **nix search**

```
$ nix search nixpkgs yq yaml

* legacyPackages.aarch64-darwin.python310Packages.yq (2.14.0)
  Command-line YAML/XML/TOML processor - jq wrapper for YAML, XML, TOML documents

* legacyPackages.aarch64-darwin.python39Packages.yq (2.14.0)
  Command-line YAML/XML/TOML processor - jq wrapper for YAML, XML, TOML documents

* legacyPackages.aarch64-darwin.yq (2.14.0)
  Command-line YAML/XML/TOML processor - jq wrapper for YAML, XML, TOML documents

* legacyPackages.aarch64-darwin.yq-go (4.25.1)
  Portable command-line YAML processor
```

---

<style scoped>
pre {
  font-size: 60%;
}
</style>

### **nix store make-content-addressed**

```
$ nix copy --to /private/tmp/nix --trusted-public-keys '' /nix/store/h2vj9r5g4c2rlb54w0h8phn2j8zh33wj-hello-2.12

error: cannot add path '/nix/store/jdd0m28njvjmkcnj896276j9zihjpkwx-libobjc-11.0.0' because it lacks a valid signature
```

```sh
$ nix store make-content-addressed nixpkgs#hello

rewrote '/nix/store/h2vj9r5g4c2rlb54w0h8phn2j8zh33wj-hello-2.12' to '/nix/store/28g4jjzraxf3vgihbnvrh58p1lld5673-hello-2.12'

$ nix copy --to /private/tmp/nix --trusted-public-keys '' /nix/store/28g4jjzraxf3vgihbnvrh58p1lld5673-hello-2.12
```

---

# **Drawbacks**

---

# **Drawbacks**

- Documentation is often non-existent or outdated
- Often resort to reading the source code
- Nix is a **_lazy_** and **_functional_** language
- Turing complete, a lot of rope to hang yourself
- Ecosystem in the middle of a transition (Flakes)
- Eats a lot of a project's "innovation" budget

---

# **However?**

Much like git

---

<style scoped>
ul { columns: 2; column-gap: 200px;}
</style>

# **Companies Using Nix**

- Tumblr
- Shopify
- TeamViewer
- Fugro
- akvelon.com
- Mozilla
- Target (US)
- cars.com
- repl.it
- Standard Cognition

---

# **Further Resources**

- Nix from First Principles: [Nix Pills](https://nixos.org/guides/nix-pills/)
- Cloud IDE with Nix support: [repl.it](https://replit.com/)
- Nix Packages: [GitHub](https://github.com/NixOS/nixpkgs)
- Nix Sandbox: `docker run -it nixos/nix bash`
- My Nix Config: [Github](https://github.com/DylanRJohnston/nixos)
