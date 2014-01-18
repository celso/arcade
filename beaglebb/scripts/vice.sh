#!/bin/bash

echo $0 $* > /tmp/script.log

if [ "$1" == "" ]
then
  echo "Syntax $0 gameid"
  exit
fi

# make the exec file

cp /servers/config/vice.vkm /tmp/vice.vkm
cp /servers/config/vice.defaults /tmp/vicerc

# Global arcade_* keymaps substitution

cat /servers/config/arcade_keymap.cfg |egrep "^[a-z0-9\_]+\,[a-z0-9]+\,[0-9]+,[0-9]+\$" > /tmp/arcade_keymap.cfg

for f in `cat /tmp/arcade_keymap.cfg`
do
  key=$(echo $f|cut -d"," -f1)
  advkey=$(echo $f|cut -d"," -f2)
  sdlkey=$(echo $f|cut -d"," -f4)
  sed -i -e "s/$key/$sdlkey/g" /tmp/vicerc
  sed -i -e "s/$key/$sdlkey/g" /tmp/vice.vkm
done

unzip -o /servers/systems/c64/roms/$1 -d /tmp

cat <<EOF > /tmp/exec.sh
#!/bin/bash

cd /servers/vice
nice -20 ./bin/x64 -mouse -config /tmp/vicerc -cartide64 /servers/systems/c64/ide64/idedos.bin -IDE64image1 /tmp/ide.hdd > /tmp/vice.log
sleep 1
EOF

chmod 755 /tmp/exec.sh
killall advmenu
