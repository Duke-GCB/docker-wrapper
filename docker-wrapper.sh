#!/bin/bash

# docker-wrapper run -v /foo:/bar image args

# Must be run as sudo

if [ -z "$SUDO_UID" ]; then
  echo "Error: Must be run with sudo"
  exit 1
fi

# Pick out the volumes
VOLUME_ARG=0
for i in $*
do
  if [ $VOLUME_ARG -eq 1 ]; then
    # Check access to volume
    # TODO: handle results
    # TODO: ensure /data is the first part of the path
    sudo -u "#$SUDO_UID" python check_access.py $i
  fi

  # look for -v or --volume to signal if next argument is a volume mount
  if [ $i == "-v" ] || [ $i == "--volume" ]; then
    VOLUME_ARG=1
  else
    VOLUME_ARG=0
  fi
done

echo "All args: $@"
