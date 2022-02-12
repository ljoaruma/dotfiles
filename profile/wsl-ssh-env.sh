#!/bin/sh
# vim: ts=2 st=2 et filetype=sh :

if [ -z "$BASH_VERSION" ]; then
  # とりあえずBASHだけ対応
  return
fi

if [ -z "$SSH_CLIENT" ]; then
  return
fi

if [ ! -x /mnt/c/Windows/System32/cmd.exe ]; then
  return
fi

__my_source="${BASH_SOURCE[0]-$0}"
__source_dir="$(cd "$(dirname "${__my_source}")" && pwd)"

eval "$(/mnt/c/Windows/System32/cmd.exe /c cscript "$(wslpath -w "$__source_dir/get-env.vbs")" 2> /dev/null | grep -e WT_SESSION -e WT_PROFILE_ID | tr -d \\r)"

unset __my_source
unset __source_dir

if [ -z "$WT_SESSION" -o -z "$WT_PROFILE_ID" ]; then
  unset WT_SESSION
  unset WT_PROFILE_ID

  return
fi

export WT_SESSION
export WT_PROFILE_ID
WSLENV="WT_SESSION:WT_PROFILE_ID"
export WSLENV
WSL_DISTRO_NAME="$(lsb_release --id --short)"
export WSL_DISTRO_NAME
if which pstree &> /dev/null; then
  while read init_pid; do
    [ ! -S "/run/WSL/""$init_pid""_interop" ] && continue;

    WSL_INTEROP="/run/WSL/""$init_pid""_interop"
    export WSL_INTEROP

  done < <(pstree -np -s $$ | grep -o -e "init([0-9]\+)" | sed 's/init(\([0-9]\+\))/\1/g')

fi

