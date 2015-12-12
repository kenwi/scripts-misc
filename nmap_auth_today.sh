#!/bin/bash

# Uses the failed_auth_today.sh script to nmap them

nmap $@ `sh ~/repos/scripts-misc/failed_auth_today.sh`

