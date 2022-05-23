#!/usr/bin/env bash

mkdir -p "$HOME/var/log"
LOGFILE="$HOME/var/log/vim-configure-$(date "+%Y%m%d-%H%M%S")"
touch "${LOGFILE}"

declare -p PATH >> "${LOGFILE}"
cat $0 >> "${LOGFILE}"
echo "$*" >> "${LOGFILE}"

./configure \
  --with-features=huge \
  --prefix="$HOME/usr" \
  --enable-python3interp \
  --enable-rubyinterp \
  --enable-luainterp \
  --enable-cscope \
  --enable-terminal \
  --enable-multibyte \
  --enable-gui=no \
  --with-luajit \
  --without-x \
  --enable-fail-if-missing \
  "$@" | tee -a "${LOGFILE}"

