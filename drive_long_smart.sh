#!/bin/bash

# Simple script to launch a SMART LONG test on system drives
# Designed to be run by a cron job twice per month

smartctl=/usr/sbin/smartctl


#Set your drives here
drives="sda sdb sdc sdd sde sdf"

for drive in $drives
do
smartctl --quietmode=silent --test=long /dev/${drive}
done
