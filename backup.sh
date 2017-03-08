#! /bin/bash
set -eux

function getBackupStyle() {
  BACKUP_STYLE=''
  TODAY=$(date +%d)

  if [[ $TODAY -eq '7' ]]; then
    BACKUP_STYLE='full'
  elif [[ -z $(find . -regex './l1backup_[0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9].tar' -mtime -7 2> /dev/null) ]]; then
    BACKUP_STYLE='full'
  else
    BACKUP_STYLE='diff'
  fi
}

# main
cd /mnt || exit
getBackupStyle
echo $BACKUP_STYLE
