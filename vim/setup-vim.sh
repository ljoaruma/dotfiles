#!/usr/bin/env bash
# vim: set ts=2 sw=2 et si filetype=bash :

declare -r SOURCE_DIR="$(dirname $(readlink -f "$0"))"

mkdir -vp $HOME/usr/src
cd $HOME/usr/src
git clone https://github.com/vim/vim.git

cd vim
declare -r TARGET_TAG=$(git tag | tail -n1)

git switch "${TARGET_TAG}" -c track/release

#. "${SOURCE_DIR}/vim/install-vim.sh"

echo "OK, Next Step."
echo "cd $(pwd)"
echo "\"${SOURCE_DIR}/vim/install-vim.sh\""

