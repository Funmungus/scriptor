./clicks.sh
./multi_dir.sh

echo "
Building and finalizing multi-arch click package...
"
# Override confined AppArmor file with unconfined
cp -f Scriptor.apparmor.openstore multi/Scriptor.apparmor
click build multi
