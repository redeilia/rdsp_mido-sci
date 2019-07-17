#!/bin/bash
#
# Copyright © 2018-2019, "penglezos" <panagiotisegl@gmail.com>
# Thanks to Vipul Jha for zip creator
# Android Kernel Compilation Script
#

tput reset
echo -e "==============================================="
echo    "         Compiling Englezos Kernel             "
echo -e "==============================================="

LC_ALL=C date +%Y-%m-%d
date=`date +"%Y%m%d-%H%M"`
BUILD_START=$(date +"%s")
KERNEL_DIR=$PWD
REPACK_DIR=$KERNEL_DIR/AnyKernel3
OUT=$KERNEL_DIR/out
VERSION="v1.0"
export ARCH=arm64 && export SUBARCH=arm64
export CROSS_COMPILE="gcc64/bin/aarch64-linux-android-"
GDV=alif/gdv

#Setup GDrive ideantity
cp -r alif/.gdrive ~/.gdrive

rm -rf out
mkdir -p out
make O=out clean
make O=out mrproper
make O=out mido_defconfig
make O=out -j$(nproc --all)

cd $REPACK_DIR
cp $KERNEL_DIR/out/arch/arm64/boot/Image.gz-dtb $REPACK_DIR/
FINAL_ZIP="RedeiliaSpace-kernel-${VERSION}.zip"
zip -r9 "${FINAL_ZIP}" *
cp *.zip $OUT
rm *.zip
cd $KERNEL_DIR
rm AnyKernel3/Image.gz-dtb

BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo "Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."

# Upload to Google Drive
echo "Uploading..."
$GDV upload out/$FINAL_ZIP
