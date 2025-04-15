{
  description = "MIPS (Big Endian)/uClibc cross-compilation environment using Bootlin toolchain";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: 
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      toolchain = pkgs.fetchurl {
        url = "https://toolchains.bootlin.com/downloads/releases/toolchains/mips32/tarballs/mips32--uclibc--stable-2020.08-1.tar.bz2";
        sha256 = "sha256-TB2jfRMfTmawdTZwfG0b494pcZ8ig0bUyGDEs8tP7zE=";
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

          export CC=mips-buildroot-linux-uclibc-gcc
          export AR=mips-buildroot-linux-uclibc-ar
          export STRIP=mips-buildroot-linux-uclibc-strip

          export PS1="(nix-mips-uclibc) $PS1"

          echo "✅ Entered nix-shell for MIPS (Big Endian) uClibc"
          echo "🔧 Toolcahin in PATH: $CC"
        '';
      };
    };
}

