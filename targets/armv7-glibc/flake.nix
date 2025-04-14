{
  description = "ARMv7/glibc cross-compilation environment using Bootlin toolchain";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: 
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      toolchain = pkgs.fetchurl {
        url = "https://toolchains.bootlin.com/downloads/releases/toolchains/armv7-eabihf/tarballs/armv7-eabihf--glibc--stable-2021.11-1.tar.bz2";
        sha256 = "sha256-vEDUNR6R/IQ0qkh0D+2l6c5TE2eGu59fPxxLLiA6IkM=";
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

          export CC=arm-buildroot-linux-gnueabihf-gcc
          export AR=arm-buildroot-linux-gnueabihf-ar
          export STRIP=arm-buildroot-linux-gnueabihf-strip

          echo "✅ ARMv7 EABIHF / glibc toolchain ready!"
          echo "🔧 Use: $CC -static -o revshell reverse_shell.c"
        '';
      };
    };
}