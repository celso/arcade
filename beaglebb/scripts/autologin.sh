# this links to /root/.bashrc
# ln -s /servers/scripts/autologin.sh .bashrc

export PS1='\h:\w\$ '
umask 022
export PATH=$PATH:/servers/mame/bin
export ADVANCE=/servers/config
export TERM=linux

tty | grep tty1 > /dev/null && (
  setterm -foreground black -cursor off -msg off
  clear
  # sound volume reset
  amixer -q sset "PCM",0 200
  amixer -q sset "HP DAC",0 118
  #   to see soundcard controls:
  #   amixer controls 
  cp /servers/config/advmame.xml.good /servers/config/advmame.xml
)

# main loop

tty | grep tty1 > /dev/null && ( while [ 1 ]; do
  setterm -foreground black -cursor off -msg off
  timelimit -q -T 10 -t 2 fbv --delay 1 --noinfo --enlarge -c -u /servers/config/bbbmuse.png
  cd /servers/logs
  touch /servers/config/advmame.xml
  sleep 1
  nice -15 /servers/mame/bin/advmenu >/dev/null 2>/dev/null
  # nice -15 /servers/mame/bin/advmenu --log
  timelimit -q -T 10 -t 2 fbv --delay 1 --noinfo --enlarge -c -u /servers/config/bbbmuse.png
  if [ -f /tmp/quitloop ]; then
    sleep 3600
  fi
  if [ -f /tmp/exec.sh ]; then
    /tmp/exec.sh >/dev/null 2>/dev/null
    rm -fr /tmp/exec.sh
  fi
# cleanup
  rm -fr /tmp/ide.hdd /tmp/vice.log /tmp/vice.vkm /tmp/vicerc
done; )
