#!/bin/bash

# docker-wrapper run -v /foo:/bar image args

# Must be root via sudo
if [ "$(whoami)" != "root" ] || [ -z "$SUDO_UID" ]; then
  echo "Error: Must be run with sudo"
  exit 1
fi

# Specify exact python location - uses 2.7 and doesn't rely on path
PYTHON_BIN="/usr/local/bin/python"
SITE_PACKAGES=$($PYTHON_BIN -c "import site;print site.getsitepackages()[0]")

# Pick out the volumes
VOLUME_ARG=0
for i in $*
do
  if [ $VOLUME_ARG -eq 1 ]; then
    # Check access to volume
    ACCESS=$(sudo -u "#$SUDO_UID" "$PYTHON_BIN" "$SITE_PACKAGES/docker-wrapper/check_path_access.py" $i)
    if [ $? -ne 0 ]; then
      echo $ACCESS
      exit 1
    fi
    # Ensure path is whitelisted
    IS_DATA=$(sudo -u "#$SUDO_UID" "$PYTHON_BIN" "$SITE_PACKAGES/docker-wrapper/check_path_whitelist.py" $i)
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


