#!/usr/bin/env bash
# vim: set ts=2 sw=2 et si filetype=bash :

# エラー発生時は即中断
set -eu -o pipefail

declare -r SOURCE_DIR_="$(dirname $(readlink -f "${BASH_SOURCE:-$0}"))"

# directory

readonly DOTFILES_GITCONF_DIRECTORY="$(cd $SOURCE_DIR_/../config && pwd -P)"
readonly MY_GITCONF_DIRECOTY="$(cd ${XDG_CONFIG_HOME:-${HOME}/.config} && pwd -P)/git"

if [ -d ${MY_GITCONF_DIRECOTY} ]; then
  echo "exist ${MY_GITCONF_DIRECOTY}(directory)"
  exit
fi

if [ -f ${MY_GITCONF_DIRECOTY} ]; then
  echo "exist ${MY_GITCONF_DIRECOTY}(file)"
  exit
fi

if [ -e ${MY_GITCONF_DIRECOTY} ]; then
  echo "exist ${MY_GITCONF_DIRECOTY}(other)"
  exit
fi

ln -sfv "${DOTFILES_GITCONF_DIRECTORY}" "${MY_GITCONF_DIRECOTY}"

