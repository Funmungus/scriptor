tmpdir=/tmp/scriptor.newparadigmsoftware
localVersion="$(grep \"version\" manifest.json|sed 's/[^0-9.]//g')"
if [ "x$localVersion" = "x" ]; then
  echo "Error: Not able to find version number. manifest.json is missing or malformed" >&2
  exit 1
fi

multiclick="scriptor.newparadigmsoftware_${localVersion}_multi.click"
if [ ! -f "${multiclick}" ];then
  echo "Error: ${multiclick} file not found" >&2
  exit 1
fi
mkdir -p "${tmpdir}"

echo "
Extracting multi-arch click package...
"
dpkg -x "${multiclick}" $tmpdir/multi
# In click manifest replace specific architecture with multi architecture
sed 's/^\s*"architecture":.*/"architecture": ["armhf", "i386", "amd64"],/g' manifest.json > $tmpdir/multi/manifest.json

echo "
Replacing confined apparmor manifest and repackaging
"
# Override confined AppArmor file with unconfined
cp -f Scriptor.apparmor.openstore $tmpdir/multi/Scriptor.apparmor
# Do not validate, we know unconfined will fail the validation
click build --no-validate $tmpdir/multi
echo "
Removing temporary files...
"
rm -r $tmpdir
