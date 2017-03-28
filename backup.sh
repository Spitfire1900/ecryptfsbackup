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
  elif [[ -z $(find . -regex './l1backup_[0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9].tar' -mtime -7 2> /dev/null) ]]; then
    BACKUP_STYLE='full'
    readonly BACKUP_STYLE
  else
    BACKUP_STYLE='diff'
    readonly BACKUP_STYLE
  fi
  echo $BACKUP_STYLE
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
