#!/bin/bash

# Minimize all windows except the named from argument
# Usage example: repos/scripts-misc/bring_forward.sh terminal

wmctrl -k on
wmctrl -l | while read window; do
  if [[ "$window" == *$@* ]]; then
    wmctrl -i -a $(echo "$window" | cut -d " " -f 1)
  fi
done
	  
