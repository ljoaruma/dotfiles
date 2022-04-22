#!/bin/bash
# vim: set ts=2 sw=2 et si filetype=bash :

declare -r VIM_RUNTIME_PATH="${HOME}/.vim"
declare -r VIM_RUNTIME_PATH_WIN="${HOME}/vimfiles"
mkdir -vp ${VIM_RUNTIME_PATH}


if [[ -v OS ]] && [[ "${OS}" = *Windows* ]]; then
  declare -r SOLALIZE_INSTALLPATH=$HOME/vim-plug-ins
else
  declare -r SOLALIZE_INSTALLPATH=~/usr/src
fi

mkdir -vp "${SOLALIZE_INSTALLPATH}"
cd "${SOLALIZE_INSTALLPATH}"
git clone https://github.com/altercation/solarized.git

# to vim

cp -vprl -t "${VIM_RUNTIME_PATH}" solarized/vim-colors-solarized/*

# to vim(win)

if [[ -v OS ]] && [[ "${OS}" = *Windows* ]]; then
  cp -vprl -t "${VIM_RUNTIME_PATH_WIN}" solarized/vim-colors-solarized/*
fi

