#!/bin/bash

# WSL2 service starting

if [[ ! -v WSLENV ]]; then
  return 1
fi

if [ ! -z "$SSH_CLIENT" ]; then
  # とりあえずSSHのときは動かさないようにしておく
  return
fi

__restart_service () {

  if [[ ! -f "$(dirname "${BASH_SOURCE}")/switches/enable/$1" ]]; then
    return 0
  fi

  if [[ ! -x /etc/init.d/$1 ]]; then
    return 1
  fi

  if service $1 status &> /dev/null; then
    return 1
  fi

  sudo service $1 restart &> /dev/null

  return 0
}

__restart_anacron () {

  if [[ ! -f "$(dirname "${BASH_SOURCE}")/switches/enable/anacron" ]]; then
    return 0
  fi


  if [[ ! -x /etc/init.d/anacron ]]; then
    return 1
  fi

  sudo service stop anacron
  sudo service start anacron
}

mapfile _fstab_reserve < <(awk '$3~/\<drvfs\>/ { print $2 }' /etc/fstab)
if [[ $(mount -t 9p | awk '{ print $3 }' | grep -F "$(IFS=''; echo "${_fstab_reserve[*]}")" | wc -l) -ne ${#_fstab_reserve[@]} ]]; then

  unset _fstab_reserve
  return 1
fi

if [[ -f "$(dirname "${BASH_SOURCE}")/switches/enable/ssh" ]] && service ssh status &> /dev/null; then

  # SSHから、fstabで設定しているmountが見えていない場合は、restartする
  # WSL2の/initの関係でWindowsとの連携が上手くいってない可能性が高い
  if [[ $(ssh $USER@localhost mount -t 9p | awk '{ print $3 }' | grep -F "$(IFS=''; echo "${_fstab_reserve[*]}")" | wc -l) -ne ${#_fstab_reserve[@]} ]]; then

    __restart_service rsyslog
    __restart_service ssh
    __restart_service cron

    unset _fstab_reserve
    unset -f __restart_service
    unset -f __restart_anacron

    return
  fi
fi

__restart_service rsyslog
__restart_service ssh
## cronを起動した時だけ、anacronも起動
#__restart_service cron && __restart_anacron
__restart_service cron

unset _fstab_reserve
unset -f __restart_service
unset -f __restart_anacron

