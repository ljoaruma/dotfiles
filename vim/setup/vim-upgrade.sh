#!/bin/bash
# vim: set ts=2 sw=2 et si filetype=bash :

# エラー発生時は即中断
set -eu -o pipefail

SCRIPT_DIRECTORY="$(cd $(dirname "${BASH_SOURCE:-$0}") && pwd -P)"

readonly VIM_SOURCE_DIR="${XDG_DATA_HOME:-${HOME}/.local/share}/src/vim"
if [ ! -d "${VIM_SOURCE_DIR}" ]; then
  echo "not found ${VIM_SOURCE_DIR}"
  return
fi

cd "${VIM_SOURCE_DIR}"
git fetch origin

export TARGET_TAG="$(git describe --tags --abbrev=0 origin/HEAD)"
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

