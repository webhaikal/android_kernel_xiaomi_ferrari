#!/bin/bash
KERNEL_DIR=$PWD
KERN_IMG=$KERNEL_DIR/arch/arm64/boot/Image
DTBTOOL=$KERNEL_DIR/tools/dtbToolCM
version = "3.0"
TC = "uber"

export USE_CCACHE=1
export ARCH=arm64
export SUBARCH=arm64
export KBUILD_BUILD_USER="Haikal Izzuddin"
export KBUILD_BUILD_HOST="haikalizz"
STRIP="/home/heywhite69/sensei/uber4.9/bin/aarch64-linux-android-strip"
BUILD_DIR=$KERNEL_DIR/../output
MODULES_DIR="${KERNEL_DIR}/../output/modules"

export CROSS_COMPILE="/home/heywhite69/sensei/uber4.9/bin/aarch64-linux-android-"
make ferrari_debug_defconfig
make -j5 CONFIG_NO_ERROR_ON_MISMATCH=y

if ! [ -s $KERN_IMG ];
	then
		echo -e "$red Kernel Compilation failed! Fix the errors! $nocol"
		exit 1
fi
$DTBTOOL -2 -o $KERNEL_DIR/arch/arm64/boot/dt.img -s 2048 -p $KERNEL_DIR/scripts/dtc/ $KERNEL_DIR/arch/arm/boot/dts/

rm $BUILD_DIR/Image
rm $BUILD_DIR/dt.img
cp -vr $KERNEL_DIR/arch/arm64/boot/Image $BUILD_DIR/tools/Image
cp $KERNEL_DIR/arch/arm64/boot/dt.img $BUILD_DIR/tools/dt.img
cd $BUILD_DIR
zipfile="SenseiMi4i-$version+$TC-$(date +"%Y-%m-%d(%I.%M%p)").zip"
echo $zipfile
zip -r9 $zipfile * -x README

outdir=(/usr/share/nginx/html/SenseiKernel/SenseiMi4i*)
if [ ${#outdir[@]} -gt 2 ]; then
sudo ls -t | sed -e '1,3d' | xargs -d '\n' sudo rm
fi

sudo mv $BUILD_DIR/$zipfile /usr/share/nginx/html/SenseiKernel

