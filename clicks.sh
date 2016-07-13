echo "
Building click packages...
"
click-buddy --dir . --framework ubuntu-sdk-15.04 --arch armhf
rm $(find . -name CMakeCache.txt) $(find . -name Makefile)
rm -r CMakeFiles/
click-buddy --dir . --framework ubuntu-sdk-15.04 --arch amd64
rm $(find . -name CMakeCache.txt) $(find . -name Makefile)
rm -r CMakeFiles/
click-buddy --dir . --framework ubuntu-sdk-15.04 --arch i386
rm $(find . -name CMakeCache.txt) $(find . -name Makefile)
rm -r CMakeFiles/
