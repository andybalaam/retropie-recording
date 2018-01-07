#!/bin/bash

set -e
set -u
set -x

echo "Building RetroArch with ffmpeg enabled"
echo "--------------------------------------"
echo

echo "=== Downloading patch file ==="
wget https://raw.githubusercontent.com/andybalaam/retropie-recording/master/enable-ffmpeg.patch

echo "=== Patching RetroArch code to enable ffmpeg ==="
cd RetroPie-Setup
patch -p1 < ../enable-ffmpeg.patch

echo "=== Rebuilding RetroArch ==="

sudo ./retropie_packages.sh retroarch

echo
echo "Building RetroArch with ffmpeg enabled complete"
echo "-----------------------------------------------"
