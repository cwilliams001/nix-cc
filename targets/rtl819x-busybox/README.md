# RTL819x MIPS Toolchain - BusyBox Build Environment

A reproducible Nix flake for cross-compiling BusyBox using the RTL819x MIPS big-endian toolchain.

## Features

- ✅ Isolated build environment with all dependencies
- ✅ 32-bit library support for legacy toolchain binaries
- ✅ Automatic BusyBox source download and extraction
- ✅ No Docker, no system contamination
- ✅ Works on any Linux system with Nix installed

## Prerequisites

1. **Nix with flakes enabled** (see main [README](../../README.md) for installation)

2. **RTL819x toolchain** - Default path configured:
   ```
   /home/ansible/GPL Code_RTL/rtl819x-sdk-v2.5/rtl819x/toolchain/rsdk-1.3.6-4181-EB-2.6.30-0.9.30
   ```

## Quick Start

```bash
# Enter the development shell
nix develop

# Build BusyBox with default config
./build.sh

# Or build with custom output name
./build.sh my-custom-busybox
```

## Manual Build (Step by Step)

```bash
# 1. Enter nix shell
nix develop

# 2. Navigate to BusyBox source (auto-extracted)
cd busybox-1.36.1

# 3. Configure BusyBox
make ARCH=mips CROSS_COMPILE=rsdk-linux- defconfig

# 4. Customize (optional)
make ARCH=mips CROSS_COMPILE=rsdk-linux- menuconfig
# In menuconfig: Settings -> Build Options
#   - Cross Compiler prefix: rsdk-linux-
#   - Enable CONFIG_STATIC for embedded use

# 5. Build
make ARCH=mips CROSS_COMPILE=rsdk-linux- -j$(nproc)

# 6. Verify
file busybox
# Should show: ELF 32-bit MSB executable, MIPS...
```

## Using a Different Toolchain Path

If your toolchain is in a different location, edit `flake.nix`:

```nix
toolchainPath = "/your/custom/path/to/toolchain";
```

Then rebuild:
```bash
nix develop --refresh
```

## Customizing BusyBox

To add/remove BusyBox applets:

```bash
cd busybox-1.36.1
make ARCH=mips CROSS_COMPILE=rsdk-linux- menuconfig

# Navigate through categories and enable/disable features
# Common customizations:
# - Networking Utilities -> Add/remove tools
# - Coreutils -> Select which Unix commands to include
# - Settings -> Build Options -> Enable static linking

make ARCH=mips CROSS_COMPILE=rsdk-linux- -j$(nproc)
```

## Building for Different BusyBox Versions

Edit `flake.nix` to change the BusyBox version:

```nix
busyboxSrc = pkgs.fetchurl {
  url = "https://busybox.net/downloads/busybox-1.35.0.tar.bz2";
  sha256 = "...";  # Get hash with: nix-prefetch-url <url>
};
```

## Troubleshooting

### "No such file or directory" for toolchain binaries

This usually means missing 32-bit libraries. The flake automatically handles this, but if you still see errors:

```bash
# Inside nix develop, check:
ldd $(which rsdk-linux-gcc)

# Should show all libraries resolved
```

### "mixed implicit and normal rules" with older BusyBox

Use BusyBox 1.36.1+ which is compatible with modern make. Version 1.13 requires GNU Make 3.81 or older.

### Build fails with "cannot find -lc"

Make sure you're using the correct cross-compiler prefix:
```bash
export CROSS_COMPILE=rsdk-linux-
# NOT mips-linux- (though that works too for this toolchain)
```

## Architecture Information

- **Target**: MIPS big-endian (Lexra/RLX core)
- **Toolchain**: rsdk-1.3.6-4181-EB-2.6.30-0.9.30
- **GCC Version**: 3.4.6-1.3.6
- **libc**: uClibc 0.9.30
- **Kernel**: Linux 2.6.30

## Use Cases

Perfect for:
- Building custom firmware for RTL819x devices
- TOTOLINK router exploitation/testing
- Embedded MIPS development
- Firmware security research

## Related Projects

- Original SDK: [frederic/rtl819x-toolchain](https://github.com/frederic/rtl819x-toolchain)
- Universal cross-compilation: [cwilliams001/nix-cc](https://github.com/cwilliams001/nix-cc)

## License

This flake configuration is provided as-is for research and development purposes.
