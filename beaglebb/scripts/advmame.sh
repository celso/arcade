#!/bin/bash

echo $0 $* > /tmp/script.log

if [ "$1" == "" ]
then
  echo "Syntax $0 gameid"
  exit
fi

fc=`echo -n "$1"|cut -b1-1`

if [ "$fc" == "-" ]
then
  export ADVANCE=/servers/config
  nice -20 /servers/mame/bin/advmame $1
  exit
fi

# keymaps substitution

cat /servers/config/arcade_keymap.cfg |egrep "^[a-z0-9\_]+\,[a-z0-9]+\,[0-9]+,[0-9]+\$" > /tmp/arcade_keymap.cfg

cp /servers/config/adv_inputmaps.rc.template /tmp/adv_inputmaps.rc

for f in `cat /tmp/arcade_keymap.cfg`
do
  key=$(echo $f|cut -d"," -f1)
  advkey=$(echo $f|cut -d"," -f2)
  rawkey=$(echo $f|cut -d"," -f3)

  sed -i -e "s/$key/$advkey/g" /tmp/adv_inputmaps.rc
done

mv /tmp/adv_inputmaps.rc /servers/config/adv_inputmaps.rc

# make the exec file

cat <<EOF > /tmp/exec.sh
#!/bin/bash

cd /servers/mame
nice -20 ./bin/advmame $1
sleep 1
EOF

chmod 755 /tmp/exec.sh
killall advmenu
