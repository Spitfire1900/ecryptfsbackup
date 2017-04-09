#! /bin/bash
set -eux

function getBackupStyle() {
  local BACKUP_STYLE
  local TODAY
  TODAY=$(date +%u)
  readonly TODAY

  if [[ $TODAY -eq '7' ]]; then
    BACKUP_STYLE='full'
    readonly BACKUP_STYLE
  elif [[ -z $(find . -maxdepth 1 -regex './[0-9][0-9][0-9]_l1backup_[0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9].tar' -mtime -7 2> /dev/null) ]]; then
    BACKUP_STYLE='full'
    readonly BACKUP_STYLE
  else
    BACKUP_STYLE='diff'
    readonly BACKUP_STYLE
  fi
  echo $BACKUP_STYLE
}

function getAverageBackupSize() {
  local BACKUPS; BACKUPS=$(find . -maxdepth 1 -regex './[0-9][0-9][0-9]_.*backup.*_[0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9].tar')
  declare -a BACKUP_SETS
  local i=0
  while [ $i -lt 1000 ]; do
    local iteration; iteration=$i
    if [ $iteration -lt 10 ]; then
      iteration=00$i
    elif [[ $iteration -lt 100  ]]; then
      iteration=0$i
    fi
    for f in $BACKUPS; do
      if [[ $f =~ .\/$iteration.* ]]; then
        if [[ -z  ${BACKUP_SETS[i]-} ]]; then
          BACKUP_SETS[$i]=''
        fi
        BACKUP_SETS[$i]=${BACKUP_SETS[i]}' '$f
      fi
    done
    i=$((i + 1))
  done
}

function cleanDisk() {
  local AVG_BACKUP_SIZE=$()
  # find . -regex './l1.*.tar' -exec du {} \; 2> /dev/null | awk '{print $1;}' | awk '{ total += $1; count++ }'
  echo ""
}

# main
cd /mnt || exit
BACKUP_STYLE=$(getBackupStyle)
echo $BACKUP_STYLE
