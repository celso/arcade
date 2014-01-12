#!/bin/bash

cat /servers/config/arcade_keymap.cfg |egrep "^[a-z0-9\_]+\,[a-z0-9]+\,[0-9]+\$" > /tmp/arcade_keymap.cfg

cp /servers/config/adv_inputmaps.rc.template /tmp/adv_inputmaps.rc

for f in `cat /tmp/arcade_keymap.cfg`
do
  key=$(echo $f|cut -d"," -f1)
  advkey=$(echo $f|cut -d"," -f2)
  rawkey=$(echo $f|cut -d"," -f3)

  sed -i -e "s/$key/$advkey/g" /tmp/adv_inputmaps.rc
done

mv /tmp/adv_inputmaps.rc /servers/config/adv_inputmaps.rc
