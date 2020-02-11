#!/bin/bash

set -ex
workdir=$PWD/build/

if [ -z $workdir/gcc_all ]; then
    mkdir $workdir/gcc_all
fi
cd $workdir/gcc_all

wget -nc https://ftpmirror.gnu.org/binutils/binutils-2.31.tar.bz2
wget -nc https://ftpmirror.gnu.org/glibc/glibc-2.28.tar.bz2
wget -nc https://ftpmirror.gnu.org/gcc/gcc-8.3.0/gcc-8.3.0.tar.gz

if [ -e $workdir/linux-src ]; then
#    cd linux
#    git clean -dfx .
#    git checkout -- .
#    cd $workdir/gcc_all
    echo Not doing anything
else
    git clone --depth=1 -b 4.19-y https://github.com/raspberrypi/linux
fi

if [ -e binutils-2.31 ]; then rm -r binutils-2.31; fi
if [ -e glibc-2.28 ]; then rm -r glibc-2.28; fi
if [ -e gcc-8.3.0 ]; then rm -r gcc-8.3.0; fi

tar xf binutils-2.31.tar.bz2
tar xf glibc-2.28.tar.bz2
tar xf gcc-8.3.0.tar.gz

cd gcc-8.3.0
contrib/download_prerequisites
rm *.tar.*
cd $workdir/gcc_all

cd $workdir/gcc_all
mkdir -p $workdir/cross-pi-zero
export PATH=$workdir/cross-pi-zero/bin:$PATH

cd $workdir/linux-src
KERNEL=kernel7
make ARCH=arm INSTALL_HDR_PATH=$workdir/cross-pi-zero/arm-linux-gnueabihf headers_install

cd $workdir/gcc_all
mkdir build-binutils && cd build-binutils
$workdir/gcc_all/binutils-2.31/configure --prefix=$workdir/cross-pi-zero --target=arm-linux-gnueabihf --with-arch=armv6 --with-fpu=vfp --with-float=hard --disable-multilib
make -j $(nproc)
make install

cd $workdir/gcc_all
mkdir build-gcc && cd build-gcc
$workdir/gcc_all/gcc-8.3.0/configure --prefix=$workdir/cross-pi-zero --target=arm-linux-gnueabihf --enable-languages=c,c++,fortran --with-arch=armv6 --with-fpu=vfp --with-float=hard --disable-multilib
make -j $(nproc) all-gcc
make install-gcc

cd $workdir/gcc_all
mkdir build-glibc
cd build-glibc
$workdir/gcc_all/glibc-2.28/configure --prefix=$workdir/cross-pi-zero/arm-linux-gnueabihf --build=$MACHTYPE --host=arm-linux-gnueabihf --target=arm-linux-gnueabihf --with-arch=armv6 --with-fpu=vfp --with-float=hard --with-headers=$workdir/cross-pi-zero/arm-linux-gnueabihf/include --disable-multilib libc_cv_forced_unwind=yes
make install-bootstrap-headers=yes install-headers
make -j $(nproc) csu/subdir_lib
install csu/crt1.o csu/crti.o csu/crtn.o $workdir/cross-pi-zero/arm-linux-gnueabihf/lib
arm-linux-gnueabihf-gcc -nostdlib -nostartfiles -shared -x c /dev/null -o $workdir/cross-pi-zero/arm-linux-gnueabihf/lib/libc.so
touch $workdir/cross-pi-zero/arm-linux-gnueabihf/include/gnu/stubs.h

cd $workdir/gcc_all
cd build-gcc
make -j $(nproc) all-target-libgcc
make install-target-libgcc

cd $workdir/gcc_all
cd build-glibc
make -j $(nproc)
make install

cd $workdir/gcc_all
cd build-gcc
make -j $(nproc)
make install
cd $workdir/gcc_all

