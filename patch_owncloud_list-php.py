#!/usr/bin/python

"""
This script will find and locate the line with the string "$files = []", inject the hack for sorting 
files by dates descending and print the new text.
"""

import sys

find = "$files = []"
code = """
        // Hack for sorting (by date) by automatically uploaded files in the directory "Photos"
        if(strpos($_GET['dir'], 'Photos'))
        {
                $sortDirection = 'asc';
                $sortAttribute = 'mtime';
        }
"""
with open("/var/www/owncloud/apps/files/ajax/list.php") as file:
        output = ""
	for line in file:
                if "Hack for sorting" in line:
                    output = "Patch has already been applied!"
                    break
		if find in line:
                    output += code
		output += line
print output
