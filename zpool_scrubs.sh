#!/bin/bash
# Quick script to run via cron to launch system scrubs on ZFS filesystems.
# Once started they will run in the background until completed.

# I use the "proxmox_zfs_smart_report.sh" script in conjunction with this script setting
# it to run the day after my scrubs.

# Script expects to be able to record its progress in a /root/logs directory.

export PATH=/usr/sbin:/usr/bin:/bin:/sbin
LOG=/var/log/scrubs/`date +20\%y\%m\%d\%H\%M`-scrubs.log
zpool list -H -o name | while read pool; do

# If a scrub is already running, then don't try and start a second one (because you can't!)
 if zpool status -v $pool | grep -q "scrub in progress"; then
 echo "Can't scrub pool "$pool" -scrub already running!" >> $LOG 2>&1
 exit
 else
 echo "Scrubbing pool "$pool >> $LOG 2>&1
 zpool scrub $pool
 fi

done
echo "Script took $SECONDS seconds to complete (scrubs run for hours in background!)." >> $LOG 2>&1
exit 0
