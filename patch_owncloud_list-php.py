#!/usr/bin/python

"""
This script will find and locate the line with the string "$files = []", inject the hack for sorting 
files by dates descending and print the new text.
"""

import sys

find = "$files = []"
code = """
        // Hack for sorting (by date) my automatically uploaded files in the directory "Photos"
        if(strpos($_GET['dir'], 'Photos'))
        {
                $sortDirection = 'asc';
                $sortAttribute = 'mtime';
        }
"""
with open("/var/www/owncloud/apps/files/ajax/list.php") as file:
	for line in file:
		if find in line:
			sys.stdout.write(code)
		sys.stdout.write(line)
