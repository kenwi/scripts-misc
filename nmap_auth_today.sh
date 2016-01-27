#!/bin/bash

# Uses the failed_auth_today.sh script to nmap them. Forwards normal nmap arguments
# Usage example repos/scripts-misc/faile_auth_today.sh -F -v

nmap $@ $(sh ~/repos/scripts-misc/failed_auth_today.sh)

