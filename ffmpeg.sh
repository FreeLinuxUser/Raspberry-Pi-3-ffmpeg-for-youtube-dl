#!/bin/bash 	
apt-get update
apt-get upgrade -y
apt-get install wget curl -y
apt-get remove --purge libmp3lame-dev libtool libssl-dev libaacplus-* libx264 libvpx librtmp ffmpeg -y
apt-get install libmp3lame-dev autoconf libtool checkinstall libssl-dev -y
cd /home/pi/
mkdir src
cd src
wget http://tipok.org.ua/downloads/media/aacplus/libaacplus/libaacplus-2.0.2.tar.gz
tar -xzf libaacplus-2.0.2.tar.gz
cd libaacplus-2.0.2
./autogen.sh --with-parameter-expansion-string-replace-capable-shell=/bin/bash --host=arm-unknown-linux-gnueabi --enable-static
make
make install
cd /home/pi/src
git clone git://git.videolan.org/x264
cd x264
./configure --host=arm-unknown-linux-gnueabi --enable-static --disable-opencl
make
make install
cd /home/pi/src
git clone https://chromium.googlesource.com/webm/libvpx
cd libvpx
./configure
make
checkinstall --pkgname=libvpx --pkgversion="1:$(date +%Y%m%d%H%M)-git" --backup=no     --deldoc=yes --fstrans=no --default
cd /home/pi/src
git clone git://git.ffmpeg.org/rtmpdump
cd rtmpdump
make SYS=posix
checkinstall --pkgname=rtmpdump --pkgversion="2:$(date +%Y%m%d%H%M)-git" --backup=no --deldoc=yes --fstrans=no --default 	
ldconfig
cd /home/pi/src
git clone --depth 1 git://git.videolan.org/ffmpeg
cd ffmpeg
./configure --arch=armel --target-os=linux --enable-gpl --enable-libx264 --enable-nonfree  --enable-librtmp --enable-libmp3lame
make
make install

curl https://yt-dl.org/latest/youtube-dl -o /usr/local/bin/youtube-dl
chmod a+rx /usr/local/bin/youtube-dl
