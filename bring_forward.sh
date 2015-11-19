#!/bin/bash

# Minimize all windows except the named from argument

wmctrl -k on
wmctrl -l | while read window; do
  if [[ "$window" == *$@* ]]; then
    code=`echo "$window" | cut -d " " -f 1`
    wmctrl -i -a $code
  fi
done
	  
