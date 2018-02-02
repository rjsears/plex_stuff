#!/bin/bash

# Specify your email address here:
email="richard@sears.net"
logfile="/tmp/hd_temp_report.tmp"
smartctl=/usr/local/sbin/smartctl
critTemp=30
subject="CRITIAL HD TEMP - PHOENIX NAS"



send_pb_alert()
{
    /root/scripts/push.sh "Phoenix HD TEMP ALERT" "Your Phoenix Hard Drives are HOT!"
    touch /root/scripts/hd_temp_alert_sent
}


send_email_alert()
{
    ### Set email headers
    (
      echo "To: ${email}"
      echo "Subject: ${subject}"
      echo "Content-Type: text/html"
      echo "MIME-Version: 1.0"
      printf "\r\n"
    ) > ${logfile}

    ### Set email body ###
    echo "<pre style=\"font-size:14px\">" >> ${logfile}
    (
     echo "There is a problem with the temperature on one or more hard drives on your Phoenix FreeNAS Server."
     echo ""
     echo "It is HIGHLY advisable that you relocate the servers to a cooler location before "
     echo "any of your hard drives are damaged!"
     echo ""
     echo ""
     echo "This is an automated email, please do not reply!"
     echo ""
     echo ""
     echo ""
     echo "You will only receive this email once per day. To immediately re-enable this alert, please ssh into your Phoenix FreeNAS "
     echo "server and remove this file:  "
     echo ""
     echo ""
     echo "        /root/scripts/hd_temp_alert_sent"
     echo ""
     echo ""
     echo " WARNING WARNING WARNING "
     echo " Failure to resolve this hard drive temperature issue can lead to failure of the NAS and of Plex!!"
     echo ""
    ) >> ${logfile}

    echo "</pre>" >> ${logfile}
    sendmail ${email} < ${logfile}
    rm ${logfile}
    touch /root/scripts/hd_temp_alert_sent
}

get_smart_drives()
{
  gs_drives=$("${smartctl}" --scan | grep "dev" | awk '{print $1}' | sed -e 's/\/dev\///' | tr '\n' ' ')

  gs_smartdrives=""

  for gs_drive in $gs_drives; do
    gs_smart_flag=$("${smartctl}" -i /dev/"$gs_drive" | grep "SMART support is: Enabled" | awk '{print $4}')
    if [ "$gs_smart_flag" = "Enabled" ]; then
      gs_smartdrives=$gs_smartdrives" "${gs_drive}
    fi
  done

  eval "$1=\$gs_smartdrives"
}

drives=""
get_smart_drives drives

for drive in $drives
do
    (
drive_temp=`smartctl -a /dev/${drive} | awk '/Temperature_Celsius/{print $0}' | awk '{print $10}'`
if (( $drive_temp > $critTemp )); then
   echo $drive_temp
   if [ ! -e "/root/scripts/hd_temp_alert_sent" ]; then
      send_email_alert
      send_pb_alert
   else
      exit 1
   fi
else
echo $drive_temp
fi
    )
done
