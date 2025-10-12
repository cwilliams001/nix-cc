{
  description = "AArch64/musl cross-compilation environment using Bootlin toolchain";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      toolchain = pkgs.fetchurl {
        url = "https://toolchains.bootlin.com/downloads/releases/toolchains/aarch64/tarballs/aarch64--musl--stable-2018.02-2.tar.bz2";
        sha256 = "sha256-iEem0AJw3fbqZpVk+LDQWtRlD3vvKsKi14hEUZ70J34=";
      };

      toolchainUnpacked = pkgs.runCommand "unpack-bootlin-toolchain" {
        nativeBuildInputs = [ pkgs.bzip2 pkgs.gnutar ];
      } ''
        mkdir -p $out
        tar -xjf ${toolchain} -C $out --strip-components=1
      '';
    in {
      devShells.${system}.default = pkgs.mkShell {
        shellHook = ''
          export TOOLCHAIN_DIR=${toolchainUnpacked}
          export PATH=$TOOLCHAIN_DIR/bin:$PATH

          export CC=aarch64-buildroot-linux-musl-gcc
          export AR=aarch64-buildroot-linux-musl-ar
          export STRIP=aarch64-buildroot-linux-musl-strip

          echo "✅ AArch64 / musl toolchain ready!"
          echo "🔧 Use: $CC -static -o revshell reverse_shell.c"
        '';
      };
    };
}
