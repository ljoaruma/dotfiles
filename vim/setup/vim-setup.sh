#!/usr/bin/env bash
# vim: set ts=2 sw=2 et si filetype=bash :

# エラー発生時は即中断
set -eu -o pipefail

declare -r SOURCE_DIR_="$(dirname $(readlink -f "${BASH_SOURCE:-$0}"))"

# my config directory
readonly DOTFILES_VIMCONF_DIRECTORY="$(cd $SOURCE_DIR_/../config && pwd -P)"
readonly MY_VIMCONF_DIRECTORY="$(cd ${XDG_CONFIG_HOME:-${HOME}/.config} && pwd -P)/vim"

if [ -d "${MY_VIMCONF_DIRECTORY}" ]; then
  echo "exist ${MY_VIMCONF_DIRECTORY}(directory)"
  exit
fi
if [ -f "${MY_VIMCONF_DIRECTORY}" ]; then
  echo "exist ${MY_VIMCONF_DIRECTORY}(file)"
  exit
fi
if [ -e "${MY_VIMCONF_DIRECTORY}" ]; then
  echo "exist ${MY_VIMCONF_DIRECTORY}(other)"
  exit
fi

ln -sfv "${DOTFILES_VIMCONF_DIRECTORY}" "${MY_VIMCONF_DIRECTORY}"

# my runtime directory

readonly DOTFILES_VIMRUNTIME_DIRECTORY="$(cd $SOURCE_DIR_/../share && pwd -P)"
readonly MY_VIMRUNTIME_DIRECTORY="$(cd ${XDG_DATA_HOME:-${HOME}/.local/share} && pwd -P)/vim.runtime"

if [ -d "${MY_VIMRUNTIME_DIRECTORY}" ]; then
  echo "exist ${MY_VIMRUNTIME_DIRECTORY}(directory)"
  exit
fi
if [ -f "${MY_VIMRUNTIME_DIRECTORY}" ]; then
  echo "exist ${MY_VIMRUNTIME_DIRECTORY}(file)"
  exit
fi
if [ -e "${MY_VIMRUNTIME_DIRECTORY}" ]; then
  echo "exist ${MY_VIMRUNTIME_DIRECTORY}(other)"
  exit
fi

cp -vpr "${DOTFILES_VIMRUNTIME_DIRECTORY}" "${MY_VIMRUNTIME_DIRECTORY}"

