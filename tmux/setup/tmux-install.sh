#!/bin/bash
# vim: set ts=2 sw=2 et si filetype=bash :

# エラー発生時は即中断
set -eu -o pipefail

sudo apt install libevent-dev

readonly TMUX_SRC_DIRECOTY="${XDG_DATA_HOME}/src"
mkdir -vp "${TMUX_SRC_DIRECOTY}"

cd "${TMUX_SRC_DIRECOTY}"

git clone https://github.com/tmux/tmux.git
cd tmux

readonly LATEST_TAG="$(git describe --tags --abbrev=0 origin/HEAD)"
echo "install version ${LATEST_TAG} OK?(press any key)"
read

git switch --detach "${LATEST_TAG}"

sh autogen.sh
./configure --prefix="${HOME}/.local" && make -j $( expr $(cat /proc/cpuinfo | grep processor | wc -l) / 2 + 1) && make install

