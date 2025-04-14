# MIPS Little Endian / uClibc Reverse Shell Environment

This is a self-contained cross-compilation environment targeting **MIPS Little Endian (EL)** systems running `uClibc`, using Bootlin's toolchain and Nix flakes.

## 🔧 Usage

```bash
cd targets/mipsel-uclibc
nix develop
./build.sh [output-name]
```

Example:

```bash
./build.sh mipsel-shell
```

Check the output:

```bash
file mipsel-shell
```

You should see something like:

```
ELF 32-bit LSB executable, MIPS, statically linked
```