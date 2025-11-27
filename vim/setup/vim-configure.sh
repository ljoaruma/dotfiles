#!/usr/bin/env bash
# vim: set ts=2 sw=2 et si filetype=bash :

# エラー発生時は即中断
set -eu -o pipefail

LOGDIRECOTY="${XDG_STATE_HOME:-$HOME/.local/state}/var/log/vim"
mkdir -p "${LOGDIRECOTY}"
LOGFILE="${LOGDIRECOTY}/configure-$(date "+%Y%m%d-%H%M%S")"
touch "${LOGFILE}"

declare -p PATH >> "${LOGFILE}"
cat $0 >> "${LOGFILE}"
echo "$*" >> "${LOGFILE}"

./configure \
  --with-features=huge \
  --prefix="$HOME/.local" \
  --enable-autoservername \
  --enable-python3interp \
  --enable-rubyinterp \
  --enable-luainterp \
  --with-luajit \
  --enable-cscope \
  --enable-fontset \
  --enable-terminal \
  --enable-multibyte \
  --enable-gui=gtk3 \
  --enable-fail-if-missing \
  "$@" 2>&1 | tee -a "${LOGFILE}"

#  --without-x \

