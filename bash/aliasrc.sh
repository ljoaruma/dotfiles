#!/bin/bash

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias loopbell='for i in $(seq 0 6); do tput bel; sleep 0.8; done'

alias ..='cd ..'

alias pn='dirs -v -l'
alias p1='pushd +1'
alias p2='pushd +2'
alias p3='pushd +3'
alias p4='pushd +4'
alias p5='pushd +5'
alias p6='pushd +6'
alias p7='pushd +7'
alias p8='pushd +8'
alias p9='pushd +9'

alias pback='pushd "${OLDPWD}"'

alias rsyncn='rsync -avhsn --stats --progress'
alias rsynca='rsync -avhs --stats --progress'
alias rsynca_inlog='rsync -avhs --stats --progress --log-file-format="%i %o %l/%b %M %f %L"'

# bash_completionの関数呼び出しで補完機能追加
if declare -f | grep -q -e "\<_completion_loader\>" > /dev/null 2>&1; then

  function __rsync_alias_completion() {

    if ! complete -p rsync > /dev/null 2>&1; then

      _completion_loader "rsync"
      if ! complete -p rsync > /dev/null 2>&1; then
        return
      fi

      return

    fi

    complete -F $( \
      complete -p rsync | while read -a comps; do \
        echo "${comps[@]:$((${#comps[@]} - 2)):1}"; \
      done \
    ) -o nospace rsyncn rsynca rsynca_inlog

  }

  complete -F __rsync_alias_completion -o nospace rsyncn rsynca rsynca_inlog

fi

