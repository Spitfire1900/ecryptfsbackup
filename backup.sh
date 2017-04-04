#! /bin/bash
set -eux

function diffBackup() {
  DATE=$(date +%d-%m-%Y)
  sudo sh -c 'nice -n +19 tar -rvpf /mnt/backup2.tar --exclude=/mnt --exclude=/home/[!.]*/*[!.ecryptfs][!.Private]* --one-file-system /'
}

function fullBackup() {
  DATE=$(date +%d-%m-%Y)
  sudo sh -c 'nice -n +19 tar -cvpf /mnt/backupefi.tar -g /mnt/backupefi.snar /boot/efi 2> backupefi.err; nice -n +19 tar -cvpf /mnt/ecryptfssymlinks.tar /home/[!.]*/.Private /home/[!.]*/.ecryptfs  2> /mnt/ecryptfssymlinks.err; nice -n +19 tar -cvpf /mnt/l1backup_$(date +%d-%m-%Y).tar -g /mnt/l1backup.snar --exclude=/mnt --exclude=/home/[!.]*/*[!.ecryptfs][!.Private]* --one-file-system / 2> l1backup.err'
}

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

# main
cd /mnt || exit
BACKUP_STYLE=$(getBackupStyle)
echo $BACKUP_STYLE
