#!/bin/bash
## Quick script to sent PB notifications from various scripts. You can get your free 
## accesstoken at pushbullet.

TITLE=${1}
MESSAGE=${2}
ACCESSTOKEN=o.vxxxxxxxxxxxxxxxxxxxxx

curl --header "Access-Token: ${ACCESSTOKEN}" --header 'Content-Type: application/json' --data-binary "{\"body\":\"${MESSAGE}\",\"title\":\"${TITLE}\",\"type\":\"note\"}" --request POST https://api.pushbullet.com/v2/pushes >> /dev/null
~                                                                                                                                                                                                                                              
~       
