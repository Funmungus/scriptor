#!/bin/bash
sudo click chroot -a armhf -f ubuntu-sdk-15.04 update
sudo click chroot -a amd64 -f ubuntu-sdk-15.04 update
sudo click chroot -a i386 -f ubuntu-sdk-15.04 update
