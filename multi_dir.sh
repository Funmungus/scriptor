# Assuming version number is only numbers and decimals
localVersion="$(grep \"version\" manifest.json|sed 's/[^0-9.]//g')"
if [ "x$localVersion" = "x" ]; then
  echo "Error: Not able to find version number. manifest.json is missing or malformed" >&2
  echo "Error: Not able to build multi package" >&2
  exit 1
fi
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
Extracting click packages...
"
rm -r armhf i386 amd64 multi
dpkg -x "$armclick" armhf
dpkg -x "$i386click" i386
dpkg -x "$amd64click" amd64
cp -r armhf multi
cp -r i386/lib/* multi/lib/
cp -r amd64/lib/* multi/lib/

# In click manifest replace specific architecture with multi architecture
sed 's/^\s*"architecture":.*/"architecture": ["armhf", "i386", "amd64"],/g' manifest.json > multi/manifest.json
