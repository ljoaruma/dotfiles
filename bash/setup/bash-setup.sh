#!/bin/bash
# vim: set expandtab ts=2 fenc=utf-8 ff=unix filetype=sh :

#
# bash_history                    -> $HOME/${XDG_STATE_HOME:-.local/state}/bash/bash_history
#
# $HOME
# |- .bashrc             --[source]> $HOME/.config/bash
#                                 -> $HOME/${XDG_DATA_HOME:-.local/share}/dotfiles/stored
# bash
# |- setup
# |   `- bash-setup.sh  // self
# |- config                      ..> $HOME/.config/bash
#    |- bashrc           --[source]> bash/config/bashrc.d/*.bash
#    `- bashrc.d
#       |- *.bash       // dropin
#       `- *.d/*        // alt dropin

# エラー発生時は即中断
set -eu -o pipefail

# setup bashhistory

readonly BASH_STATE_="${XDG_STATE_HOME:-${HOME}/.local/state}/bash"
mkdir -vp "${BASH_STATE_}"
touch "${BASH_STATE_}/bash_history"
history -a "${BASH_STATE_}/bash_history"
if [ -f $HOME/.bash_history ]; then
  cat $HOME/.bash_history >> "${BASH_STATE_}/bash_history"
  rm $HOME/.bash_history
fi

# setup bashrc

## my .bashrc to conf directory

readonly MY_BASHRC_DIRECTORY_="$(cd $(dirname ${BASH_SOURCE:-$0})/.. && pwd -P)"
readonly MY_BASHRC_="${MY_BASHRC_DIRECTORY_}/config/bashrc"
readonly MY_BASHRC_CONFIG_="${XDG_CONFIG_HOME:-${HOME}/.config}/bash"

if [ -d "${MY_BASHRC_CONFIG_}" ]; then
  echo "exist ${MY_BASHRC_CONFIG_}(directory)"
  return
fi
if [ -f "${MY_BASHRC_CONFIG_}" ]; then
  echo "exist ${MY_BASHRC_CONFIG_}(file)"
  return
fi
if [ -e "${MY_BASHRC_CONFIG_}" ]; then
  echo "exist ${MY_BASHRC_CONFIG_}(other)"
  return
fi

ln -sfv "${MY_BASHRC_DIRECTORY_}/config" "${MY_BASHRC_CONFIG_}"

## insert source my bashrc to .bashrc

### original .bashrc backup
readonly STORED_CONF_DIRECTORY_="${XDG_DATA_HOME:-${HOME}/.local/share}/dotfiles/stored"
if [ -f  "${STORED_CONF_DIRECTORY_}/.bashrc" ]; then
  # すでに退避済みのファイルがある場合はセットアップ済みとして終了
  echo ".bashrc already setup(stored)"
  exit 0
fi

mkdir -vp "${STORED_CONF_DIRECTORY_}"
cp --backup=t -vpL $HOME/.bashrc "${STORED_CONF_DIRECTORY_}"

### change HISTSIZE
### ---
### HISTFILESIZEが設定されると履歴ファイルが切り詰められるのでそこだけ元のファイルからコメントアウト

# 正規表現文字列 
# 1 export HISTFILESIZE= の先頭にシャープ(先頭空白削除)
# 2 foobar; export HISTFILESIZE= ; foobar のexport HISTFILESIZE=をnop(:) に差し替え
# 2 foobar; HISTFILESIZE= ; foobar のHISTFILESIZE=をnop(:) に差し替え
sed \
  -e 's/^[[:blank:]]*\(export[[:blank:]]\+\)\?HISTFILESIZE=[0-9]\+[[:blank:]]*\(.*\)*$/#\0/g' \
  -e 's/^\([[:blank:]]*[^#].*\)\<export[[:blank:]]\+HISTFILESIZE=[0-9]*\([^0-9].*\)\?$/\1:\2/g' \
  -e 's/^\([[:blank:]]*[^#].*\)\<HISTFILESIZE=[0-9]*\([^0-9].*\)\?$/\1:\2/g' \
  "${STORED_CONF_DIRECTORY_}/.bashrc" > \
  "$HOME/.bashrc"

### insertion source to .bashrc

#### my .profile path replace /home/username -> ${HOME}
readonly MY_BASHRC_PATH_="${MY_BASHRC_CONFIG_/#${HOME}/\$\{HOME\}}/bashrc"
if grep -q -F -e "${MY_BASHRC_PATH_}" ~/.bashrc; then # grepオプション -F は固定文字列での検索を指定
  # すでに.profileにカスタムprofileがある場合はセットアップ済みとして終了
  echo ".bashrc already setup(added source function)"
  exit 0
fi

#### source function
readonly INSERT_SOURCE_COMMAND_="$(
cat - <<EOL

# source by my profile
if [ -f "${MY_BASHRC_PATH_}" ]; then
  source "${MY_BASHRC_PATH_}"
fi

#


EOL
)"

### add function

echo "${INSERT_SOURCE_COMMAND_}" >> $HOME/.bashrc
echo "" >> $HOME/.bashrc

