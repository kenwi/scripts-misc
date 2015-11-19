#!/bin/bash

# Minimize all windows except the named from argument

wmctrl -k on
wmctrl -l | while read window; do
  if [[ "$window" == *$@* ]]; then
    wmctrl -i -a `echo "$window" | cut -d " " -f 1`
  fi
done
	  
