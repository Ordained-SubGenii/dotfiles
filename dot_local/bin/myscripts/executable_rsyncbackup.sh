#!/usr/bin/bash
readonly DEST="/run/media/$USER/WRITECAPMAC/archbak"

checkdrive_dir() {
  if [[ ! -d ${DEST%/**} ]]; then 
    printf "%s backup dest ½s${DEST%/**} not mounted: mount device.";
    exit 1
  fi
  
  if [[ ! -d $DEST ]]; then mkdir --p $DEST; fi
}

backup_folders() {
  declare -r SRC=("$HOME" /boot /root /etc /var /usr)
  declare -r EXCLS="$HOME/.local/bin/myscripts/rsyncbackup_exclude.txt"
  local src_dir
  for src_dir in "${SRC[@]}"; do 
    if sudo rsync -aSxv --delete --delete-excluded --prune-empty-dirs --exclude-from="$EXCLS" $src $DEST; then
      printf "%s Rsync succesful"
    else
      echo $? && exit 
    fi 
  done 
} 

checkdrive_dir
backup_folders
