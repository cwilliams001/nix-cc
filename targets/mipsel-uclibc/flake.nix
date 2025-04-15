{
  description = "Cross-compile reverse shell to MIPS/uClibc using Bootlin toolchain";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      toolchain = pkgs.fetchurl {
        url = "https://toolchains.bootlin.com/downloads/releases/toolchains/mips32el/tarballs/mips32el--uclibc--stable-2020.08-1.tar.bz2";
        sha256 = "sha256-g5gBDqPb1D7pm2vg4zQNtEsyIovwY6nBO/Q6NZ49H24=";
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

          export CC=mipsel-buildroot-linux-uclibc-gcc
          export AR=mipsel-buildroot-linux-uclibc-ar
          export STRIP=mipsel-buildroot-linux-uclibc-strip

          export PS1="(nix-mipsel-uclibc) $PS1"

          echo "✅ Entered nix-shell for MIPSEL (Little Endian) uClibc"
          echo "🔧 Toolchain in PATH: $CC"
        '';
      };
    };
}

