#!/bin/sh

#rsync -rtvz /usr/arm-linux-gnueabi root@192.168.0.15:/usr
scp -r /usr/arm-linux-gnueabi root@192.168.0.16:/usr

