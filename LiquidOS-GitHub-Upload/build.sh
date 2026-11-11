#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

if [[ "$(uname -m)" != "x86_64" ]]; then
  echo "LiquidOS currently builds for x86_64/amd64 only." >&2
  exit 1
fi
if [[ $EUID -ne 0 ]]; then
  echo "Run this script with sudo: sudo ./build.sh" >&2
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y --no-install-recommends \
  live-build debootstrap xorriso squashfs-tools \
  ca-certificates curl git

# Recreate only generated live-build state. Keep config/ and local/ customizations.
rm -rf .build output
mkdir -p .build output
cd .build

lb config \
  --distribution trixie \
  --architectures amd64 \
  --binary-images iso-hybrid \
  --debian-installer live \
  --archive-areas "main contrib non-free-firmware" \
  --apt-recommends false \
  --apt-options "--yes -oAcquire::Retries=3" \
  --bootappend-live "boot=live components username=liquid hostname=liquidos locales=en_US.UTF-8 keyboard-layouts=us" \
  --iso-application "LiquidOS" \
  --iso-volume "LIQUIDOS" \
  --iso-publisher "LiquidOS Community Build" \
  --iso-preparer "LiquidOS ISO Builder"

# Copy the project overlay and package lists into the live-build config.
cp -a "$ROOT/config/." config/
cp -a "$ROOT/package-lists/." config/package-lists/
cp -a "$ROOT/hooks/." config/hooks/
cp -a "$ROOT/includes.chroot/." config/includes.chroot/
mkdir -p config/includes.chroot/tmp
cp "$ROOT/wallpaper.png" config/includes.chroot/tmp/liquidos-wallpaper.png

lb build

ISO="$(find . -maxdepth 1 -type f -name '*.iso' -print -quit)"
if [[ -z "$ISO" ]]; then
  echo "Build completed but no ISO was found." >&2
  exit 1
fi
cp "$ISO" "$ROOT/output/LiquidOS-amd64.iso"
sha256sum "$ROOT/output/LiquidOS-amd64.iso" > "$ROOT/output/SHA256SUMS.txt"
echo
echo "LiquidOS ISO created:"
echo "  $ROOT/output/LiquidOS-amd64.iso"
echo "Checksum:"
cat "$ROOT/output/SHA256SUMS.txt"
