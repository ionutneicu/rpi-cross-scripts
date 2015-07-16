#/bin/sh

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
