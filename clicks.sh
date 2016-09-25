echo "
Building click packages...
"
# git clean will remove .gitignore files only, will not remove manifest or clicks
git clean -Xdf
click-buddy --dir . --framework ubuntu-sdk-15.04 --arch armhf
git clean -Xdf
click-buddy --dir . --framework ubuntu-sdk-15.04 --arch amd64
git clean -Xdf
click-buddy --dir . --framework ubuntu-sdk-15.04 --arch i386
git clean -Xdf
