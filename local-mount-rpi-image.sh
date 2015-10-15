#!/bin/bash
#Copyright 2014-2015 Ionut Neicu, all rights reserved.
#This script is provided as it is, without any warranty. Use on own risk.
#This script can be used freely for cros compile on Raspberry PI. 

NCPU=`cat /proc/cpuinfo |grep vendor_id |wc -l`


#The RASPBERRY PI mount options. Modify this accordingly.
export RASPB_SYSROOT="/home/ionut/work/rspb/player-project/rpi-snapshot"

# Additional folders required for linker. Inside RPI, there are some .so files pointing to /lib/arm-linux-gnueabihf and /usr/lib/arm-linux-gnueabihf on target.
# You must have them on host as well. Some people reccomend editing .so file inside rasp and removing paths there. This should not be required with this alternate approach


function check_if_want_to_continue()
{
    echo "Do you want to continue?(y/n)"
    read input
    if [ "$input" == "y" ]
        then
            echo "continue..."
        else
            exit -1

    fi
}

function mount_rpi_image_to_local()
{
#   First, check if there is a symlink on this folder.
#   The mount  be created by scripts using RPI's remote fs

    echo "checking if RASPBERRY's $1 is mounted on $1"
    if grep -qs $1 /proc/mounts; then
        check_if_want_to_continue
        echo "WARNING: $1 is mounted, it must be unmount"
        sudo umount $1
    fi
#   Check also for existing folder. If folder exists, it will prevent symlink creation
#   so we have to delete it
    if [  -d $1 ]; then
         echo "WARNING: $1 folder exists, it must be deleted"
         check_if_want_to_continue
         sudo rm -rf $1
    fi
#  TODO:  Check if there is a symlink on that folder
    if [  -L $1 ]; then
         echo "WARNING: $1 symlink exists, it must be deleted"
         check_if_want_to_continue
         sudo rm -rf $1
    fi
    
#   Create symlink
sudo mkdir -p $1
sudo ln -s ${RASPB_SYSROOT}/$1 $1

}


mount_rpi_image_to_local "/usr/lib/arm-linux-gnueabi"
mount_rpi_image_to_local "/lib/arm-linux-gnueabi-hf"
mount_rpi_image_to_local "/usr/lib/arm-linux-gnueabihf"
mount_rpi_image_to_local "/opt/vc/include/IL"





