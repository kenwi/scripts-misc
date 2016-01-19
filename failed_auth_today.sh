#!/bin/bash

# Pull todays unique ip-addresses from failed ssh attempts in auth.log 

TODAY=`LANG=en_US date +"%b  %-d"`
LOGFAIL=`cat /var/log/auth.log | grep -i "$TODAY" | grep -i failed`
IP=`echo $LOGFAIL | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | sort -u`
echo $IP
