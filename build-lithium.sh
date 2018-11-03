#!/bin/bash

KERNEL_DIR=$PWD
ANYKERNEL_DIR=$KERNEL_DIR/AnyKernel2
DATE=$(date +"%d%m%Y")
KERNEL_NAME="idle-pie-hmp"
DEVICE="-lithium-"
FINAL_ZIP="$KERNEL_NAME""$DEVICE""$DATE".zip

rm $ANYKERNEL_DIR/lithium/Image.gz-dtb
rm $KERNEL_DIR/arch/arm64/boot/Image.gz $KERNEL_DIR/arch/arm64/boot/Image.gz-dtb

export USE_CCACHE=1
export ARCH=arm64
export CROSS_COMPILE=~/toolchain/gcc8/bin/aarch64-linux-android-
export LD_LIBRARY_PATH=~/toolchain/gcc8/lib/
export CLANG_TRIPLE=aarch64-linux-android-
export CLANG_PATH=~/toolchain/clang/dragontc4.9/bin

make clean && make mrproper
make lithium_defconfig
make -j$( nproc --all )

cp $KERNEL_DIR/arch/arm64/boot/Image.gz-dtb $ANYKERNEL_DIR/lithium

cd $ANYKERNEL_DIR/lithium
zip -r9 $FINAL_ZIP * -x *.zip $FINAL_ZIP
