#!/bin/bash

if which wslpath > /dev/null 2>&1 ; then

  function wslpush() {
    #echo "echo"
    #echo "$1"
    #echo "printf%1"
    #printf "%q\n" "$1"
    #echo "wslpath"
    #wslpath "$1"
    #echo "wslpath printf%1"
    #wslpath $(printf "%q" "$1")
    #pushd "$(eval wslpath \'"$1"\')"
    #echo "pushd"
    #pushd "$(printf "%q" $(wslpath $(printf "%q", "$1")))"
    #pushd "$(wslpath $(printf "%q"  "$1" ))"
    #pushd "$(wslpath "${}")"
    local onwslpath=$(wslpath "$1")
    echo "$1 -> ${onwslpath}"
    if [[ -f "${onwslpath}" ]]; then
      onwslpath="$(dirname "${onwslpath}")"
      echo "${onwslpath}"
    fi

    pushd "${onwslpath}"
  }

  export -f wslpush

  function wslcd() {
    local onwslpath=$(wslpath "$1")
    echo "$1 -> ${onwslpath}"
    if [[ -f "${onwslpath}" ]]; then
      onwslpath="$(dirname "${onwslpath}")"
      echo "${onwslpath}"
    fi

    cd "${onwslpath}"
	}

  export -f wslcd

  function smbpath() {
    wslpath "$1" |
    sed \
      -e 's|/mnt/y/|/data/garbages/|g' \
      -e 's|/mnt/w/|/data/datas/|g' \
      -e 's|/mnt/x/|/data/musics/|g'
  }

  export -f smbpath

fi

#WIN_FFMPEG_INSTALL_DIR="$(wslpath 'C:\r\usr\ffmpeg\ffmpeg-4.4.1-full_build')"
WIN_FFMPEG_INSTALL_DIR="$(wslpath 'C:\r\usr\ffmpeg\ffmpeg-5.0-full_build')"

if [[ -x "${WIN_FFMPEG_INSTALL_DIR}/bin/ffmpeg.exe" ]]; then
  export WIN_FFMPEG_INSTALL_DIR

  function ffmpeg() {
    "${WIN_FFMPEG_INSTALL_DIR}/bin/ffmpeg.exe" "$@"
  }

  export -f ffmpeg

fi

if [[ -x "${WIN_FFMPEG_INSTALL_DIR}/bin/ffprobe.exe" ]]; then
  export WIN_FFMPEG_INSTALL_DIR

  function ffprobe() {
    "${WIN_FFMPEG_INSTALL_DIR}/bin/ffprobe.exe" "$@"
  }

  export -f ffprobe

fi

if ! declare -p WIN_FFMPEG_INSTALL_DIR | grep -q 'declare[[:blank:]]\+-[[:alpha:]]*x' > /dev/null; then
  unset WIN_FFMPEG_INSTALL_DIR
fi

# Windows Terminalでカレントディレクトリの引き継ぎ OSC 9;9

if [[ ! -v TMUX ]]; then

  function _windows_terminal_osc_9_9 {
      # Inform Terminal about shell current working directory
      # see: https://docs.microsoft.com/en-us/windows/terminal/tutorials/new-tab-same-directory
      #      https://github.com/microsoft/terminal/issues/8166
      #      https://github.com/microsoft/terminal/issues/3158
      printf "\e]9;9;%s\e\\" "$(wslpath -w "$(pwd)")"
  }

  PROMPT_COMMAND="${PROMPT_COMMAND:+"${PROMPT_COMMAND};"}_windows_terminal_osc_9_9"

fi

