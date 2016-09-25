tmpdir=/tmp/scriptor.newparadigmsoftware
./clicks.sh
./multi_dir.sh

echo "
Building and finalizing multi-arch click package...
"
click build $tmpdir/multi
echo "
Removing temporary files...
"
rm -r $tmpdir
