#!/bin/bash
# vim: set ts=2 sw=2 et si filetype=bash :

# エラー発生時は即中断
set -eu -o pipefail

declare -r SOURCE_DIR_="$(dirname $(readlink -f "${BASH_SOURCE:-$0}"))"

# directory

readonly DOTFILES_TMUXCONF_DIRECTORY="$(cd $SOURCE_DIR_/../config && pwd -P)"
readonly MY_TMUXCONF_DIRECOTY="$(cd ${XDG_CONFIG_HOME:-${HOME}/.config} && pwd -P)/tmux"

if [ -d ${MY_TMUXCONF_DIRECOTY} ]; then
  echo "exist ${MY_TMUXCONF_DIRECOTY}(directory)"
  exit
fi

if [ -f ${MY_TMUXCONF_DIRECOTY} ]; then
  echo "exist ${MY_TMUXCONF_DIRECOTY}(file)"
  exit
fi

if [ -e ${MY_TMUXCONF_DIRECOTY} ]; then
  echo "exist ${MY_TMUXCONF_DIRECOTY}(other)"
  exit
fi

ln -sfv "${DOTFILES_TMUXCONF_DIRECTORY}" "${MY_TMUXCONF_DIRECOTY}"

