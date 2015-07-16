#!/bin/bash


NCPU=`cat /proc/cpuinfo |grep vendor_id |wc -l`


#The RASPBERRY PI mount options. Modify this accordingly.


export RASPB_SYSROOT="/home/ionut/work/rspb/player-project/rpi-snapshot"



# Additional folders required for linker. Inside RPI, there are some .so files pointing to /lib/arm-linux-gnueabihf and /usr/lib/arm-linux-gnueabihf on target.
# You must have them on host as well. Some people reccomend editing .so file inside rasp and removing paths there. This should not be required with this alternate approach.




echo "checking if RASPBERRY's /lib/arm-linux-gnueabihf is mounted on /lib/arm-linux-gnueabihf ( required to link against some target .so files ) ... "

if grep -qs "/lib/arm-linux-gnueabihf" /proc/mounts; then
        echo "/lib/arm-linux-gnueabihf is mounted, unmounting"
        sudo umount /lib/arm-linux-gnueabihf
fi


echo "checking if RASPBERRY's /usr/lib/arm-linux-gnueabihf is mounted on /usr/lib/arm-linux-gnueabihf ( required to link against some target .so files ) ... "

if grep -qs "/usr/lib/arm-linux-gnueabihf" /proc/mounts; then
         echo "/usr/lib/arm-linux-gnueabihf is mounted, skipping"
         sudo umount /usr/lib/arm-linux-gnueabihf
fi


if [  -d "/lib/arm-linux-gnueabihf" ]; then
       sudo rm -rf /lib/arm-linux-gnueabihf
fi

if [ -d "/usr/lib/arm-linux-gnueabihf" ]; then
       sudo rm -rf /usr/lib/arm-linux-gnueabihf
fi

sudo ln -s ${RASPB_SYSROOT}/usr/lib/arm-linux-gnueabihf /usr/lib/arm-linux-gnueabihf
sudo ln -s ${RASPB_SYSROOT}/lib/arm-linux-gnueabihf /lib/arm-linux-gnueabihf

#the folder where you
export CROSS_PATH="/home/ionut/work/rspb/cross-compile/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin"


export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-
export CC=$CROSS_PATH/arm-linux-gnueabihf-gcc
export NM=$CROSS_PATH/arm-linux-gnueabihf-nm
export LD=$CROSS_PATH/arm-linux-gnueabihf-ld
export CXX=$CROSS_PATH/arm-linux-gnueabihf-g++
export RANLIB=$CROSS_PATH/arm-linux-gnueabihf-ranlib
export AR=$CROSS_PATH/arm-linux-gnueabihf-ar
export CPP=$CROSS_PATH/arm-linux-gnueabihf-cpp
export PKG_PROG_PKG_CONFIG=$CROSS_PATH/arm-linux-gnueabihf-pkg-config 
export LIBRARY_PATH=${LIBRARY_PATH}:${RASPB_SYSROOT}/usr/lib/arm-linux-gnueabihf:${RASPB_SYSROOT}/opt/vc/lib


#it looks like the ARM compiler has some issues. add rpath to the .so folders and their dependencies"
export AM_LDFLAGS="-Wl,-rpath-link -Wl,${RASPB_SYSROOT}/lib/arm-linux-gnueabihf -Wl,-rpath-link -Wl,${RASPB_SYSROOT}/usr/lib/arm-linux-gnueabihf -L${RASPB_SYSROOT}/opt/vc/lib"
export AM_CPPFLAGS_OMX="-I${RASPB_SYSROOT}/opt/vc/include/IL"


#pkgconfig paths must contain all .pc files required to determine include and lib files for dependency packages.
#the dependency packages must be installed on RPI with something like $ apt-get install [somepackage]-dev

export PKG_CONFIG_SYSROOT_DIR=${RASPB_SYSROOT}
PKG_CONFIG_PATH=${RASPB_SYSROOT}/usr/arm-linux-gnueabi/usr/local/lib/pkgconfig
PKG_CONFIG_PATH=${PKG_CONFIG_PATH}:${RASPB_SYSROOT}/usr/lib/arm-linux-gnueabihf/pkgconfig/
PKG_CONFIG_PATH=${PKG_CONFIG_PATH}:${RASPB_SYSROOT}/usr/local/lib/pkgconfig
PKG_CONFIG_PATH=${PKG_CONFIG_PATH}:${RASPB_SYSROOT}/usr/local/share/pkgconfig
PKG_CONFIG_PATH=${PKG_CONFIG_PATH}:${RASPB_SYSROOT}/usr/lib/pkgconfig
PKG_CONFIG_PATH=${PKG_CONFIG_PATH}:${RASPB_SYSROOT}/usr/share/pkgconfig
PKG_CONFIG_PATH=${PKG_CONFIG_PATH}:${RASPB_SYSROOT}/usr/local/lib/pkgconfig
export PKG_CONFIG_PATH


#would pass system include to the cross compiler. we want to use mounted RPI's /urs/include and maybe others
#this could be also subhect of change if extra system includes required.
#the other include will be determined by pkg-config utility directly on target

echo "RaspSysroot="$RASPB_SYSROOT
export AM_CPPFLAGS="-I${RASPB_SYSROOT}/usr/include -I${RASPB_SYSROOT}/opt/vc/include/ -I${RASPB_SYSROOT}/opt/vc/include/interface/vcos/pthreads -I${RASPB_SYSROOT}/opt/vc/include/interface/vmcs_host/linux ${AM_CPPFLAGS_OMX} -DDEBUG -g -O0"

export AM_CXXFLAGS="-g -O0"
export AM_CFLAGS="-g -O0"

echo "**********************************"
echo "* RPI devenv successfully set up *"
echo "* now use:                       *"
echo "*  autoreconf -f -i              *"
echo "*  configure [params]            *"
echo "*  make -j${NCPU}                *"
echo "**********************************"



