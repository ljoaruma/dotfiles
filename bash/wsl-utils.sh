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
    pushd .
    wslcd "$1"
    #local onwslpath=$(wslpath "$1")
    #echo "$1 -> ${onwslpath}"
    #if [[ -f "${onwslpath}" ]]; then
    #  onwslpath="$(dirname "${onwslpath}")"
    #  echo "${onwslpath}"
    #fi

    #pushd "${onwslpath}"
  }

  export -f wslpush

  # net use コマンドからネットワークドライブ情報を取得
  function __network_drives () {
    type net.exe &> /dev/null || exit 0
    net.exe use | awk '$0~/^OK/ { printf "%s\t%s\n", $2, $3 } '
  }

  # ネットワークドライブテーブル
  # キー文字列 ネットワークドライブ文字(ex. Y: )
  declare -A __WSL_NETWORK_DRIVE=()

  # net useコマンドから取得したネットワークドライブ情報をテーブルへ格納
  function __init_networkdrive_mapping() {

    __WSL_NETWORK_DRIVE=()

    local __device=""
    local __mount_point=""
    while IFS=$'\t' read -r __device __mount_point; do
      __WSL_NETWORK_DRIVE["${__device}"]="${__mount_point}"
    done < <( __network_drives)

  }

  # mount コマンドからwslがマウントしたドライブ情報取得
  # 対象とするのは、type 9pでマウントしたドライブで、'\'を含む列
  function __mount_drives () {
    mount | grep "type 9p" | grep '\\' | sed 's|^\([^[:blank:]]*\)[[:blank:]]\+on[[:blank:]]\+\([^[:blank:]].*[^[:blank:]]\)[[:blank:]]\+type 9p[[:blank:]]\+.*$|\1\t\2|g'
  }

  # WSLがマウントしたドライブ情報テーブル
  # キー文字列 ドライブ文字(\マークまで)(ex. C:\ )
  declare -A __WSL_MOUNT_TABLE

  # mountコマンドから取得したドライブ情報をテーブルへ格納
  function __init_mount_mapping() {

    __WSL_MOUNT_TABLE=()

    local __device=""
    local __mount_point=""
    while IFS=$'\t' read -r __device __mount_point; do
      __WSL_MOUNT_TABLE["${__device}"]="${__mount_point}"
    done < <( __mount_drives)

  }

  
  # 文字列がWindows上のパスか判定する
  function __is_winpath() {

    if [[ $# -lt 1 ]]; then
      return 1
    fi

    ## 先頭がスラッシュのケースや、'./'のケースはLinuxパスと判定する

    if [[ "/" = "${1:0:1}" ]]; then
      return 127
    fi

    if [[ "./" = "${1:0:2}" ]]; then
      return 127
    fi

    ## 先頭3文字がマウントしているドライブ文字であれば、Windowsパスと判定する

    local -u __INPUT_DIRVE_NAME="${1:0:3}"
    #echo "${__INPUT_DIRVE_NAME}"

    if [[ ! -z "${__WSL_MOUNT_TABLE["${__INPUT_DIRVE_NAME}"]}" ]]; then
      return 0
    fi

    ## スラッシュを含まず、円マークを含む場合は、Windowsパスと判定する
    if [[ ! "$1" = */* ]] && [[ "$1" = *\\* ]]; then
      return 0
    fi

    # とりあえず上記以外はLinuxパスとしておく

    return 126

  }

  function wslcd() {
    if __is_winpath "$1"; then
      local onwslpath="$(wslpath "$1")"
    else
      local onwslpath="$1"
    fi

    echo "$1 -> ${onwslpath}"
    if [[ -f "${onwslpath}" ]]; then
      echo -n "${onwslpath} -> "
      onwslpath="$(dirname "${onwslpath}")"
      echo "${onwslpath}"
    fi

    cd "${onwslpath}"
	}

  export -f wslcd

  function smbpath() {

    if __is_winpath "$1"; then
      local onwslpath="$(wslpath -a "$1")"
    else
      local onwslpath="$1"
    fi

    linked_name="$(readlink -f "${onwslpath}")"
    if [[ -f "${onwslpath}" ]]; then
      local -r abs_wsl_path="$(cd "$(dirname "${linked_name}")" && pwd -P)/$(basename "${linked_name}")"
    else
      local -r abs_wsl_path="$(cd "${linked_name}" && pwd -P)"
    fi

    #if __is_winpath "$1"; then
    #  local __winpath="$1"
    #else
    #  local __winpath="$(wslpath -w "$1")"
    #fi

    #local -u __win_drive2="${__winpath:0:2}"
    #local -u __win_drive3="${__winpath:0:3}"

    #if [[ -z ${__WSL_NETWORK_DRIVE["__win_drive2"]} ]]; then
    #  echo "no samba path: $1" >&2
    #  return 1
    #fi

    echo "${abs_wsl_path}" |
    sed \
      -e 's|/mnt/y/|/data/garbages/|g' \
      -e 's|/mnt/w/|/data/datas/|g' \
      -e 's|/mnt/x/|/data/musics/|g'
  }

  export -f smbpath

  __init_networkdrive_mapping
  __init_mount_mapping

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

