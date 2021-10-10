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

  function wslcd() {
    local onwslpath=$(wslpath "$1")
    echo "$1 -> ${onwslpath}"
    if [[ -f "${onwslpath}" ]]; then
      onwslpath="$(dirname "${onwslpath}")"
      echo "${onwslpath}"
    fi

    cd "${onwslpath}"
	}
fi

