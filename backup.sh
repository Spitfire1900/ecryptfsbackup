#! /bin/bash

function getBackupStyle() {
  BACKUP_STYLE=''
  DAY=$(date +%d)

  if [[ $DAY -eq '7' ]]; then
    BACKUP_STYLE='full'
  elif [[ $(find . -regex './l1backup_[0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9].tar' -mtime -7 2> /dev/null) ]]; then
    BACKUP_STYLE='full'
  fi
}

# main
cd /mnt || exit
echo $BACKUP_STYLE
