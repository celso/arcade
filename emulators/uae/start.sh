#!/bin/sh

clear > /dev/tty1

GAMES='/servers/uae/disks/CD200/'
SYS='/servers/uae/disks/Stuff/'
cd /servers/uae
gid=$1

if [ "$gid" == "" ]
then
  echo "Syntax $0 gameid"
  exit
fi

gamedir=`head -1 games/$gid`
rm -fr $SYS/WBStartup/*
cp -R $GAMES/$gamedir/* $SYS/WBStartup/

cat games/$gid|egrep "[0-9]+ [0-9]+\$" > /tmp/uaekeymaps.txt
cat games/$gid|egrep "[\ ()a-zA-Z0-9\._/]+=" > /tmp/uaeopts
cp etc/uaerc /tmp/uaerc
for f in `cat /tmp/uaeopts |cut -d"=" -f1`
do
  echo "merging option $f="
  cat /tmp/uaerc |grep -v "$f=" > /tmp/uaerc.tmp
  mv /tmp/uaerc.tmp /tmp/uaerc
done
cat /tmp/uaeopts >> /tmp/uaerc

export uaemapfile=/tmp/uaekeymaps.txt

rmmod nvidiafb > /dev/null 2> /dev/null
rmmod nvidia > /dev/null 2> /dev/null
modprobe nvidiafb > /dev/null 2> /dev/null
fbset pal_768x288 > /dev/null 2> /dev/null

rm ~root/.uaerc
ln -s /tmp/uaerc ~root/.uaerc

./bin/uae >/dev/null 2>> /servers/uae/uae.log

clear > /dev/tty1

sleep 3
