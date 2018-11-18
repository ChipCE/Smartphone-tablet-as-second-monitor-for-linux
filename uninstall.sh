#!/bin/bash

# root check
FILE="/tmp/out.$$"
GREP="/bin/grep"

# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# get user who running this script as root
user=($(who))
# echo "${user[0]}"

echo "vmonitor uninstaller"
read -p "Uninstall vmon, is that okay ? y/n : " uConfirm
if [ "$uConfirm" != "y" ]; then
    echo "Exit uninstaller!"
    exit 1
fi

echo "Remove /bin/vmon."
rm /bin/vmon
echo "Remove ${user[0]}/.vmon and it's contents."
rm -rf /home/${user[0]}/.vmon
echo "Remove /usr/share/man/man1/vmon.1.gz"
rm -f /usr/share/man/man1/vmon.1.gz
echo "Done"
exit 0

