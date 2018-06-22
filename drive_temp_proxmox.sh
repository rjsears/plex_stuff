#!/bin/bash

## Drive Temp Alert script for use on Proxmox servers

# Specify your email address here:
email="your_email@gmail.com"
logfile="/tmp/hd_temp_report.tmp"
smartctl=/usr/sbin/smartctl
critTemp=45
subject="CRITIAL HD TEMP - PROXMOX SERVER"

#Set your drives here. DO NOT set SAS or SSD Drives here as they do not report temperature properly
#and the script will fail.
drives="sdf sde"

# Used with the Pushbullet (send.sh) script. You much sign up for free pushbullet account
send_pb_alert()
{
    /root/scripts/push.sh "PROXMOX HD TEMP ALERT" "Your Proxmox Server Hard Drives are HOT!"
    touch /root/scripts/hd_temp_alert_sent
}

# Your susyem must be configured to send mail already
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
     echo "There is a problem with the temperature on one or more hard drives on the Proxmox Server."
     echo ""
     echo "It is HIGHLY advisable that you relocate the servers to a cooler location before "
     echo "any of your hard drives are damaged!"
     echo ""
     echo ""
     echo "This is an automated email, please do not reply!"
     echo ""
     echo ""
     echo "You will only receive this email once per day. To immediately re-enable this alert, please ssh into the Proxmox "
     echo "server and remove this file:  "
     echo ""
     echo ""
     echo "        /root/scripts/hd_temp_alert_sent"
     echo ""
     echo ""
     echo " WARNING WARNING WARNING "
     echo " Failure to resolve this hard drive temperature issue can lead to failure of the server and all Virtual Machines!"
     echo ""
    ) >> ${logfile}

    echo "</pre>" >> ${logfile}
    sendmail ${email} < ${logfile}
    rm ${logfile}
    touch /root/scripts/hd_temp_alert_sent
}
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
