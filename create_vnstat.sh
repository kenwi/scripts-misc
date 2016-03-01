#!/usr/bin/env bash

LANG=en_US 

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename ${__file} .sh)"
__root="$(cd "$(dirname "${__dir}")" && pwd)"

arg1="${1:-}"

if [ ! -d "${arg1}/$images" ]; then 
  echo "The directory '${arg1}/images' does not exist."
  exit 1
fi

echo "---
title: vnstat
taxonomy:
    category: docs
---
"
vnstati -h -o "${arg1}/images/day.png"
echo "![vnstat](/images/day.png)"
echo ""

vnstati -d -o "${arg1}/images/month.png"
echo "![vnstat](/images/month.png)"
echo ""

vnstat -d | /usr/bin/python "/root/repos/scripts-misc/format_vnstat.py"
date +"Last updated: %F %T"

