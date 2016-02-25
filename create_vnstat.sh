#!/usr/bin/env bash

LANG=en_US 

echo "---
title: vnstat
taxonomy:
    category: docs
---
"
# Set magic variables for current file & dir
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename ${__file} .sh)"
__root="$(cd "$(dirname "${__dir}")" && pwd)" 

arg1="${1:-}"

vnstati -d -o "${arg1}/images/day.png"
echo "![vnstat](/images/day.png)"
echo ""

vnstat -d | /usr/bin/python "${__dir}/format_vnstat.py"
