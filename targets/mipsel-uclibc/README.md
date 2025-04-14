### 📄 `README.md`

# 🔧 MIPS/uClibc Reverse Shell Cross-Compiler (Powered by Nix)

This project provides a **reproducible cross-compilation environment** for building a reverse shell targeting **MIPS32el (Little Endian)** systems that use `uClibc`, like embedded routers.

It's built with [Nix flakes](https://nixos.wiki/wiki/Flakes) and uses the official [Bootlin MIPS32el toolchain](https://toolchains.bootlin.com/). No manual setup, no weird toolchain installs — just `nix develop` and go.

---

## 💡 Why use this?

- ✅ No need to install a toolchain manually
- ✅ Reproducible for the whole team
- ✅ Works on any Linux machine with Nix installed
- ✅ Can easily be extended to other architectures

---

## 📦 What's included

- A `flake.nix` that fetches and unpacks the MIPS/uClibc toolchain
- A dev environment (`nix develop`) with:
  - `mipsel-buildroot-linux-uclibc-gcc`, `ar`, `strip` in `$PATH`
  - `CC`, `AR`, and `STRIP` preconfigured
- A build script (`build.sh`) for compiling your reverse shell

---

## 🚀 Quickstart

### 1. Enable flakes

If you haven't already, enable Nix flakes in your `~/.config/nix/nix.conf`:

```ini
experimental-features = nix-command flakes
```

---

### 2. Clone the repo

```bash
git clone https://github.com/your-org/reverse-shell
cd reverse-shell
```

---

### 3. Enter the dev shell

```bash
nix develop
```

This puts you in a shell where the MIPS/uClibc cross-compiler is ready to go.

---

### 4. Build the reverse shell

```bash
./build.sh
```

This will create a statically-linked MIPS binary named `revshell`.

Want to give it a custom name?

```bash
./build.sh my-mips-shell
```

---

### 5. Confirm the binary

```bash
file revshell
```

Output should look like:

```
revshell: ELF 32-bit LSB executable, MIPS, statically linked, not stripped
```

You're now ready to test/deploy it to your target system.

---

## 📂 Project Layout

```
reverse-shell/
├── flake.nix           # Nix flake defining the dev environment
├── reverse_shell.c     # The reverse shell source code
├── build.sh            # Build script for compiling
└── README.md           # You're reading it
```

---

## 🧠 Notes

- This is meant for educational or red-team use cases only.
- It currently supports MIPS32el (Little Endian) + `uClibc`.
- The toolchain is fetched directly from Bootlin and unpacked automatically by Nix.
- **You do NOT need to install the toolchain manually.**

---

## 🔜 Coming soon...

- [ ] ARMv7 (musl & glibc)
- [ ] RISC-V 64
- [ ] More Bootlin targets
- [ ] `nix run .#build -- --target mipsel --output revshell` support

---

## 🛡 License

MIT — use it, modify it, share it. Just don’t be a jerk.

---

## 🙏 Thanks

Huge shoutout to [Bootlin](https://bootlin.com/) for maintaining high-quality cross-compilation toolchains.

Built with ❤️ and frustration avoidance by your local infra wizard.

