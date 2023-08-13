#!/bin/bash

BACKUP_DIR=~/backup/google-chrome/Default/backup-1/Sessions
CHROME_DIR=~/.config/google-chrome/Default/Sessions
if [[ -d "$BACKUP_DIR" ]]; then
	logger "> Restoring the last Chrome config sessions from the backup $BACKUP_DIR" 
	# First save what exists currently in the Chrome
	rm -rf $CHROME_DIR.prev
	cp -rf $CHROME_DIR $CHROME_DIR.prev
	rm -rf $CHROME_DIR
	# Copy from the backup
	cp -rf $BACKUP_DIR $CHROME_DIR
else
	logger "> Unable to restore Chrome config sessions - backup not found in $BACKUP_DIR" 
fi

