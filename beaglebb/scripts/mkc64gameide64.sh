#!/bin/bash

if [ "$1" == "" ]
then
  echo "Syntax $0 ide64_game.zip"
  exit
fi

fusermount -u /mnt/c64/ >/dev/null 2>/dev/null
rm -fr /mnt/c64
mkdir /mnt/c64
cp /servers/systems/c64/ide64/ide_hdd.zip /tmp/
rm -fr ide.hdd
unzip ide_hdd.zip
/servers/sources/fusecfs-1.5/cfs011mount /tmp/ide.hdd /mnt/c64
cd /mnt/c64/01\ hdd/
unzip $1
mv \!*,prg boot
chmod a+x *,prg
ls -las
cd /tmp
fusermount -u /mnt/c64/ >/dev/null 2>/dev/null
rm -fr /mnt/c64
cd /tmp/
rm -fr game_ide64.zip
zip game_ide64.zip ide.hdd
echo "Game is at /tmp/ide.hdd"
echo "Copy it:"
echo "mv /tmp/game_ide64.zip /servers/systems/c64/roms/"
