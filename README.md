# plex_stuff
Some basic scripts that I use to manage my plex and freenas servers.

# switch_nas.sh
Simple bash script that moves my plex server from one freenas server to another. Basic error checking.

# backup_plex.sh
rsync backup script to keep two FreeNAS servers in sync. I choose rsync as opposed to FreeNAS replication because I want my backup FreeNAS server to be mounted read/write as I have a backup Plex server actively utilizing the backup FreeNAS server.
