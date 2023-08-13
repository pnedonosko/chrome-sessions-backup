#!/bin/bash

logger "> Backing up Chrome config sessions"

# Ensure backup directory exists
BACKUP_DIR=~/backup/google-chrome/Default
[ ! -d "$BACKUP_DIR" ] && mkdir -p "$BACKUP_DIR"

cd $BACKUP_DIR
# First rotate previous backups (keep 5 last)
HISTORY_LENGTH=5 # Edit to check history length
rm -rf backup-${HISTORY_LENGTH}
for (( i=HISTORY_LENGTH-1; i>0; i-- )); do
	[ -d backup-${i} ] && mv -f backup-${i} backup-$((i+1))
done

# Copy Chrome's Default Sessions to the backup
mkdir -p backup-1/Sessions
cp -rf ~/.config/google-chrome/Default/Sessions backup-1

logger "< Chrome config sessions were backed up "

