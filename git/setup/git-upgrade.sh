#!/usr/bin/env bash
# vim: set ts=2 sw=2 et si filetype=bash :

# エラー発生時は即中断
set -eu -o pipefail

# fetch & checkout

readonly SRC_DIRECTORY="${XDG_DATA_HOME:-${HOME}/.local/share}/src"
readonly GIT_SRC_DIRECTORY="${SRC_DIRECTORY}/git"

cd "${GIT_SRC_DIRECTORY}"

git fetch origin

readonly CURRENT_VERSION=`git describe --tags --abbrev=0 HEAD`
readonly LATEST_VERSION=`git describe --tags --abbrev=0 origin/HEAD`

echo "install version ${CURRENT_VERSION} -> ${LATEST_VERSION} OK?(press any key)"
read

# remove old version
# ---
# インストールしたファイルのリストを$XDG_STATE_HOME/git/git-install-list.txtに格納しているので、このリストに記載のファイルを削除

readonly GIT_PREFIX="${HOME}/.local"
readonly GIT_INSTALLEDLIST="${XDG_STATE_HOME:-${HOME}/.local/state}/git/git-install-list.txt"
readonly GIT_INSTALLLIST_WORK="${XDG_STATE_HOME:-${HOME}/.local/state}/git/tmp-install"

cat "${GIT_INSTALLEDLIST}" | xargs -d'\n' rm -vf

git switch --detach "${LATEST_VERSION}"

# ビルド & install

make configure
./configure --prefix "${GIT_PREFIX}"

#readonly BUILD_JOBS=$( expr $(cat /proc/cpuinfo | grep processor | wc -l) / 2 + 1)
readonly BUILD_JOBS=$(cat /proc/cpuinfo | grep processor | wc -l)
echo "${BUILD_JOBS}"

make --jobs="${BUILD_JOBS}" --load-average=0.8
make --jobs="${BUILD_JOBS}" --load-average=0.8 all doc info

make install install-doc install-html install-info

# インストールしたファイルのリスト作成
# ---
# インストールしたファイルのリストを$XDG_STATE_HOME/git/git-install-list.txtに格納する

rm -rfv "${GIT_INSTALLLIST_WORK}"
mkdir -vp "${GIT_INSTALLLIST_WORK}"
make prefix="${GIT_INSTALLLIST_WORK}" install install-doc install-html install-info

find "${GIT_INSTALLLIST_WORK}" -type f | sed 's|'"${GIT_INSTALLLIST_WORK}"'|'"${GIT_PREFIX}"'|g' > "${GIT_INSTALLEDLIST}"

