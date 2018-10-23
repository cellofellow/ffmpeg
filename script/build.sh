#!/bin/bash
set -xe

# Fetch Sources

mkdir -p /usr/local/src
cd /usr/local/src

git clone --depth 1 https://github.com/l-smash/l-smash
git clone --depth 1 git://git.videolan.org/x264.git
hg clone https://bitbucket.org/multicoreware/x265
git clone --depth 1 git://github.com/mstorsjo/fdk-aac.git
git clone --depth 1 https://chromium.googlesource.com/webm/libvpx
git clone --depth 1 git://source.ffmpeg.org/ffmpeg
git clone https://git.xiph.org/opus.git
git clone --depth 1 https://gitlab.com/mulx/aacgain.git


wget http://www.nasm.us/pub/nasm/releasebuilds/2.13.01/nasm-2.13.01.tar.xz
tar -xvf nasm-2.13.01.tar.xz
cd nasm-2.13.01
./configure
make
make install


# Build L-SMASH

cd /usr/local/src/l-smash
./configure
make -j $(nproc)
make install

# Build libx264

cd /usr/local/src/x264
./configure --enable-static --enable-pic --enable-shared
make -j $(nproc)
make install

# Build libx265

cd /usr/local/src/x265/build/linux
cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr ../../source
make -j $(nproc)
make install

# Build libfdk-aac

cd /usr/local/src/fdk-aac
autoreconf -fiv
./configure --disable-shared
make -j $(nproc)
make install

# Build libvpx

cd /usr/local/src/libvpx
./configure --disable-examples
make -j $(nproc)
make install

# Build libopus

cd /usr/local/src/opus
./autogen.sh
./configure --disable-shared
make -j $(nproc)
make install

# Build ffmpeg.

cd /usr/local/src/ffmpeg
./configure --extra-libs="-ldl" --enable-gpl --enable-libass --enable-libfdk-aac --enable-libmp3lame --enable-libopus --enable-libtheora --enable-libvorbis --enable-libvpx --enable-libx264 --enable-libx265 --enable-nonfree --pkg-config-flags="--static"
make -j $(nproc)
make install

# Build aacgain

cd /usr/local/src/aacgain/mp4v2
./configure && make -k -j $(nproc) || true # some commands fail but build succeeds
cd /usr/local/src/aacgain/faad2
./configure && make -k -j $(nproc) || true # some commands fail but build succeeds
cd /usr/local/src/aacgain
./configure && make -j $(nproc) && make install

# Remove all tmpfile

rm -rf /usr/local/src
