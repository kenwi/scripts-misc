#!/bin/bash

# Minimize all windows except the named from argument

Program=$@

wmctrl -k on
wmctrl -l | while read Window; do
  if [[ "$Window" == *"$Program"* ]]; then
    code=`echo "$Window" | cut -d " " -f 1`
    wmctrl -i -a $code
  fi
done
	  
