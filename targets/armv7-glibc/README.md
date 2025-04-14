# ARMv7 / glibc Cross-Compilation Environment

This directory contains a self-contained Nix flake for cross-compiling to ARMv7 with glibc.

## Features

- Uses Bootlin's ARMv7 EABIHF / glibc toolchain
- Produces static binaries compatible with most ARMv7 systems
- Works on any architecture where Nix runs
- Completely self-contained and reproducible

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

The compiled binary will be statically linked for ARMv7 with glibc.

## Manual Compilation

After entering the dev shell, you can also manually compile:

```
arm-buildroot-linux-gnueabihf-gcc -static -o revshell reverse_shell.c
```

## Testing

You can verify the binary with:

```
file revshell
```

Which should show something like:
```
revshell: ELF 32-bit LSB executable, ARM, EABI5 version 1 (GNU/Linux), statically linked, ...
```