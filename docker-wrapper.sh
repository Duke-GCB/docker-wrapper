#!/bin/bash

# docker-wrapper run -v /foo:/bar image args

# Must be run as sudo

if [ -z "$SUDO_UID" ]; then
  echo "Error: Must be run with sudo"
  exit 1
fi

# Get the directory of this script, for paths to python files
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Pick out the volumes
VOLUME_ARG=0
for i in $*
do
  if [ $VOLUME_ARG -eq 1 ]; then
    # Check access to volume
    ACCESS=$(sudo -u "#$SUDO_UID" python "$DIR/check_path_access.py" $i)
    if [ $? -ne 0 ]; then
      echo $ACCESS
      exit 1
    fi
    # Ensure path is whitelisted
    IS_DATA=$(sudo -u "#$SUDO_UID" python "$DIR/check_path_whitelist.py" $i)
    if [ $? -ne 0 ]; then
      echo $IS_DATA
      exit 1
    fi
  fi

  # look for -v or --volume to signal if next argument is a volume mount
  if [ $i == "-v" ] || [ $i == "--volume" ]; then
    VOLUME_ARG=1
  else
    VOLUME_ARG=0
  fi
done

# Pass all arguments to docker

docker $@


