# nix-cc — Universal Cross Compilation with Nix

**nix-cc** is a flake-based collection of reproducible, self-contained cross-compilation environments powered by [Nix flakes](https://nixos.wiki/wiki/Flakes).

Each architecture or libc variant lives in its own isolated directory under `targets/`, and provides:
- A `nix develop` shell with the toolchain ready to go
- A `build.sh` to compile simple test payloads
- A `README.md` with info and usage examples

## 📦 Targets

- [✔️ mips-uclibc](./targets/mips-uclibc)

## 🚀 How to Use

```bash
cd targets/mips-uclibc
nix develop
./build.sh
```

## 🛠️ How to Contribute
Just drop a new folder under targets/ with its own flake.nix, build script, and optionally test code.

```bash
targets/your-arch/
├── flake.nix
├── build.sh
├── README.md
└── <your payload>
```