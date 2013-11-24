BBBMusE - BeagleBoneBlack Multi-system Emulator
===============================================

Plan
----

Build a BeagleBoneBlack boot image with out of the box, ready to use, optimized multi-system game emulation.

Features
--------

 * Bootable from the eMMC
 * Easy to use, intuitive graphical menu system to browse and run games.
 * Dedicated disk partition to store your roms and specific configurations.
 * Optimal sound and graphics (settings and resolutions), boot options, overclocking settings.
 * Optimized for performance and full speed gaming.
 * Optimized to work with joystick/button panels and arcade cabinets (works with normal kbds too)
   * Each button can be mapped to software/emulation functions or game controls.
   * Ready to use with popular setups (ie: ipac, jpac and jamma conectors)
   * Ready to use with 15Khz arcade CRTs (works with HDMI or VGA monitors taoo)
 * Maintained database of game settings that work and run at full speed.
 * Supported systems:
   * Arcade
   * Amiga
 * Extensible framework. Frequent updates, more systems supported soon.

Installation
------------

The first thing you need to do is to burn the [BBB Debian image][1] on a SD card, because Debian is the way we like to roll.

"This image can be written to a 1Gb (or greater) microSD card, via 'dd' in linux or the win32 image program linked to on CircuitCo's wiki page. First hold down on the boot select button (next to microSD card) and apply power (same procedure as the official CircuitCo images), it should boot into debian and begin flashing the eMMC, once completed all 4 LED's should be full ON... Simply remove power, remove microSDcard and Debian will now boot from eMMC."

Example using `dd` on OSX:

```
diskutil list
diskutil unmountDisk /dev/disk8s1
dd if=BBB-eMMC-flasher-debian-7.2-2013-11-15.img of=/dev/rdisk8 bs=1m
diskutil eject /dev/disk8
```

Now log into your new Debian BBB and install a few packages first:

```
apt-get update
apt-get install gcc
apt-get install libsdl1.2-dev
apt-get install make
apt-get install screen
```

Compiling Advmame
-----------------

Download the latest version of [Advmame][2], untar the thing and:

```
mkdir -p /servers/sources /serves/mame
cd /servers/sources
wget http://downloads.sourceforge.net/project/advancemame/advancemame/1.2/advancemame-1.2.tar.gz
tar zxvf advancemame-1.2.tar.gz
cd advancemame-1.2
./configure --prefix=/servers/mame
```

Then change the Makefile for maximum code optimization:

```
CONF_CFLAGS_OPT= -O8 -fomit-frame-pointer -fno-strict-aliasing -fno-stack-protector -Wall -Wno-sign-compare -Wno-unused
```

The open a `screen` and type `make`. Wait a few hours.


 [1]: http://elinux.org/BeagleBoardDebian#eMMC:_BeagleBone_Black
 [2]: http://advancemame.sourceforge.net
