#!/bin/sh

system=`cat /tmp/script.log |head -1|cut -d" " -f1|cut -d"/" -f4|cut -d "." -f1`
game=`cat /tmp/script.log |head -1|cut -d" " -f2|cut -d"." -f1`

if [ "$game" != "" ]
then
  echo "Grabbing framebuffer to $game.png"
  fbshot /tmp/$game.png.tmp
  pngcp /tmp/$game.png.tmp /tmp/$game.png
  rm -fr $game.png.tmp
fi

case $system in
	vice )
		echo "Vice we are"
		mv /tmp/$game.png /servers/systems/c64/snaps/
	;;
	uae )
		echo "UAE we are"
	;;
esac

