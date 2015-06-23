# docker-wrapper
Wrapper scripts for docker volume access

# Usage

Use `docker-wrapper.sh` in place of `docker`, and invoke with sudo:

    sudo docker-wrapper.sh \
      -v /data/somelab/someproject/rawdata:/input:ro \
      -v /data/somelab/someproject/results:/output \
      dockerimage ...
    
docker-wrapper.sh parses the `-v`/`--volume` arguments and 

1. Verifies sure the calling user (SUDO_UID) has the requested access to the path [check_path_access.py](check_path_access.py)
2. Verifies the path is whitelisted [check_path_whitelist.py](check_path_whitelist.py)

If both conditions hold true, the arguments are passed to docker. If not, the script exits with `1`.

# Using sudo

`docker-wrapper.sh` must be run as sudo (it checks SUDO_UID and `whoami`). It is designed to be specified in a sudoers file, allowing users in a `docker-wrapper` group to run it

    ## Allows docker-wrapper group to run docker-wrapper.sh script
    %docker-wrapper    ALL=/path/to/docker-wrapper/docker-wrapper.sh
