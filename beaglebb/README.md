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
   * Ready to use with 15Khz arcade CRTs (works with HDMI or VGA monitors too)
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
apt-get install gcc g++ make unzip psmisc
apt-get install libsdl1.2-dev vim timelimit
apt-get install screen automake bzip2 patch
```

Basic dir structures, scripts and configs
-----------------------------------------

Everything runs at /servers/

Create the "arcade" user. Choose a password for it.

```
adduser arcade
mkdir -p /servers/sources /servers/mame /servers/logs /servers/fonts
mkdir -p /servers/systems
mkdir -p /servers/systems/amiga
mkdir -p /servers/systems/mame
```

Now copy scripts, config and fonts to /servers/

```
cd /tmp
wget --no-check-certificate https://github.com/celso/arcade/archive/master.zip
unzip master.zip
mv arcade-master/beaglebb/scripts /servers
mv arcade-master/beaglebb/config /servers
mv arcade-master/beaglebb/fonts /servers
```

Empty /etc/motd

Compiling Advmame
-----------------

Download the latest version of [Advmame][2], untar the thing and:

```
cd /servers/sources
wget http://downloads.sourceforge.net/project/advancemame/advancemame/1.2/advancemame-1.2.tar.gz
tar zxvf advancemame-1.2.tar.gz
cd advancemame-1.2
./configure --prefix=/servers/mame
make
make install
```

Then change the Makefile for maximum code optimization:

```
CONF_CFLAGS_OPT= -O8 -fomit-frame-pointer -fno-strict-aliasing -fno-stack-protector -Wall -Wno-sign-compare -Wno-unused
```

The open a `screen` and type `make`. Wait a few hours.

Compile advmenu

```
cd /servers/sources
wget http://downloads.sourceforge.net/project/advancemame/advancemenu/2.6/advancemenu-2.6.tar.gz
tar zxvf advancemenu-2.6.tar.gz
cd advancemenu-2.6
./configure --prefix=/servers/mame
make
make install
```

Compiling UAE
-------------

Download [e-uae][4] and then apply [this patch][3] to the source tree. Make sure you have [automake1.7][4] installed. Then:

```
wget http://www.rcdrummond.net/uae/e-uae-0.8.29-WIP4/e-uae-0.8.29-WIP4.tar.bz2
wget --no-check-certificate https://github.com/celso/arcade/raw/master/emulators/uae/patches/source.patch -O e-uae-0.8.29-WIP4.patch
tar jxvf e-uae-0.8.29-WIP4.tar.bz2
patch  -p0 < e-uae-0.8.29-WIP4.patch
cd e-uae-0.8.29-WIP4
./configure --with-sdl-gl --with-sdl --with-sdl-gfx --with-sdlsound --prefix=/servers/uae
make
make install
```

The patch allows UAE to read the $uaemapfile file (stored in an environment variable) which is used to remap the Amiga keyboard layout to work the arcade controllers. This allows to have per-game mappings and a global and unique key configuration file for the arcade machine.

Your arcade controls
--------------------

I've worked hard on my scripting-fu to make sure that the only file you should need to edit to adapt your arcade controls to the various emulators is [/servers/config/arcade_keymaps.cfg][12]. Here's how it looks:

```
arcade_p1_left,left,79
arcade_p1_right,right,78
arcade_p1_up,up,76
arcade_p1_down,down,77

arcade_p2_left,d,34
arcade_p2_right,g,36
arcade_p2_up,r,19
arcade_p2_down,f,35

arcade_p1_button1,lshift,96
arcade_p1_button2,space,64
arcade_p1_button3,lalt,100
arcade_p1_button4,lcontrol,99

arcade_p2_button1,w,17
arcade_p2_button2,q,16
arcade_p2_button3,s,33
arcade_p2_button4,a,32

arcade_p1_select,1,1
arcade_p2_select,2,2

arcade_lbutton,z,49
arcade_rbutton,i,23
```

So what does this means?

It means that the arcade_p2_left (player 2 joystick, left) maps to the d key (my ipac configuration [see this][13]), which is UAE code 34 in decimal (see [this UAE table][9]).

Suppose your arcade controls keyboard adapter maps the player 2 joystick left to key j instead. Then this line should be:

```
arcade_p2_left,j,38
```

Please note that the default UAE configuration emulates joystick0 and joystick1 with the kbd3 and kbd2 keyboard keys, respectively. From the [UAE configuration docs][10], this means:

```
kbd2  - a joystick will be emulated using the cursor keys and the Right Ctrl
          key or Right Alt key for the fire button.
