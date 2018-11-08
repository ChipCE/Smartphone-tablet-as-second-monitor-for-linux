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
sWidth=0
sHeight=0
uConfirm="n"
while [  "$uConfirm" != "y" ]; do
    read -p "Enter screen width in pixels : " sWidth
    read -p "Enter screen height in pixels : " sHeight
    read -p "Screen size is $sWidth x $sHeight, is that okay ? y/n : " uConfirm
    echo ""
done


# list connected displays
echo "Listing connected displays..."
xrandr | grep -Po ".+\sconnected" | grep -Po ".+\s"
uConfirm="n"
while [  "$uConfirm" != "y" ]; do
    read -p "Enter default connected display name : " sDisplay
    read -p "Default connected display name is $sDisplay, is that okay ? y/n : " uConfirm
    echo ""
done

# calc modeline
echo "Calculate VESA GTF mode lines for $sWidth x $sHeight with gtf"
cModeline=$(gtf $sWidth $sHeight 60 | grep -oP "\".+")
echo "Modeline = $cModeline"
cModename=$(gtf $sWidth $sHeight 60 | grep -oP "\".+" | grep -oP '"\K[^"\047]+(?=["\047])')
echo "Modename = $cModename"
echo ""

# make a copy of templete
if [ -f ./vmonitor ]; then
    rm ./vmonitor
fi
cp template.sh vmonitor

# replace text
# sed -i 's/original/new/g' file.txt
echo -e "Writing vmonitor script file ...\n"
sed -i "s/{modeline}/$cModeline/g" vmonitor
sed -i "s/{modename}/$cModename/g" vmonitor
sed -i "s/{display}/$sDisplay/g" vmonitor

# chmod it 775?
# echo "change vmonitor mode bits : 755"
chmod 755 vmonitor

# copy to bin confirm
read -p "Install vmonitor to /bin, is that okay ? y/n : " uConfirm
echo ""
if [ "$uConfirm" != "y" ]; then
    echo -e "Install to /bin ignored!\n"
    exit 0
fi

# copy to bin
yes | cp -rf vmonitor /bin/vmonitor

echo -e "Installed into /bin/vmonitor.\n"
echo "Done!"
exit 0