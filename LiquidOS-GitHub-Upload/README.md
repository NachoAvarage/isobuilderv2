# LiquidOS ISO Builder

LiquidOS is a clean, macOS-inspired Debian live desktop for VirtualBox. It uses KDE Plasma, subtle compositor blur, a restrained dark palette, a custom graphite wallpaper, and a macOS-like pointer theme. It is an independent Linux system, not Apple macOS.

## Build target

- Debian 13 (Trixie), amd64 / x86-64
- KDE Plasma desktop
- Bootable hybrid live ISO
- VirtualBox target: 4–6 GB RAM, 2 CPU cores, 40 GB virtual disk, 128 MB video memory

## Build

Run inside a Debian/Ubuntu/Kali x86-64 build machine, **not** inside the VM you intend to install LiquidOS into:

```bash
unzip LiquidOS-ISO-Builder.zip
cd LiquidOS-ISO-Builder
chmod +x build.sh
sudo ./build.sh
```

The script installs live-build dependencies, downloads Debian packages, and builds the ISO. Allow 20–30 GB free disk space and a reliable internet connection. The first build can take a while.

The resulting ISO is written to `output/LiquidOS-amd64.iso`.

## Boot in VirtualBox

1. Create a VM named `LiquidOS` with type Linux / Debian (64-bit).
2. Assign 4–6 GB RAM and 2 CPU cores.
3. Create a 40 GB dynamically allocated virtual disk.
4. Set Display → Video Memory to 128 MB. Try 3D Acceleration if supported by your host; turn it off if rendering glitches occur.
5. Attach `output/LiquidOS-amd64.iso` to the virtual optical drive and boot.

This build is a live system. It is not yet a fully tested installed-system installer, and live-session changes are lost at shutdown.

## Design notes

- Minimal dark graphite wallpaper, not a game-like or pixel-art look
- Breeze Dark system palette and consistent icon styling
- Subtle KWin blur/translucency and smooth compositing
- Capitaine pointer theme when packaged, with Breeze fallback
- Native KDE applications, networking, audio and VirtualBox guest integration

Glass effects depend on VirtualBox's graphics support. Disable 3D acceleration or reduce effects if the VM is sluggish.

## Build the ISO on GitHub (no Linux installation on your PC)

1. Create a new **public or private** GitHub repository.
2. Upload the contents of this project ZIP to the repository root (the `.github` folder must be included).
3. Open the repository's **Actions** tab and enable Actions if GitHub asks.
4. Select **Build LiquidOS ISO** → **Run workflow** → **Run workflow**.
5. Open the finished run and download the `LiquidOS-amd64-ISO` artifact.
6. Extract the downloaded artifact ZIP; it contains `LiquidOS-amd64.iso` and its checksum.

The workflow runs on GitHub's hosted Ubuntu runner. You do not need to install Linux, Docker, or build tools on Windows. Builds can take a while and may fail if the hosted runner runs out of disk space or Debian package availability changes; check the Actions log if that happens.
