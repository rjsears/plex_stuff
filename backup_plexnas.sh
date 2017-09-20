#!/bin/bash
## Cron script tp transfer new files from plexnas to plaexnasii and to 
## notify our backup plex server (cinaplex-ii) if there are new files.
##
## Richard J. Sears 9/16/2017

## Hidden files on each system so we can test if they are mounted.
plexnas=/mount/media/.ismounted
plexnasii=/mount/plexnas-ii/.ismounted

## Plex token for Cinaplex-II needed to ask plex to refresh our libraries if needed
plex_token=xxxxxxxxxxxxxxxxxxxxxxxx

## Specific Plex URLs for requesting a library update to 1 (movies) and 2 (tv shows)
url="http://cinaplex2:32400/library/sections/1/refresh?X-Plex-Token=$plex_token"
url2="http://cinaplex2:32400/library/sections/2/refresh?X-Plex-Token=$plex_token"

## Here we make sure both plexnas and plexnasii are mounted otherwise
## we notify me via pushbullet by calling push.sh
## If everything is mounted correctly, then we run an rsync to sync our primary FreeNAS
## server with our backup FreeNAS server and if any files get copied then we update the
## library(ies) on our backup Plex server which utilizes our backup FreeNAS server.
## I do not have the --delete flag here although the way I call the script I could, but
## I choose to run anohter script by hand once a week with the --delete flag.

if [ ! -e "$plexnas" ] || [ ! -e "$plexnasii" ]; then
    echo "System Not Mounted"
    if [ ! -e "rsync_failed_alert_sent" ]; then
        /root/push.sh "Bender RSYNC FAILED" "Something is not mounted correctly!"
        touch /root/rsync_failed_alert_sent
    else
        exit 1
    fi
else
    FILES_TRANSFERRED="$(rsync -aAX --numeric-ids --progress --no-whole-file --inplace  --exclude=/.ismounted /mount/media/ /mount/plexnas-ii/ | wc -l)"
    echo "${FILES_TRANSFERRED}"
    if [[ "$FILES_TRANSFERRED" > 2 ]]; then
        wget -qO- $url &> /dev/null
        wget -qO- $url2 &> /dev/null
    else
        exit 1
    fi
fi
