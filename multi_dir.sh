# Assuming version number is only numbers and decimals
localVersion="$(grep \"version\" manifest.json|sed 's/[^0-9.]//g')"
if [ "x$localVersion" = "x" ]; then
  echo "Error: Not able to find version number. manifest.json is missing or malformed" >&2
  echo "Error: Not able to build multi package" >&2
  exit 1
fi
tmpdir=/tmp/scriptor.newparadigmsoftware
clickbase="scriptor.newparadigmsoftware_${localVersion}_"
armclick="${clickbase}armhf.click"
i386click="${clickbase}i386.click"
amd64click="${clickbase}amd64.click"

# Check for existing built packages
if ! ([ -f "$armclick" ] && [ -f "$i386click" ] && [ -f "$amd64click" ]); then
  echo "Error: Not able to find one of the following click packages:
$armclick
$i386click
$amd64click" >&2
  echo "Error: Not able to build multi package" >&2
  exit 1
fi

echo "
Extracting click packages in temporary directory $tmpdir...
"
if [ -a $tmpdir ]; then
  rm -r $tmpdir/*
fi
mkdir -p $tmpdir
if [ $? -ne 0 ];then
  echo "Error: Unable to create temporary directory $tmpdir" >&2
  exit 1
fi
dpkg -x "$armclick" $tmpdir/armhf
dpkg -x "$i386click" $tmpdir/i386
dpkg -x "$amd64click" $tmpdir/amd64
cp -r $tmpdir/armhf $tmpdir/multi
cp -r $tmpdir/i386/lib/* $tmpdir/multi/lib/
cp -r $tmpdir/amd64/lib/* $tmpdir/multi/lib/

# In click manifest replace specific architecture with multi architecture
sed 's/^\s*"architecture":.*/"architecture": ["armhf", "i386", "amd64"],/g' manifest.json > $tmpdir/multi/manifest.json
