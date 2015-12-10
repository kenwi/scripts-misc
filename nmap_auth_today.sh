#!/bin/bash

# Uses the failed_auth_today.sh script to nmap them

nmap --top-ports 10 `sh repos/scripts-misc/failed_auth_today.sh`

