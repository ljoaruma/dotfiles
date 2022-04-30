#!/usr/bin/env bash

./configure \
  --with-features=huge \
  --prefix="$HOME/usr" \
  --enable-python3interp \
  --enable-rubyinterp \
  --enable-cscope \
  --enable-terminal \
  --enable-multibyte \
  --enable-gui=no \
  --with-luajit \
  --without-x \
  --enable-fail-if-missing
