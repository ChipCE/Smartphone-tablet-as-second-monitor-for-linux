#!/bin/bash

# root check
FILE="/tmp/out.$$"
GREP="/bin/grep"
#....
# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
# ...

echo "vmonitor uninstaller"
read -p "Uninstall vmonitor, is that okay ? y/n : " uConfirm
if [ "$uConfirm" != "y" ]; then
    echo "Exit uninstaller!"
    exit 1
fi

echo "Remove /bin/vmonitor"
rm /bin/vmonitor
echo "Done"
exit 0