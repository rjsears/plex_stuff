#!/bin/bash

# Script to switch Cinaplex server from plexnas to plesnasii in the event
# of failure or maintenance. And to switch it back again when you are done.
#
# 2017/07/28 - Richard J. Sears - richard@sears.net
<<<<<<< HEAD
#
# 2017/08/31 - Added remote pausing/unpausing of nzbget activity since my media server only
#              talks to my primary freenas server.

=======
>>>>>>> 2afc5019ebc5b61a4a400a0c8ad8299837a54491

people_watching=`ps aux | grep plex | grep Transcoder | wc -l`
is_plexnas_mounted=`mount | grep "plexnas:/mnt/vol1/media on /mount/media type nfs" | wc -l`
is_plexnasii_mounted=`mount | grep "plexnasii:/mnt/vol1/media on /mount/media type nfs" | wc -l`


red='\033[0;31m'
green='\033[0;32m'
nc='\033[0m'


plexnasii() {
if [ $is_plexnas_mounted = 1 ]  
then
	echo
	echo
	echo "This Script will do the following:"
	echo -e "   1) ${red}Shutdown${nc} the Plex Media Server"
<<<<<<< HEAD
	echo -e "   2) ${red}Pause${nc} all media processing on Bender"
	echo -e "   3) ${red}Unmount${nc} /mount/media from PLEXNAS"
	echo -e "   4) ${green}Mount${nc} /mount/media from PLEXNAS-II (backup freenas server)"
	echo -e "   5) ${green}Restart${nc} the Plex Media Server"
=======
	echo -e "   2) ${red}Unmount${nc} /mount/media from PLEXNAS"
	echo -e "   3) ${green}Mount${nc} /mount/media from PLEXNAS-II (backup freenas server)"
	echo -e "   4) ${green}Restart${nc} the Plex Media Server"
>>>>>>> 2afc5019ebc5b61a4a400a0c8ad8299837a54491
	echo
	echo -e "It appears that there are ${red}$people_watching${nc} people watching Plex right now." 
	echo

	echo -e -n "Are you ${red}SURE${nc} you want to do this? [${green}Y${nc}/${red}N${nc}]  "
	read -n 1 -r
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		echo
		/usr/sbin/service plexmediaserver stop
		echo "Plex Media Server - STOPPED"
<<<<<<< HEAD
		ssh root@bender /opt/nzbget/nzbget -P
		echo "Bender Media Processing - PAUSED"
		/bin/umount -f -l /mount/media
=======
		/bin/umount /mount/media
>>>>>>> 2afc5019ebc5b61a4a400a0c8ad8299837a54491
		echo "/mount/media unmounted from Plexnas"
		/bin/mount plexnasii:/mnt/vol1/media /mount/media
		echo "/mount/media now mounted to Plexnas-ii /mnt/vol1/media"
		/usr/sbin/service plexmediaserver start
    		echo "Plex Media Server - STARTED -  Please verify proper operation"
    		echo
    		echo "Operation Complete - You may perform maintenance on PlexNAS."
    		echo
	else
    		echo
    		echo
    		echo -e "${red}OPERATION CANCELLED${nc}"
	fi
else
    echo
    echo -e "** ${red}WARNING${nc} **${red} WARNING${nc} ** ${red}WARNING${nc} **"
    echo   "PlexNAS does not appear to be mounted right now:"
    echo   "Please check your configuration and try again."
    echo
fi
}


plexnas() {
if [ $is_plexnasii_mounted = 1 ]  
then
	echo
	echo
	echo "This Script will do the following:"
	echo -e "   1) ${red}Shutdown${nc} the Plex Media Server"
	echo -e "   2) ${red}Unmount${nc} /mount/media from PLEXNAS-II"
	echo -e "   3) ${green}Mount${nc} /mount/media from PLEXNAS (primary freenas server)"
	echo -e "   4) ${green}Restart${nc} the Plex Media Server"
<<<<<<< HEAD
	echo -e "   5) ${green}Unpause${nc} all media processing on Bender"
=======
>>>>>>> 2afc5019ebc5b61a4a400a0c8ad8299837a54491
	echo
	echo -e "It appears that there are ${red}$people_watching${nc} people watching Plex right now." 
	echo

	echo -e -n "Are you ${red}SURE${nc} you want to do this? [${green}Y${nc}/${red}N${nc}]  "
	read -n 1 -r
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		echo
		/usr/sbin/service plexmediaserver stop
		echo "Plex Media Server - STOPPED"
<<<<<<< HEAD
		/bin/umount -f -l /mount/media
		echo "/mount/media unmounted from Plexnas-ii"
		/bin/mount /mount/media
		echo "/mount/media now mounted to Plexnas /mnt/vol1/media"
		/usr/sbin/service plexmediaserver start
    		echo "Plex Media Server - STARTED -  Please verify proper operation"
		ssh root@bender /opt/nzbget/nzbget -U
		echo "Bender Media Processing - UNPAUSED"
    		echo
    		echo "Operation Complete - PlexNAS is once again the primary NAS."
=======
		/bin/umount /mount/media
		echo "/mount/media unmounted from Plexnas"
		/bin/mount plexnas:/mnt/vol1/media /mount/media
		echo "/mount/media now mounted to Plexnas-ii /mnt/vol1/media"
		/usr/sbin/service plexmediaserver start
    		echo "Plex Media Server - STARTED -  Please verify proper operation"
    		echo
    		echo "Operation Complete - You may perform maintenance on PlexNAS."
>>>>>>> 2afc5019ebc5b61a4a400a0c8ad8299837a54491
    		echo
	else
    		echo
    		echo
    		echo -e "${red}OPERATION CANCELLED${nc}"
	fi
else
    echo
    echo -e "** ${red}WARNING${nc} **${red} WARNING${nc} ** ${red}WARNING${nc} **"
    echo   "PlexNAS-II does not appear to be mounted right now:"
    echo   "Please check your configuration and try again."
    echo
fi
}

help() {
echo
echo "This script is designed to switch which FreeNAS server the Cinaplex server"
echo "is using to get it's media files. Both Plexnas (primary) and Plexnasii"
echo "(backup) have exact copies of all Plex media files on them so if we need"
<<<<<<< HEAD
echo "to do maintenance on the primary NAS server (reboot it, etc) we can utilize"
=======
echo "to do maintenance on the primary server (reboot it, etc) we can utilize"
>>>>>>> 2afc5019ebc5b61a4a400a0c8ad8299837a54491
echo "this script to shut down Plex, unmount the primary server, mount the backup"
echo "server and restart Plex. At that point you can do all of the maintenance"
echo "needed on the primary server."
echo
echo "Once the maintenance has been completed, you simply run the script again"
echo "with the name of the primary server and the script switches everything back"
echo "again."
echo
echo "This script will shut down Plex and kick anyone watching anything off, so it"
echo "queries the system for how many users are on Plex and gives you that info"
echo "prior to shutting down Plex."
echo
echo
}


case "$1" in 
    plexnas)   plexnas ;;
    plexnasii)    plexnasii ;;
    help)    help ;;
    *) echo "usage: $0 [plexnas | plexnasii | help]" >&2
       exit 1
       ;;
esac