kbd3  - a joystick will be emulated using the keys T, B, F and H for up,
          down, left and right, respectively, and the Left Alt key for the
          fire button.
```

Take a look at [this image][9] for help on the codes.

Installing WHDLoad
------------------

The Amiga emulation setup uses [WHDLoad][11] to run games and demos from the Amiga harddisk, instead of using floppy images.

This is optional but you should buy a registered copy of WHLoad. It will support the project and the author, who did an amazing job with this tool, and will make your game loading much faster. To install your [WHDLoad][11] license just do:

```
cp ~/WHDLoad.key /servers/systems/amiga/disk/L/WHDLoad.key
```

Installing Mingetty
-------------------

AdvanceMENU needs a real tty available in order to run. In order to work around this and automate things on startup, [mingetty][6] is required.

"mingetty is designed to be a minimal getty for the virtual terminals on the the workstation's monitor and keyboard. It has no support for serial lines."

```
apt-get install mingetty
```

Then add this line to your /etc/inittab (commenting the tty1 getty too):

```
# 1:2345:respawn:/sbin/getty 38400 tty1
1:2345:respawn:/sbin/mingetty --autologin root tty1
```

mingetty will autologin the root user on startup, ussing the tty1 console, and run the /root/.bashrc script, which will initiate things and run advmenu.

Final configuration
-------------------

As root:

```
cd ~root
rm -fr .bashrc .profile
ln -s /servers/scripts/autologin.sh .bashrc
ln -s /servers/scripts/autologin.sh .profile
```

autologin.sh is the main loop script run by mingetty on startup. It sets the necessary environment variables, runs advmenu (for game selection) and looks for /tmp/exec.sh for execution, if present (the reason why this is needed is to workaround some BBB annoyances where advmenu doesn't free SDL correctly when it executes the emulator, causing the second to fail for missing access to video. This allows us to decouple both programs and kill advmenu before starting the emulator.).

Now configure these BeagleBone Black boot options by editing the /boot/uboot/uEnv.txt file:

```
kms_force_mode=video=HDMI-A-1:800x600@60
optargs=quiet capemgr.disable_partno=BB-BONELT-HDMI capemgr.enable_partno=BB-BONE-AUDI-01,BB-BONELT-HDMIN
```

The first line forces the 800x600 resolution for everything, including SDL.

The second line assumes you're using a [Beaglebone Audio Cape][8] for analog audio output (which is my case). It disables the HDMI (video and audio), then enables the audio cape and HDMIN (HDMI without audio). If your monitor has video and audio, and you're not using the Audio Cape, then ignore the second line.


Configuration files
-------------------

Configuration files live in the /servers/config directory. They are:

 * /servers/config/arcade_keymap.cfg - arcade keymappings between your controls and all the emulators, this is the only file you should have to edit
 * /servers/config/uae.defaults - UAE amiga emulator defaults
 * /servers/config/advmame.rc - advmame defaults
 * /servers/config/advmenu.rc - advmenu defaults


Getting some extra space
------------------------

Some techniques to get extra space for a Debian installation.

```
rm -fr /var/cache/apt/archives/*.deb
```


 [1]: http://elinux.org/BeagleBoardDebian#eMMC:_BeagleBone_Black
 [2]: http://advancemame.sourceforge.net
 [3]: https://github.com/celso/arcade/blob/master/emulators/uae/patches/source.patch
 [4]: http://www.rcdrummond.net/uae/e-uae-0.8.29-WIP4/e-uae-0.8.29-WIP4.tar.bz2
 [5]: http://ftp.gnu.org/gnu/automake/automake-1.7.9.tar.gz
 [6]: http://sourceforge.net/projects/mingetty/
 [7]: http://elinux.org/Beagleboard:BeagleBoneBlack_HDMI
 [8]: http://elinux.org/Beagleboard:BeagleBone_Audio
 [9]: https://raw.github.com/celso/arcade/master/docs/amigalayout.png
 [10]: https://github.com/GnoStiC/PUAE/blob/master/docs/configuration.txt
 [11]: http://whdload.de
 [12]: https://github.com/celso/arcade/blob/master/beaglebb/config/arcade_keymap.cfg
 [13]: https://raw.github.com/celso/arcade/master/docs/ipac_mappings.png
