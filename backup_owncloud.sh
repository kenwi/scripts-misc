#!/bin/bash

# Create directory and mysql owncloud backup

date=$(date +"%Y%m%d")

read -sp "Enter MySQL password: " mysql_password

backup_src="/var/www/owncloud"
backup_dst="/var/backups"
backup_name="owncloud-backup_${date}.tar"

# Create uncompressed tar archive
echo "Creating backup: ${backup_dst}/${backup_name}"
tar cvf "${backup_dst}/${backup_name}" "${backup_src}"

# Dump the db to same directory as owncloud
echo "Dumping database: ${backup_src}/mysqldump_owncloud_${date}.sql"
mysqldump --lock-tables -h localhost -u root "-p${mysql_password}" mysql > "${backup_src}/mysqldump_owncloud_${date}.sql"

# Update archive with db dump
echo "Updating archive with database dump"
tar uvf "${backup_dst}/${backup_name}" "${backup_src}/mysqldump_owncloud_${date}.sql"

# And remove the dump
echo "Removing database dump"
rm "${backup_src}/mysqldump_owncloud_${date}.sql"
