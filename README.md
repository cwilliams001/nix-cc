
# nix-cc — Universal Cross Compilation with Nix

**nix-cc** is a flake-based collection of reproducible, self-contained cross-compilation environments powered by [Nix flakes](https://nixos.wiki/wiki/Flakes).

Each architecture or libc variant lives in its own isolated directory under `targets/`, and provides:
- A `nix develop` shell with the toolchain ready to go
- A `build.sh` to compile simple test payloads
- A `README.md` with info and usage examples

---

## 🐧 Installing the Nix Package Manager

If you don’t already have Nix installed, you can install it on **any Linux distro or macOS** with:

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

> 🛑 Then restart your shell or reboot:
>
> ```bash
> . ~/.nix-profile/etc/profile.d/nix.sh
> ```

Next, **enable flakes** by editing `~/.config/nix/nix.conf`:

```ini
experimental-features = nix-command flakes
```

> 💡 If the directory doesn’t exist, create it with:
> ```bash
> mkdir -p ~/.config/nix
> ```

---

## 📦 Targets

- [✔️ mipsel-uclibc](./targets/mipsel-uclibc)
- [✔️ mips-uclibc (Big Endian)](./targets/mips-uclibc)
- [✔️ armv7-glibc](./targets/armv7-glibc)
- [✔️ aarch64-musl](./targets/aarch64-musl)
- [✔️ rtl819x-busybox (MIPS Big Endian - BusyBox)](./targets/rtl819x-busybox)

More targets (ARM, RISC-V, etc.) coming soon!

---

## 🚀 How to Use

```bash
cd targets/mipsel-uclibc         # or any other target
nix develop                    # drops you into a shell with toolchain ready
./build.sh [optional-output]   # compiles reverse_shell.c
```

Example:

```bash
./build.sh my-mipsel-payload
```

Output:
```bash
ELF 32-bit LSB executable, MIPS, statically linked
```

---

## 🛠️ How to Contribute

Want to add your own toolchain or architecture?

Just drop a new folder under `targets/`:

```bash
targets/your-arch/
├── flake.nix       # Defines the devShell with toolchain setup
├── build.sh        # Script to compile your test binary
├── reverse_shell.c # (Optional) Sample payload
└── README.md       # Docs for usage
```

Feel free to copy/paste from existing targets to get started quickly.

---

## 🧠 Why This Matters

This repo is designed for teams working with:
- Embedded systems and custom firmware
- Red team C2 payload testing
- IoT binary compatibility
- Education and teaching reverse engineering

No Docker. No broken toolchain installs. No guesswork.

---

## 📜 License

MIT — use it, fork it, remix it.
