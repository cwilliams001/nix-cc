# MIPS Big Endian / uClibc Reverse Shell Environment

This is a self-contained cross-compilation environment targeting **MIPS Big Endian (BE)** systems running `uClibc`, using Bootlin's toolchain and Nix flakes.

## 🔧 Usage

```bash
cd targets/mips-uclibc
nix develop
./build.sh [output-name]
```

Example:

```bash
./build.sh mipsbe-shell
```

Check the output:

```bash
file mipsbe-shell
```

You should see something like:

```
ELF 32-bit MSB executable, MIPS, statically linked
```

