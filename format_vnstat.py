#!/usr/bin/python

import sys, re

print '''|date|rx|tx|total|avg|
|----|--:|--:|-----:|---:|'''

for line in sys.stdin:
    data_match = re.findall('([-+]?[0-9]*\.?[0-9]+(?:[eE][-+]?[0-9]+)? [\w+\/]+)', line)
    date_match = re.findall('\d+\/\d+\/\d+', line)
    if date_match and data_match:
        print '|' + date_match[0] +'|' + data_match[0] + '|' + data_match[1] + '|' + data_match[2] + '|' + data_match[3] + '|'

