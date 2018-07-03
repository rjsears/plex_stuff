#!/bin/bash

# Simple script to launch a SMART SHORT test on system drives
# Designed to be run by a cron job twice per month

smartctl=/usr/sbin/smartctl


#Set your drives here
drives="sda sdb sdc sdd sde sdf"

for drive in $drives
do
smartctl --quietmode=silent --test=short /dev/${drive}
done
