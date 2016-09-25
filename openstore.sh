tmpdir=/tmp/scriptor.newparadigmsoftware
./clicks.sh
./multi_dir.sh

echo "
Building and finalizing multi-arch click package...
"
# Override confined AppArmor file with unconfined
cp -f Scriptor.apparmor.openstore $tmpdir/multi/Scriptor.apparmor
click build $tmpdir/multi
echo "
Removing temporary files...
"
rm -r $tmpdir
