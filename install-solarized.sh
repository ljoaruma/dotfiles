#!/bin/bash
# vim: set ts=2 sw=2 et si filetype=bash :

declare -r VIM_RUNTIME_PATH="${HOME}/.vim"
mkdir -vp ${VIM_RUNTIME_PATH}

cd ~/usr/src

git clone https://github.com/altercation/solarized.git

# to vim

cp -vprl -t "${VIM_RUNTIME_PATH}" solarized/vim-colors-solarized/*

