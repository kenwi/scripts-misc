#!/bin/bash

LANG=en_US 
OUT_DIR=~/cloud.wilhelmsen.nu/rtfm/

echo "---
title: vnstat
taxonomy:
    category: docs
---
"
vnstati -d -o $(echo $OUT_DIR)images/day.png
echo "![vnstat](/images/day.png)"
echo ""

vnstat -d | python format_vnstat.py 
echo "Last updated " $(date +"%F %T")
