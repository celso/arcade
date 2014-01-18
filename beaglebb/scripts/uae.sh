#!/bin/bash

echo $0 $* > /tmp/script.log

if [ "$1" == "" ]
then
  echo "Syntax $0 gameid"
  exit
fi

cd /servers/uae

GAMES='/servers/systems/amiga/games/'
MAPS='/servers/systems/amiga/maps/'
SYS='/servers/systems/amiga/disk/'
# gid is Game.config
gid=$1
gname=`echo $1|cut -d"." -f1`

if [ ! -d "$GAMES/$gname/" ]
then
  echo "$GAMES/$gname/ does not exist. Exiting."
  exit
fi

rm -fr $SYS/WBStartup/*
cp -R $GAMES/$gname/* $SYS/WBStartup/

# Merge UAE default keymaps with game specific keymap settings

cat $MAPS/$gid|egrep "^arcade[\ ()a-zA-Z0-9\._/]+ [0-9]+" > /tmp/uaekeymaps.txt
cat /servers/config/uae.defaults |egrep "^arcade[\ ()a-zA-Z0-9\._/]+ [0-9]+" > /tmp/uaekeymapdefaults.txt

for f in `cat /tmp/uaekeymaps.txt |cut -d" " -f1`
do
  echo "merging keymap $f"
  cat /tmp/uaekeymapdefaults.txt |grep -v "$f " > /tmp/uaekeymapdefaults.txt.tmp
  mv /tmp/uaekeymapdefaults.txt.tmp /tmp/uaekeymapdefaults.txt
done
cat /tmp/uaekeymaps.txt >> /tmp/uaekeymapdefaults.txt

# Global arcade_* keymaps substitution

cat /servers/config/arcade_keymap.cfg |egrep "^[a-z0-9\_]+\,[a-z0-9]+\,[0-9]+,[0-9]+\$" > /tmp/arcade_keymap.cfg

for f in `cat /tmp/arcade_keymap.cfg`
do
  key=$(echo $f|cut -d"," -f1)
  advkey=$(echo $f|cut -d"," -f2)
  rawkey=$(echo $f|cut -d"," -f3)

  sed -i -e "s/$key/$rawkey/g" /tmp/uaekeymapdefaults.txt
done

# Merge UAE defaults with game specific settings

cat /servers/config/uae.defaults |egrep "[\ ()a-zA-Z0-9\._/]+=" > /tmp/uaerc
cat $MAPS/$gid|egrep "[\ ()a-zA-Z0-9\._/]+=" > /tmp/uaeopts
for f in `cat /tmp/uaeopts |cut -d"=" -f1`
do
  echo "merging option $f="
  cat /tmp/uaerc |grep -v "$f=" > /tmp/uaerc.tmp
  mv /tmp/uaerc.tmp /tmp/uaerc
done
cat /tmp/uaeopts >> /tmp/uaerc

# End merge

rm ~root/.uaerc
ln -s /tmp/uaerc ~root/.uaerc

cat <<EOF > /tmp/exec.sh
#!/bin/bash

cd /servers/uae
export uaemapfile=/tmp/uaekeymapdefaults.txt

# ./bin/uae >/dev/null 2>> /servers/uae/uae.log
nice -20 ./bin/uae >/dev/null 2>> /dev/null
EOF

chmod 755 /tmp/exec.sh
killall advmenu
