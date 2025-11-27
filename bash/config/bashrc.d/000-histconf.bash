#!/bin/bash
# vim: set expandtab ts=2 fenc=utf-8 ff=unix filetype=sh :

# HISTORY設定
# ---

BASH_STATE_="${XDG_STATE_HOME:-${HOME}/.local/state}/bash"
if [ -f "${BASH_STATE_}/bash_history" ]; then
  HISTFILE="${BASH_STATE_}/bash_history"
fi
unset BASH_STATE_

export HISTCONTROL=ignoreboth
export HISTSIZE=65535
export HISTFILESIZE=65535
export HISTIGNORE="history:history *:p[0-9n]:jobs:fg:share_history:share_history :#*"

# 履歴重複削除
# ---
# 履歴から過去の同じコマンドを除外する(switchにshare-historyがある場合にのみ有効化)
# 同期処理と非同期処理を準備するが、プロンプトがデッドロックがかかって停止する可能性を排除するため非同期版のほうを使う

function share_history_nosync {
  local hist_file_tmp=${HISTFILE:-$HOME/.bash_history}.$(basename $(tty))
  local hist_file="${HISTFILE:-$HOME/.bash_history}"
  history -a &&
  cp "${hist_file}" "${hist_file_tmp}" &&
  [ -s "${hist_file_tmp}" ] &&
  tac ${hist_file_tmp} |
  sed 's/[[:blank:]]\+$//g' |
  awk '!a[$0]++' |
  tac > "${hist_file}" &&
  history -c &&
  history -r
}

function share_history_async {
  local _lock=-1;
  local _locked=0;
  exec {_lock}>~/.bash_history.lock &&
  flock --nonblock --exclusive ${_lock} &&
  _locked=1 &&
  history -a &&
  tac ~/.bash_history |
  sed 's/[[:blank:]]\+$//g' |
  awk '!a[$0]++' |
  tac > ~/.bash_history.tmp &&
  [ -f ~/.bash_history.tmp ] &&
  mv ~/.bash_history{.tmp,} &&
  history -c &&
  history -r
  [[ ${_locked} -ne 0 ]] && flock --unlock ${_lock}
  [[ ${_lock} -ne -1 ]] && exec {_lock}>&-
}

#if [[ -x flock ]]; then
#
#  function share_history {
##    share_history_async
#    share_history_nosync
#  }
#
#else
#
#  function share_history {
#    share_history_nosync
#  }
#
#fi

function share_history {
  share_history_nosync
}

if [[ -e "${XDG_CONFIG_HOME:-$HOME/.config}/bash/switches/enable/share-history" ]]; then
  PROMPT_COMMAND='share_history'
  shopt -u histappend
fi

