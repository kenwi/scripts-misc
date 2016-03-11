#!/bin/bash

rtl_power -f 24M:500M:75k -i 20s -c 50% -e 12h $(date +"%F-%H%M.csv")
