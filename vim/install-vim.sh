#!/bin/bash
# vim: set ts=2 sw=2 et si filetype=bash :

. "$(dirname "${BASH_SOURCE:-$0}")"/configure-vim.sh &&
make clean && make && make install || { echo "failed vim imstall"; exit 1; }

