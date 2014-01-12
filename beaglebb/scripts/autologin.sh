# this links to /root/.bashrc
# ln -s /servers/scripts/autologin.sh .bashrc

export PS1='\h:\w\$ '
umask 022
export PATH=$PATH:/servers/mame/bin
export ADVANCE=/servers/config
export TERM=linux

tty | grep tty1 && (
  # sound volume reset
  amixer -q cset numid=1 200
  #   to see soundcard controls:
  #   amixer controls 
)

# main loop

tty | grep tty1 && ( while [ 1 ]; do
  setterm -foreground black -clear -cursor off -msg off
  clear
  cd /servers/logs
  touch /servers/config/advmame.xml
  nice -15 /servers/mame/bin/advmenu >/dev/null 2>/dev/null
  # nice -15 /servers/mame/bin/advmenu --log
  if [ -f /tmp/quitloop ]; then
    sleep 3600
  fi
  if [ -f /tmp/exec.sh ]; then
    /tmp/exec.sh
    rm -fr /tmp/exec.sh
  fi
  sleep 1
done; )
