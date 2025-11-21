{
  description = "RTL819x MIPS Big-Endian Toolchain with BusyBox";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        # Use 32-bit packages for the old toolchain binaries
        pkgs32 = pkgs.pkgsi686Linux;

        # Path to your toolchain - update this to match your actual location
        toolchainPath = "/home/ansible/GPL Code_RTL/rtl819x-sdk-v2.5/rtl819x/toolchain/rsdk-1.3.6-4181-EB-2.6.30-0.9.30";

        # BusyBox source
        busyboxSrc = pkgs.fetchurl {
          url = "https://busybox.net/downloads/busybox-1.36.1.tar.bz2";
          sha256 = "sha256-uMwkyVdNgD75URFo13ugePLiM7VvvjuseAVCMiXwvvY=";
        };

      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Build essentials
            gnumake
            ncurses
            pkg-config

            # 32-bit library support for old toolchain
            pkgs32.stdenv.cc.cc.lib
            pkgs32.zlib
            pkgs32.ncurses

            # Utilities
            file
            binutils
            patchelf
          ];

          shellHook = ''
            echo "========================================"
            echo "RTL819x MIPS Toolchain Environment"
            echo "========================================"

            # Add toolchain to PATH
            export PATH="${toolchainPath}/bin:$PATH"

            # Setup BusyBox if not already present
            if [ ! -d "$PWD/busybox-1.36.1" ]; then
              echo "Extracting BusyBox..."
              tar xf ${busyboxSrc}
            fi

            # Verify toolchain is accessible
            if command -v rsdk-linux-gcc &> /dev/null; then
              echo "✓ Toolchain found: $(which rsdk-linux-gcc)"
              echo "✓ GCC version: $(rsdk-linux-gcc --version 2>&1 | head -n1 || echo 'Version check failed')"
            else
              echo "✗ WARNING: rsdk-linux-gcc not found in PATH"
              echo "  Please update 'toolchainPath' in flake.nix to point to your toolchain"
            fi

            echo ""
            echo "Quick Start:"
            echo "  cd busybox-1.36.1"
            echo "  make ARCH=mips CROSS_COMPILE=rsdk-linux- defconfig"
            echo "  make ARCH=mips CROSS_COMPILE=rsdk-linux- menuconfig"
            echo "  make ARCH=mips CROSS_COMPILE=rsdk-linux-"
            echo ""
            echo "To customize BusyBox:"
            echo "  In menuconfig, set: Settings -> Build Options"
            echo "    Cross Compiler prefix: rsdk-linux-"
            echo "========================================"
          '';

          # 32-bit library path for old binaries
          LD_LIBRARY_PATH = "${pkgs32.stdenv.cc.cc.lib}/lib:${pkgs32.zlib}/lib:${pkgs32.ncurses}/lib";
        };

        # Optional: Package for building BusyBox directly
        packages.busybox = pkgs.stdenv.mkDerivation {
          name = "busybox-rtl819x";
          src = busyboxSrc;

          nativeBuildInputs = [ pkgs.gnumake pkgs.ncurses ];

          configurePhase = ''
            export PATH="${toolchainPath}/bin:$PATH"
            export LD_LIBRARY_PATH="${pkgs32.stdenv.cc.cc.lib}/lib:${pkgs32.zlib}/lib"

            # Use defconfig as base
            make ARCH=mips CROSS_COMPILE=rsdk-linux- defconfig

            # Set static build
            sed -i 's/# CONFIG_STATIC is not set/CONFIG_STATIC=y/' .config
            sed -i 's/CONFIG_CROSS_COMPILER_PREFIX=.*/CONFIG_CROSS_COMPILER_PREFIX="rsdk-linux-"/' .config
          '';

          buildPhase = ''
            make ARCH=mips CROSS_COMPILE=rsdk-linux- -j$NIX_BUILD_CORES
          '';

          installPhase = ''
            mkdir -p $out/bin
            cp busybox $out/bin/
            file $out/bin/busybox
          '';
        };
      }
    );
}
