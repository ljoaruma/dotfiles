#!/bin/bash
# vim: set ts=2 sw=2 et si filetype=bash :

# エラー発生時は即中断
set -eu -o pipefail

SCRIPT_DIRECTORY="$(cd $(dirname "${BASH_SOURCE:-$0}") && pwd -P)"

if [ ! -d "$HOME/.local/src/vim" ]; then
  echo "not found $HOME/.local/src/vim"
  return
fi

cd $HOME/.local/src/vim
git fetch origin

export TARGET_TAG="$(git describe --tags origin/HEAD)"
export CURRENT_TAG="$(git describe --tags HEAD)"

echo "install version ${CURRENT_TAG} -> ${TARGET_TAG} update OK?(press any key)"
read

## uninstall

make uninstall

## install

git switch --detach "${TARGET_TAG}"

## configure & make & install

"${SCRIPT_DIRECTORY}"/vim-configure.sh &&
make clean && make && make install || { echo "failed vim imstall"; exit 1; }

