#!/bin/bash

# Create directory backup and mysql backup of owncloud
# Script should be symlinked or copied to /var/www

date=$(date +"%Y%m%d")
owncloud="owncloud-dir_"$date
mysql="owncloud-sql_"$date

read -sp "Enter MySQL password: " mysql_password

if [[ ! -e $owncloud ]]; then
	mkdir $owncloud
	cd owncloud
	
	rsync -Aaxv . ../$owncloud/
	cd ..
fi

cd $owncloud
mysqldump --lock-tables -h localhost -u root -p$mysql_password mysql > $mysql.bak
tar -v -czf ../$owncloud.tar.gz .
cd ..
rm -rf $owncloud
