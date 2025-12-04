#!/bin/bash
# vim: set ts=2 sw=2 et si filetype=bash :

# エラー発生時は即中断
set -eu -o pipefail

readonly TMUX_SRC_DIRECOTY="${XDG_DATA_HOME}/src"

if [ ! -d "${TMUX_SRC_DIRECOTY}/tmux" ]; then
  echo "not exist ${TMUX_SRC_DIRECOTY}/tmux"
  exit
fi

cd "${TMUX_SRC_DIRECOTY}/tmux"
git fetch --prune --prune-tags --tags origin

readonly CURRENT_TAG="$(git describe --tags HEAD)"
readonly LATEST_TAG="$(git describe --tags --abbrev=0 origin/HEAD)"
echo "update version ${CURRENT_TAG} -> ${LATEST_TAG} update OK?(press any key)"
read

make uninstall

git switch --detach "${LATEST_TAG}"

sh autogen.sh
./configure --prefix="${HOME}/.local" && make -j $( expr $(cat /proc/cpuinfo | grep processor | wc -l) / 2 + 1) && make install

