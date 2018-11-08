# switch_nas.sh
Simple bash script that moves my plex server from one freenas server to another. Basic error checking.

# backup_plexnas.sh
rsync backup script to keep two FreeNAS servers in sync. I choose rsync as opposed to FreeNAS replication because I want my backup FreeNAS server to be mounted read/write as I have a backup Plex server actively utilizing the backup FreeNAS server.

# push.sh
Simple script to call to send pushbullet notifications.

# drive_temp.sh
Monitors drive temps via smartctl and send both and email and pushbullet alert when drives exceed a setc temp. I run this in a cron every 10 minutes and once per night I remove the touchfile (/root/scripts/hd_temp_alert_sent) so that I will get an alert at least once per day if the drives are overtemp. Make necessary changes to your email address, etc. Assumes that your server has sendmail and it is configured to send outbound email. Also assume you have smartctl and curl installed and configured. Also assumes that you are using my push.sh script above as well.

# proxmox_zfs_smart_report.sh
Script used on my FreeNAS servers to monitor ZFS and SMART information. I modified it for us on Linux systems, mostly my Proxmox servers running on top of ZFS. Original script can be found at forums.freenas.org.

# drive_temp_proxmox.sh
Drive temp script to report excessive drive temps on Proxmox servers. Drives to monitor are set manually in the script and should be SATA only. SSD and SAS do not report drive temps correctly for this script.

# check_firewall_status
Super simple script to check the output of iptables -L, search for a specific string (like a server name or ip),
count the occurances of that string and send a warning via pushbullet (free) if it is not found which (in my case)
means something happened to the firewall. Will only alert ONCE so you don't get spammed everytime you run the script. 
I run it every 5 minutes from cron:

*/5 * * * * /root/check_firewall_status >/dev/null 2>&1

 Reloads a saved rules file from the /etc/iptables/emer directory,
 this can be changed to suite your needs. Enjoy
