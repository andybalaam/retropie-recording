#!/bin/bash

set -e
set -u
set -x

echo "Installing FFmpeg Suite"
echo "-----------------------"
echo

echo "=== Updating APT repo ==="
sudo apt-get update
sudo apt-get upgrade -y

echo "=== Making dirs ==="
mkdir -p ~/ffmpeg_sources
mkdir -p ~/ffmpeg_build

echo "=== Installing build tools and codecs ==="
sudo apt-get -y install autoconf automake build-essential libass-dev libfreetype6-dev \
  libsdl1.2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev \
  libxcb-xfixes0-dev pkg-config texinfo zlib1g-dev yasm libmp3lame-dev libopus-dev libatomic-ops-dev

echo "=== Compiling codecs from source ==="

echo "--- X264 Codec"
cd ~/ffmpeg_sources
git clone https://code.videolan.org/videolan/x264.git
cd x264
./configure --prefix=/usr --host=arm-unknown-linux-gnueabi --enable-shared --disable-opencl
make -j2
sudo make install
make clean
make distclean

echo "--- Libfdk-aac Codec"
cd ~/ffmpeg_sources
wget -O fdk-aac.tar.gz https://github.com/mstorsjo/fdk-aac/tarball/master
tar xzvf fdk-aac.tar.gz
cd mstorsjo-fdk-aac*
autoreconf -fiv
./configure --prefix=/usr --enable-shared
make -j2
sudo make install
make clean
make distclean

echo "--- Libvpx Codec"
cd ~/ffmpeg_sources
wget http://storage.googleapis.com/downloads.webmproject.org/releases/webm/libvpx-1.5.0.tar.bz2
tar xjvf libvpx-1.5.0.tar.bz2
cd libvpx-1.5.0
PATH="$HOME/bin:$PATH" ./configure --prefix=/usr --enable-shared --disable-examples --disable-unit-tests
PATH="$HOME/bin:$PATH" make -j2
sudo make install
make clean
make distclean

echo "=== Compiling FFmpeg ==="
cd ~/ffmpeg_sources
wget http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
tar xjvf ffmpeg-snapshot.tar.bz2
cd ffmpeg

PATH="$HOME/bin:$PATH" ./configure \
  --prefix=/usr \
  --pkg-config-flags="--static" \
  --extra-cflags="-fPIC -I$HOME/ffmpeg_build/include" \
  --extra-ldflags="-L$HOME/ffmpeg_build/lib" \
  --enable-gpl \
  --enable-libass \
  --enable-libfdk-aac \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libtheora \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-libx264 \
  --enable-nonfree \
  --enable-pic \
  --extra-ldexeflags=-pie \
  --extra-ldflags="-latomic" \
  --enable-shared

PATH="$HOME/bin:$PATH" make -j2
sudo make install
make distclean
hash -r

echo "=== Updating Shared Library Cache ==="
sudo ldconfig

echo
echo "FFmpeg and Codec Installation Complete"
echo "--------------------------------------"

