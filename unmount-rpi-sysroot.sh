#/bin/sh

#Copyright 2014-2015 Ionut Neicu, all rights reserved.
#This script is provided as it is, without any warranty. Use on own risk.
#This script can be used freely for cros compile on Raspberry PI. 
echo "unmounting RPI sysroot and related folders"

RPI_MOUNTS=`sudo mount | grep pi@ | awk '{print $3}'`

for RPI_MOUNT in ${RPI_MOUNTS}
do
  echo "unmounting ${RPI_MOUNT}"
  sudo umount ${RPI_MOUNT}
done

echo "*********************************"
echo "*    RPI unmount successful     *"
echo "*********************************"
