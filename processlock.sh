#!/bin/bash

#Inspired by https://github.com/obscuresec/CCDC/blob/master/Invoke-ProcessLock
#This script stops processes that are not already running from spawning on the system. It saves an array of running processes when it starts, then in a loop checks an updated current list against the starting list. If the script finds new processes, it will immediately try to kill them. 

containsElement () {
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && return 0; done
  return 1
}
silentKill () {
  kill -9 $1 2>/dev/null
}
safeproc=( $(ps -ef|awk '{print $2 }') )
echo "Current state captured, killing new processes..."
while true; do
  for pid in `ps -ef | awk '{print $2}'` ; do
    if containsElement $pid "${safeproc[@]}"
      then continue
      else silentKill $pid
    fi
  done
done
