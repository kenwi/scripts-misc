#!/bin/bash

# Pull todays unique ip-addresses from failed ssh attempts in auth.log 

LOGFAIL=$(grep -E "$(LANG=en_US date '+^%b %e')"'.*Failed' /var/log/auth.log)
IP=$(echo $LOGFAIL | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | sort -u)
echo $IP
 
