#!/usr/bin/env bash
# vim: set ts=2 sw=2 et si filetype=bash :

# エラー発生時は即中断
set -eu -o pipefail

sudo apt install asciidoc docbook2x xmlto libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev

readonly SRC_DIRECTORY="${XDG_DATA_HOME:-${HOME}/.local/share}/src"
readonly GIT_SRC_DIRECTORY="${SRC_DIRECTORY}/git"
mkdir -vp "${SRC_DIRECTORY}"

if [ ! -d "${GIT_SRC_DIRECTORY}" ]; then
  cd "${SRC_DIRECTORY}"
  git clone https://github.com/git/git.git
fi

cd "${GIT_SRC_DIRECTORY}"
git fetch origin

readonly LATEST_VERSION=`git describe --tags --abbrev=0 origin/HEAD`

echo "install version ${LATEST_VERSION} OK?(press any key)"
read

readonly GIT_PREFIX="${HOME}/.local"
readonly GIT_INSTALLLIST_WORK="${XDG_STATE_HOME:-${HOME}/.local/state}/git/tmp-install"

git switch --detach "${LATEST_VERSION}"

make configure
./configure --prefix "${GIT_PREFIX}"

make -j $( expr $(cat /proc/cpuinfo | grep processor | wc -l) / 2 + 1)
make -j $( expr $(cat /proc/cpuinfo | grep processor | wc -l) / 2 + 1) all
make -j $( expr $(cat /proc/cpuinfo | grep processor | wc -l) / 2 + 1) doc
make -j $( expr $(cat /proc/cpuinfo | grep processor | wc -l) / 2 + 1) info

read

mkdir -vp "${GIT_INSTALLLIST_WORK}"
make prefix="${GIT_INSTALLLIST_WORK}" install install-doc install-html install-info
make install install-doc install-html install-info

find "${GIT_INSTALLLIST_WORK}" -type f | sed 's|'"${GIT_INSTALLLIST_WORK}"'|'"${GIT_PREFIX}"'|g' > "${GIT_INSTALLLIST_WORK}/../git-install-list.txt"

