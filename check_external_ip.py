#!/usr/bin/python
""" This script checks my external IP and notifies me of changes"""

from __future__ import print_function

# check_external_ip.py
# script to automate checking external ip address on my network
# and alert me via Pushbullet if it changes. Eventually it will link
# to external services on my other systems to automatically update.
__author__ = 'Richard J. Sears'
VERSION = "0.1 (2017-09-23)"
# richard@sears.net

# Are we running in debug mode?
DEBUG = True

# PushBullet API Key for notifications
pushbilletAPI = "o.xxxxxxxxxxxxxxxxxxxxxxxxxx"

# What is our Current External IP address?
# Replace 00.00.00.00 with your own external IP address
current_external_ip = "00.00.00.00"

import ipgetter
import os
from pushbullet import Pushbullet
import subprocess
import socket


# Setup to send email via the builtin linux mail command.
def send_email(recipient, subject, body):
      process = subprocess.Popen(['mail', '-s', subject, recipient],stdin=subprocess.PIPE)
      process.communicate(body)

# Quick check to see if we have internet access
def check_internet(host="8.8.8.8", port=53, timeout=3):
    try:
        socket.setdefaulttimeout(timeout)
        socket.socket(socket.AF_INET, socket.SOCK_STREAM).connect((host, port))
        return True
    except Exception as ex:
        return False

# Here is where we check our current external IP address.
def check_ip():
    global myip
    myip = ipgetter.myip()
    if DEBUG:
        print(myip)
    if myip != current_external_ip:
        if DEBUG:
            print("WARNING. Your External IP Address has changed!")
        send_ip_warning()
    else:
        if DEBUG:
            print("Everything looks good!")

# Here is where we send a warning if our IP address has changed.
def send_ip_warning():
    global myip
    pb = Pushbullet(pushbilletAPI)
    push = pb.push_note("Your External IP has Changed","Your new IP is %s" % myip)
    send_email('your_name@gmail.com', 'External IP Change', 'Your New External IP is %s' %myip)
    os.mknod("/root/check_external_ip/ip_alert_sent")


def main():
    if DEBUG:
        print("Starting check_external_ip.py")
    if os.path.isfile('/root/check_external_ip/ip_alert_sent'):
        if DEBUG:
            print("Bypassing, Alert Already Sent")
        pass
    else:
        internet_active = check_internet()
        if internet_active:
            check_ip()
        else:
            if DEBUG:
                print("Not detecting Internet access, quitting!")
            quit()


if __name__ == '__main__':
    main()
