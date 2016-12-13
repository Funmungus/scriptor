# Scriptor

Save a list of scripts and executables, and execute with a tap.

## Source and downloads

* source: https://launchpad.net/scriptor
* releases: https://launchpad.net/scriptor/+download
* OpenStore install: openstore://scriptor.newparadigmsoftware
* OpenStore: https://open.uappexplorer.com/app/scriptor.newparadigmsoftware
* Ubuntu Store install: scope://com.canonical.scopes.clickstore?q=Scriptor

## Building source

Scriptor can also build and run using QtCreator.  The following
instructions are to build a multi-platform package from the
command line.  Given version number <ver>, the final package will be
scriptor.newparadigmsoftware_<ver>_multi.click.

Required command line tools to build with helper scripts:
click, click-buddy, sed, grep, dpkg
adb is required for the install script.

Before the first build, click chroots are needed for each target.  Use
make_chroots.sh to make valid targets for building.  The click chroots
are made with no names.  check_chroots.sh prints whether required chroots are
created, and update_chroots.sh updates all three of the required chroots.

To build a confined package, execute build_multi.sh from the source directory.
To build an unconfined package, execute openstore.sh.

Install by executing install.sh.  The install
script has one optional parameter, which is a device serial number.  Refer
to `adb devices` for more info.
