# plex_stuff
Some basic scripts that I use to manage my plex and freenas servers.

# switch_nas.sh
Simple bash script that moves my plex server from one freenas server to another. Basic error checking.

# backup_plexnas.sh
rsync backup script to keep two FreeNAS servers in sync. I choose rsync as opposed to FreeNAS replication because I want my backup FreeNAS server to be mounted read/write as I have a backup Plex server actively utilizing the backup FreeNAS server.

# push.sh
Simple script to call to send pushbullet notifications.

# check_external_ip.py
Python script that I run every few minutes to alert me if my external IP address has changed. Good for tracking firewall rules,
and other things that may rely on a specific known external ip address. It will then notify me via pushbullet (free) and email
of the new IP address.
