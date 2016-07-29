# Assuming version number is only numbers and decimals
localVersion="$(grep \"version\" manifest.json|sed 's/[^0-9.]//g')"
if [ "x$localVersion" = "x" ]; then
  echo "Error: Not able to find version number. manifest.json is missing or malformed" >&2
  echo "Error: Not able to install package" >&2
  exit 1
fi

clickfile="scriptor.newparadigmsoftware_${localVersion}_multi.click"
if [ ! -f "$clickfile" ]; then
  echo "Error: Click package $clickfile has not been built.  Refer to README.md for build instructions." >&2
  exit 1
fi

if [ "x$(command -v adb)" = "x" ]; then
  echo "Error: adb command not found" >&2
  exit 1
fi
adb start-server >/dev/null 2>&1

# adb does a carriage return for Windows users
homedir="$(adb shell echo '$HOME'|sed 's/\r//g;s/\n//g')"
if [ $? -ne 0 ]; then
  echo "Error: Unknown adb error" >&2
  exit 1
fi

echo "Pushing click file to device..."
if [ $# -gt 0 ]; then
  adbopts="-s \"$1\""
else
  adbopts=""
fi
adb $adbopts push "$clickfile" "$homedir/Downloads/"
if [ $? -ne 0 ]; then
  echo "Error: Unknown adb error" >&2
  exit 1
fi

adb $adbopts shell "pkcon install-local --allow-untrusted \"$homedir/Downloads/$clickfile\""
if [ $? -eq 0 ]; then
  echo "Install successful"
else
  echo "Error: Unknown adb error" >&2
  exit 1
fi
