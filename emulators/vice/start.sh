#!/bin/sh

clear > /dev/tty1

prefix="/servers/vice"

cd $prefix
rom=$1
gid=`echo $1|cut -d"." -f1`

if [ "$gid" == "" ]
then
  echo "Syntax $0 gameid"
  exit
fi

export DISPLAY=:0.0

rmmod nvidiafb > /dev/null 2> /dev/null
rmmod nvidia > /dev/null 2> /dev/null
modprobe nvidiafb > /dev/null 2> /dev/null
fbset 512x288_50 > /dev/null 2> /dev/null

if [ -f config/$gid.vkm ]
then
  vkm=$gid.vkm
else
  vkm=default.vkm
fi

if [ -f config/$gid.vicerc ]
then
  vicerc=$gid.vicerc
else
  vicerc=default.vicerc
fi

/servers/vice/bin/x64 -VICIIfull -symkeymap $prefix/config/$vkm -config $prefix/config/$vicerc -autostart $prefix/roms/$rom >$prefix/vice.log 2>/dev/null

clear > /dev/tty1

sleep 3
