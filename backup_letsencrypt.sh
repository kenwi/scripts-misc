#!/bin/bash

# Create directory and mysql owncloud backup

date=$(date +"%Y%m%d")
backup_src="/etc/letsencrypt"
backup_dst="/var/backups"
backup_name="backup_letsencrypt_${date}.tar"

# Create uncompressed tar archive
echo "Creating backup: ${backup_dst}/${backup_name}"
tar cvf "${backup_dst}/${backup_name}" "${backup_src}"
