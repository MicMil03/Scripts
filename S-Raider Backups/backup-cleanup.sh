#!/bin/bash

# This will backup the Thunder drive to RaidNAS, and perform cleanup on the backup.
# 10/18/16 Mike Miller
# Edited MM 1/19/16

logfile=/var/log/thunder-backup.log

# Create log file if it doesn't exist
touch $logfile

# Mount the Backup share on RaidNAS
date +"%m/%d/%Y %H:%M:%S Connecting to Backup share..." > $logfile
mkdir /Volumes/Backup
mount -t smbfs "//workgroup;user:password@raidnas.glenbard.org/Backup" /Volumes/Backup
if [ -e /Volumes/Backup ] ; then
	date +"%m/%d/%Y %H:%M:%S Connected to backup share." > $logfile
else
	date +"%m/%d/%Y %H:%M:%S Backup failed! Can't connect to backup share." > $logfile
	exit 1
fi

# Backup all department shares, and clear old files that have been deleted or moved.
if [ -e /Volumes/Backup ] ; then
	date +"%m/%d/%Y %H:%M:%S Starting backup and clearing old files..." > $logfile
	rsync -a --delete /Volumes/Thunder/Art /Volumes/Backup
	date +"%m/%d/%Y %H:%M:%S Art Backup complete." >> $logfile	
	rsync -a --delete /Volumes/Thunder/AV /Volumes/Backup
	date +"%m/%d/%Y %H:%M:%S AV Backup complete." >> $logfile
	rsync -a --delete /Volumes/Thunder/DeployStudio /Volumes/Backup
	date +"%m/%d/%Y %H:%M:%S DeployStudio Backup complete." >> $logfile
	rsync -a --delete /Volumes/Thunder/Guidance /Volumes/Backup
	date +"%m/%d/%Y %H:%M:%S Guidance Backup complete." >> $logfile	
	rsync -a --delete /Volumes/Thunder/Science /Volumes/Backup
	date +"%m/%d/%Y %H:%M:%S Science Backup complete." >> $logfile	
	rsync -a --delete /Volumes/Thunder/Spanish123 /Volumes/Backup
	date +"%m/%d/%Y %H:%M:%S Spanish123 Backup complete." >> $logfile	
	rsync -a --delete /Volumes/Thunder/SpanishAP /Volumes/Backup
	date +"%m/%d/%Y %H:%M:%S SpanishAP Backup Complete." >> $logfile
	date +"%m/%d/%Y %H:%M:%S All Backups Completed. Unmounting Backup Share..." >> $logfile	
	umount /Volumes/Backup
else
	date +"%m/%d/%Y %H:%M:%S Backup failed! Can't connect to backup share." > $logfile
	exit 1
fi

exit 0