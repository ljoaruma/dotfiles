#!/bin/bash
# vim: set ts=2 sw=2 et si filetype=bash :

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
  --enable-fail-if-missing &&
make clean && make && make install || { echo "failed vim imstall"; exit 1; }

