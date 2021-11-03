#!/bin/bash

alias loopbell='for i in $(seq 0 6); do tput bel; sleep 0.8; done'

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

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

! readlink -f . &> /dev/null && which greadlink &> /dev/null && alias readlink='greadlink'

alias rsyncn='rsync -avhsn --stats --progress'
alias rsynca='rsync -avhs --stats --progress'
alias rsynca_inlog='rsync -avhs --stats --progress --log-file-format="%i %o %l/%b %M %f %L"'

#alias ps='ps o user,pid,pgid,nlwp,pcpu,pmem,vsz,rss,tty,nice,pri,stat,start_time,bsdtime,args'
alias proctree='\ps axfo user,pid,pgid,pcpu,pmem,vsz,rss,tty,nice,stat,lstart,cputime,etime,args'

#watch -n2 bash -c 'uptime; echo; ps aufww | grep -av -e '\''watch -n5 bash -c'\'' -e '\''ps aufww'\'''
# alias一行で書くと、エスケープの嵐でよく分からなくなってくるので、関数を介して実行する
#alias watch_pstree='watch -n2 '\''uptime; echo; ps afwwo user,pid,pcpu,pmem,tty,pri,stat,start_time,bsdtime,args | grep -v -e '\'\\\'\''[[:blank:]]\+-bash$'\'\\\'\'' -e '\'\\\'\''\<watch\>'\'\\\'
function __to_be_watch_pstree() {
  # 端末を持つプロセスから、以下を除いたプロセスツリー
  # watch
  # ps
  # ログインbash( -bash )
  # 本関数自信
  uptime
  ps afwwo user,pid,pcpu,pmem,nlwp,tty,nice,stat,lstart,cputime=CPUTIME,etime,args | \
  grep -v \
    -e '[[:blank:]]\+\\_[[:blank:]]\+\<watch\>' \
    -e '[[:blank:]]\+\\_[[:blank:]]\+\<ps\>' \
    -e '[[:blank:]]\+-bash\>$' \
    -e '[[:blank:]]\+\\_[[:blank:]]\+bash -c '"${FUNCNAME[0]}$"
}

export -f __to_be_watch_pstree
alias watch_pstree='watch -x -n2 bash -c __to_be_watch_pstree'

function __to_be_watch_ps() {
  # 端末を持つプロセスから、以下を除いたプロセス
  # watch
  # ps
  # ログインbash( -bash )
  # 本関数自信
  uptime
  ps awwo user,pid,pcpu,pmem,nlwp,tty,nice,stat,lstart,cputime=CPUTIME,etime,args | \
  grep -v \
    -e '[[:blank:]]\+\\_[[:blank:]]\+\<watch\>' \
    -e '[[:blank:]]\+\\_[[:blank:]]\+\<ps\>' \
    -e '[[:blank:]]\+-bash\>$' \
    -e '[[:blank:]]\+\\_[[:blank:]]\+bash -c '"${FUNCNAME[0]}$"
}

export -f __to_be_watch_ps
alias watch_ps='watch -x -n2 bash -c __to_be_watch_ps'

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

