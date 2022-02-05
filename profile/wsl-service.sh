#!/bin/bash

# WSL2 service starting
if service ssh status &> /dev/null; then
  # SSHから、fstabで設定しているmountが見えていない場合は、restartする
  # WSL2の/initの関係でWindowsとの連携が上手くいってない可能性が高い
  if ! ssh ryo@localhost mount | grep -q "\/mnt\/[wxy] " &> /dev/null; then
    sudo service ssh restart &> /dev/null
    sudo service cron restart &> /dev/null
  fi
else
  sudo service ssh restart &> /dev/null
  sudo service cron restart &> /dev/null
fi

if ! service cron status &> /dev/null; then
  sudo service cron restart &> /dev/null
fi

