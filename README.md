# Cross compile rust to a Raspberrypi

This is a demo of a cross-compiled rust app on a Raspberry pi.

The Rust embedded team has created a tool to help cross-compile rust: [cross](https://github.com/cross-rs/cross). It uses pre-built Docker images, containing the all the needed dependencies for each available targets.

## Getting started

Install `cross`:

```bash
cargo install cross
```

`cross` has the same CLI as `cargo` (has the same commands, e.g. `run`, `build`, etc...).

Building this project for a Raspberrypi 3:

```bash
cross build --release --target=aarch64-unknown-linux-gnu
```

To get the list of cross-compilation targets available, run:

```bash
$ rustup target list

aarch64-apple-darwin
aarch64-apple-ios
aarch64-apple-ios-sim
aarch64-linux-android
aarch64-pc-windows-msvc
aarch64-unknown-fuchsia
aarch64-unknown-linux-gnu
aarch64-unknown-linux-musl
aarch64-unknown-none
aarch64-unknown-none-softfloat
aarch64-unknown-uefi
arm-linux-androideabi
arm-unknown-linux-gnueabi
arm-unknown-linux-gnueabihf
arm-unknown-linux-musleabi
arm-unknown-linux-musleabihf
armebv7r-none-eabi
armebv7r-none-eabihf
armv5te-unknown-linux-gnueabi
armv5te-unknown-linux-musleabi
armv7-linux-androideabi
armv7-unknown-linux-gnueabi
armv7-unknown-linux-gnueabihf
armv7-unknown-linux-musleabi
armv7-unknown-linux-musleabihf
armv7a-none-eabi
armv7r-none-eabi
armv7r-none-eabihf
asmjs-unknown-emscripten
i586-pc-windows-msvc
i586-unknown-linux-gnu
i586-unknown-linux-musl
i686-linux-android
i686-pc-windows-gnu
i686-pc-windows-msvc
i686-unknown-freebsd
i686-unknown-linux-gnu
i686-unknown-linux-musl
i686-unknown-uefi
loongarch64-unknown-linux-gnu
loongarch64-unknown-none
loongarch64-unknown-none-softfloat
mips-unknown-linux-musl
mips64-unknown-linux-muslabi64
mips64el-unknown-linux-muslabi64
mipsel-unknown-linux-musl
nvptx64-nvidia-cuda
powerpc-unknown-linux-gnu
powerpc64-unknown-linux-gnu
powerpc64le-unknown-linux-gnu
riscv32i-unknown-none-elf
riscv32imac-unknown-none-elf
riscv32imc-unknown-none-elf
riscv64gc-unknown-linux-gnu
riscv64gc-unknown-none-elf
riscv64imac-unknown-none-elf
s390x-unknown-linux-gnu
sparc64-unknown-linux-gnu
sparcv9-sun-solaris
thumbv6m-none-eabi
thumbv7em-none-eabi
thumbv7em-none-eabihf
thumbv7m-none-eabi
thumbv7neon-linux-androideabi
thumbv7neon-unknown-linux-gnueabihf
thumbv8m.base-none-eabi
thumbv8m.main-none-eabi
thumbv8m.main-none-eabihf
wasm32-unknown-emscripten
wasm32-unknown-unknown
wasm32-wasi
wasm32-wasi-preview1-threads
x86_64-apple-darwin
x86_64-apple-ios
x86_64-fortanix-unknown-sgx
x86_64-linux-android
x86_64-pc-solaris
x86_64-pc-windows-gnu
x86_64-pc-windows-msvc
x86_64-sun-solaris
x86_64-unknown-freebsd
x86_64-unknown-fuchsia
x86_64-unknown-illumos
x86_64-unknown-linux-gnu (installed)
x86_64-unknown-linux-gnux32
x86_64-unknown-linux-musl
x86_64-unknown-netbsd
x86_64-unknown-none
x86_64-unknown-redox
x86_64-unknown-uefi
```

The Raspberrypi 3 and 4 should use the `aarch64` targets. To get the arch of the pi:

```bash
$ uname -a
Linux raspberrypi 6.1.0-rpi7-rpi-v8 #1 SMP PREEMPT Debian 1:6.1.63-1+rpt1 (2023-11-24) aarch64 GNU/Linux
``` 

The target `aarch64-unknown-linux-gnu` will be dynamically linked:

```bash
$ file cross-compile-rpi 
cross-compile-rpi: ELF 64-bit LSB pie executable, ARM aarch64, version 1 (SYSV), dynamically linked, interpreter /lib/ld-linux-aarch64.so.1, for GNU/Linux 3.7.0, BuildID[sha1]=24891363561da8f6126642705b8d10886ba2ca03, with debug_info, not stripped

$ ls -lah cross-compile-rpi 
-rwxr-xr-x 1 pi pi 4.7M May 31 11:39 cross-compile-rpi
```

And the `aarch64-unknown-linux-musl` statically linked:

```bash
$ file cross-compile-rpi 
cross-compile-rpi: ELF 64-bit LSB executable, ARM aarch64, version 1 (SYSV), statically linked, with debug_info, not stripped

$ ls -lh cross-compile-rpi 
-rwxr-xr-x 1 pi pi 4.9M May 31 11:38 cross-compile-rpi
```

## Streamlining the development

To accelerate the development, a `Justfile` (from [just](https://github.com/casey/just) tool, see this [cheatsheet](https://cheatography.com/linux-china/cheat-sheets/justfile/) to get started) has been made:

```bash
# list the recipes with:
Available recipes:
    build PROFILE="dev" # Build and push the binary for the target
    default             # List all available recipes

# build the code, and push it to the Raspberrypi
just build


# build the code with the `release` profile (see the default profiles here: https://doc.rust-lang.org/cargo/reference/profiles.html#default-profiles), and push it
just build release
```
