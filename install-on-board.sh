#!/bin/sh

#rsync --update -raz --progress --ignore-times --checksum  /usr/arm-linux-gnueabi/* root@192.168.0.16:/usr/arm-linux-gnueabi
scp -r /usr/arm-linux-gnueabi root@192.168.0.16:/usr

