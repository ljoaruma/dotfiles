#!/usr/bin/env bash
# vim: set ts=2 sw=2 et si filetype=bash :

# エラー発生時は即中断
set -eu -o pipefail

declare -r SOURCE_DIR_="$(dirname $(readlink -f "${BASH_SOURCE:-$0}"))"

# my vimruntime directory
readonly DOTFILES_VIMCONF_DIRECTORY="$(cd $SOURCE_DIR_/../config && pwd -P)"
readonly MY_VIMCONF_DIRECTORY="$(cd ${XDG_CONFIG_HOME:-${HOME}/.config} && pwd -P)/vim"

if [ -d "${MY_VIMCONF_DIRECTORY}" ]; then
  echo "exist ${MY_VIMCONF_DIRECTORY}(directory)"
  return
fi
if [ -f "${MY_VIMCONF_DIRECTORY}" ]; then
  echo "exist ${MY_VIMCONF_DIRECTORY}(file)"
  return
fi
if [ -e "${MY_VIMCONF_DIRECTORY}" ]; then
  echo "exist ${MY_VIMCONF_DIRECTORY}(other)"
  return
fi

ln -sfv "${DOTFILES_VIMCONF_DIRECTORY}" "${MY_VIMCONF_DIRECTORY}"

