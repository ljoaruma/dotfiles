#!/bin/bash

# wslの場合だけのユーティリティ関数追加
if [[ -v WSL_DISTRO_NAME ]]; then
  source "$(dirname "${BASH_SOURCE}")"/wsl-utils.sh
fi

# pushdで、すでにスタックにあるディレクトリの場合は、スタックに積まない
function upushd() {
  [[ ! -d "$1" ]] && return;

  local -r _dest="$( cd "$1" && pwd)";

  local _n=0
  local _f=""
  while read -r _n _f; do
    [[ "${_f}" = "${_dest}" ]] && echo "pushd +${_n}" && pushd +${_n} && return 0;
  done < <(dirs -p -v -l);
  pushd "${_dest}";
}

