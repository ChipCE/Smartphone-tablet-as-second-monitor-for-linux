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


# userinput
read -p "Enter screen width in pixels : " sWidth
read -p "Enter screen height in pixels : " sHeight
read -p "Screen size is $sWidth x $sHeight, is that okay ? y/n : " uConfirm
if [ "$uConfirm" != "y" ]; then
    echo "Exit setup!"
    exit 1
fi

read -p "Enter default display name : " sDisplay
read -p "Default display name is $sDisplay, is that okay ? y/n : " uConfirm
if [ "$uConfirm" != "y" ]; then
    echo "Exit setup!"
    exit 1
fi

# calc modeline
echo "calculate VESA GTF mode lines for $sWidth x $sHeight with gtf"
cModeline=$(gtf $sWidth $sHeight 60 | grep -oP "\".+")
echo "Modeline = $cModeline"
cModename=$(gtf $sWidth $sHeight 60 | grep -oP "\".+" | grep -oP '"\K[^"\047]+(?=["\047])')
echo "Modename = $cModename"

# make a copy of templete
if [ -f ./vmonitor ]; then
    rm ./vmonitor
fi
cp template.sh vmonitor

# replace text
# sed -i 's/original/new/g' file.txt
sed -i "s/{modeline}/$cModeline/g" vmonitor
sed -i "s/{modename}/$cModename/g" vmonitor
sed -i "s/{display}/$sDisplay/g" vmonitor

# chmod it 775?
echo "change vmonitor mode bits : 755"
chmod 755 vmonitor

# copy to bin
read -p "Install vmonitor to /bin, is that okay ? y/n : " uConfirm
if [ "$uConfirm" != "y" ]; then
    echo "Exit setup!"
    exit 1
fi

cp vmonitor /bin/vmonitor
echo "Done!"
exit 0