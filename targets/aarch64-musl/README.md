# AArch64 / musl Cross-Compilation Environment

This directory contains a self-contained Nix flake for cross-compiling to AArch64 (ARM64) with musl libc.

## Features

- Uses Bootlin's AArch64 / musl toolchain
- Produces static binaries compatible with most AArch64 systems
- Works on any architecture where Nix runs
- Completely self-contained and reproducible
- Perfect for OpenWrt and embedded Linux targets

## Usage

1. From this directory, enter the dev shell:

```
nix develop
```

2. Build the sample reverse shell:

```
./build.sh
```

3. Or build with a custom output name:

```
./build.sh custom_name
```

The compiled binary will be statically linked for AArch64 with musl.

## Manual Compilation

After entering the dev shell, you can also manually compile:

```
aarch64-buildroot-linux-musl-gcc -static -o revshell reverse_shell.c
```

## Testing

You can verify the binary with:

```
file revshell
```

Which should show something like:
```
revshell: ELF 64-bit LSB executable, ARM aarch64, version 1 (SYSV), statically linked, ...
```
