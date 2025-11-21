#!/usr/bin/env bash
set -euo pipefail

# Build script for BusyBox with rtl819x toolchain
OUTPUT="${1:-busybox-rtl819x}"

echo "Building BusyBox for MIPS big-endian..."

# Check if we're in the nix shell
if [ -z "${IN_NIX_SHELL:-}" ]; then
  echo "Error: Must be run inside 'nix develop' shell"
  exit 1
fi

# Check toolchain
if ! command -v rsdk-linux-gcc &> /dev/null; then
  echo "Error: rsdk-linux-gcc not found. Please update toolchainPath in flake.nix"
  exit 1
fi

# Setup BusyBox
if [ ! -d "busybox-1.36.1" ]; then
  echo "BusyBox source not found. Run 'nix develop' first to extract it."
  exit 1
fi

cd busybox-1.36.1

# Clean previous builds
make clean 2>/dev/null || true

# Configure
echo "Configuring BusyBox..."
make ARCH=mips CROSS_COMPILE=rsdk-linux- defconfig

# Enable static linking for embedded use
sed -i 's/# CONFIG_STATIC is not set/CONFIG_STATIC=y/' .config
sed -i 's/CONFIG_CROSS_COMPILER_PREFIX=.*/CONFIG_CROSS_COMPILER_PREFIX="rsdk-linux-"/' .config

# Build
echo "Building..."
make ARCH=mips CROSS_COMPILE=rsdk-linux- -j$(nproc)

# Verify and copy output
if [ -f "busybox" ]; then
  cp busybox "../${OUTPUT}"
  echo ""
  echo "✓ Build successful!"
  echo "Output: ${OUTPUT}"
  file "../${OUTPUT}"
else
  echo "✗ Build failed - busybox binary not found"
  exit 1
fi
