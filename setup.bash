#!/bin/bash

if [[ ! -v HOME ]]; then
  echo "no environment HOME"
  exit 1
fi

readonly _SETUP_SOURCE="${BASH_SOURCE:-$0}"
readonly _SETUP_SCRIPT_NAME="$(basename "${_SETUP_SOURCE}")"
readonly _SOURCE_DIRECTORY="$(cd "$(dirname "${_SETUP_SOURCE}")" && pwd)"

readonly _FULLPATH_SOURCE_DIRECOTYR="${_SOURCE_DIRECTORY/#${HOME}/\$\{HOME\}}/${_SETUP_SCRIPT_NAME}"
echo "${_FULLPATH_SOURCE_DIRECOTYR}"

readonly _BASHRC="${HOME}/.bashrc"

if [[ ! -e "${_SETUP_SOURCE}" ]]; then
  echo "not found ${_SETUP_SOURCE}"
  exit 1
fi

if [[ ! -d "${_SOURCE_DIRECTORY}" ]]; then
  echo "not found ${_SOURCE_DIRECTORY}"
  exit 1
fi

readonly _INSERT_SOURCE_COMMAND=$(cat <<EOL
if [[ -f "${_FULLPATH_SOURCE_DIRECOTYR}" ]]: then
  . "${_FULLPATH_SOURCE_DIRECOTYR}"
fi
EOL
)

if [[ ! -f "${_BASHRC}" ]]; then
  touch "${_BASHRC}" && \
  chmod 644 "${_BASHRC}" && \
  echo "${_INSERT_SOURCE_COMMAND}" >> "${_BASHRC}"

  exit
fi

if grep -q -F "${_FULLPATH_SOURCE_DIRECOTYR}" "${_BASHRC}" &> /dev/null; then
  exit 0
fi

readonly _BASHRC_ORG="${_BASHRC}.org"
cp -p --backup=t "${_BASHRC}" "${_BASHRC_ORG}"

# HISTFILESIZEが設定されると履歴ファイルが切り詰められるのでそこだけ元のファイルからコメントアウト
sed \
  -e 's/^[[:blank:]]*\(export[[:blank:]]\+\)\?HISTFILESIZE=[0-9]\+[[:blank:]]*\(.*\)*$/#\0/g' \
  -e 's/^\([[:blank:]]*[^#].*\)\<export[[:blank:]]\+HISTFILESIZE=[0-9]*\([^0-9].*\)\?$/\1:\2/g' \
  -e 's/^\([[:blank:]]*[^#].*\)\<HISTFILESIZE=[0-9]*\([^0-9].*\)\?$/\1:\2/g' \
  "${_BASHRC_ORG}" >> \
  "${_BASHRC}"

echo "${_INSERT_SOURCE_COMMAND}" >> "${_BASHRC}"

