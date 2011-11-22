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

if [ -f config/$gid.xmodmap ]
then
  modmap=$gid.xmodmap
else
  modmap=default.xmodmap
fi

if [ -f config/$gid.vicerc ]
then
  vicerc=$gid.vicerc
else
  vicerc=default.vicerc
fi

echo "#!/bin/sh" >/root/.xsession
echo >>/root/.xsession
echo "/usr/bin/xmodmap $prefix/config/$modmap" >>/root/.xsession
echo "xsetroot -solid black -cursor $prefix/empty.cursor $prefix/empty.cursor" >>/root/.xsession
echo "/servers/vice/bin/x64 -config $prefix/config/$vicerc -fullscreen -autostart $prefix/roms/$rom" >>/root/.xsession
chmod 755 /root/.xsession

startx >/dev/null 2>> /servers/vice/vice.log
sleep 3
