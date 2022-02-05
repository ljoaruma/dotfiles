#!/bin/bash
# vim: set expandtab ts=2 fenc=utf-8 ff=unix filetype=bash :

if [[ ! -v HOME ]]; then
  echo "no environment HOME"
  exit 1
fi

readonly _SETUP_SOURCE="${BASH_SOURCE:-$0}"
readonly _SETUP_SCRIPT_NAME="$(basename "${_SETUP_SOURCE}")"
readonly _SOURCE_DIRECTORY="$(cd "$(dirname "${_SETUP_SOURCE}")" && pwd)"

readonly _FULLPATH_SOURCE_DIRECTORY="${_SOURCE_DIRECTORY/#${HOME}/\$\{HOME%/\}}"
echo "${_FULLPATH_SOURCE_DIRECTORY}"

function ProfileSetup() {
  local -r _PROFILE="${HOME}/.profile"
  local -r _INSERT_PROFILE="profile/profile"
  local -r _FULLPATH_PROFILE_SOURCE_DIRECTORY="${_SOURCE_DIRECTORY/#${HOME}/\$\{HOME\}}"

  if [[ ! -e ${_PROFILE} ]]; then
    return
  fi

  local -r _INSERT_PROFILE_COMMAND="$(
cat - <<EOL

# source by my profile
if [ -f "$_FULLPATH_PROFILE_SOURCE_DIRECTORY/$_INSERT_PROFILE" ]; then
  . "$_FULLPATH_PROFILE_SOURCE_DIRECTORY/$_INSERT_PROFILE"
fi
EOL
)"

  echo "${_INSERT_PROFILE_COMMAND}" >> "${_PROFILE}"
  # 末尾に改行のみの行追加
  echo >> "${_PROFILE}"

}

function BashrcSetup() {
  local -r _BASHRC="${HOME}/.bashrc"
  local -r _INSERT_BASHRC=bash/bashrc

  if [[ ! -e "${_SETUP_SOURCE}" ]]; then
    echo "not found ${_SETUP_SOURCE}"
    exit 1
  fi

  if [[ ! -d "${_SOURCE_DIRECTORY}" ]]; then
    echo "not found ${_SOURCE_DIRECTORY}"
    exit 1
  fi

  local -r _INSERT_SOURCE_COMMAND=$(cat <<EOL

if [[ -f "${_FULLPATH_SOURCE_DIRECTORY}/${_INSERT_BASHRC}" ]]: then
  source "${_FULLPATH_SOURCE_DIRECTORY}/${_INSERT_BASHRC}"
fi
EOL
  )

  if [[ ! -f "${_BASHRC}" ]]; then
    touch "${_BASHRC}" && \
    chmod 644 "${_BASHRC}" && \
    echo "${_INSERT_SOURCE_COMMAND}" >> "${_BASHRC}"

    exit
  fi

  if grep -q -F "${_FULLPATH_SOURCE_DIRECTORY}" "${_BASHRC}" &> /dev/null; then
    exit 0
  fi

  local -r _BASHRC_ORG="${_BASHRC}.org"
  cp -p --backup=t "${_BASHRC}" "${_BASHRC_ORG}"

# HISTFILESIZEが設定されると履歴ファイルが切り詰められるのでそこだけ元のファイルからコメントアウト
  sed \
    -e 's/^[[:blank:]]*\(export[[:blank:]]\+\)\?HISTFILESIZE=[0-9]\+[[:blank:]]*\(.*\)*$/#\0/g' \
    -e 's/^\([[:blank:]]*[^#].*\)\<export[[:blank:]]\+HISTFILESIZE=[0-9]*\([^0-9].*\)\?$/\1:\2/g' \
    -e 's/^\([[:blank:]]*[^#].*\)\<HISTFILESIZE=[0-9]*\([^0-9].*\)\?$/\1:\2/g' \
    "${_BASHRC_ORG}" > \
    "${_BASHRC}"

  echo "${_INSERT_SOURCE_COMMAND}" >> "${_BASHRC}"
  # 末尾に改行のみの行追加
  echo >> "${_BASHRC}"

}

ProfileSetup
BashrcSetup

