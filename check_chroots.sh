#!/bin/bash
errFound=0
click chroot -a armhf -f ubuntu-sdk-15.04 exists
if [ $? -ne 0 ];then
  echo 'The armhf chroot does not exist'
  errFound=1
fi
click chroot -a amd64 -f ubuntu-sdk-15.04 exists
if [ $? -ne 0 ];then
  echo 'The amd64 chroot does not exist'
  errFound=1
fi
click chroot -a i386 -f ubuntu-sdk-15.04 exists
if [ $? -ne 0 ];then
  echo 'The i386 chroot does not exist'
  errFound=1
fi
if [ $errFound -eq 0 ];then
  echo 'All building chroots are created and ready to use'
fi
exit $errFound
