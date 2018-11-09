#!/bin/bash

# root check
FILE="/tmp/out.$$"
GREP="/bin/grep"

# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

echo "vmon - Virtual Monitor Installer v1.1"
echo ""

# get user who running this script as root
user=($(who))
# echo "${user[0]}"

# config files location
userConfFile="/home/${user[0]}/.vmon/vmon.conf"
resolutionFile="/home/${user[0]}/.vmon/resolution.conf"
configDir="/home/${user[0]}/.vmon"

# list connected displays
echo "Listing connected displays..."
displayName=($(xrandr | grep -oP ".+\sconnected" | sed 's/ connected.*//'))
for i in "${displayName[@]}"
do
    echo "$i"
done
defaultDisplay=""
uConfirm="n"
invalid="true"
while [  "$uConfirm" != "y" ] || [ "$invalid" == "true" ]
do
    read -p "Enter default connected display name : " defaultDisplay
    read -p "Default connected display name is $defaultDisplay, is that okay ? y/n : " uConfirm
    
    if [ "$uConfirm" != "y" ]; then
        continue
    fi

    # check for invalid input
    for i in "${displayName[@]}"
    do
        if [ "$i" == "$defaultDisplay" ]; then
            invalid="false"
            break
        fi
    done

    if [ "$invalid" == "true" ]; then
        echo "Error : Invalid display name $defaultDisplay !"
    fi
    echo ""
done

# get modename
if [ ! -f "./resolution.conf" ]; then
    echo "Error : Cannot read ./resolution.conf!"
    exit 1
fi
resolution=($(grep "x" ./resolution.conf))
width=($(grep -oP "\d+x" ./resolution.conf | grep -oP "\d+"))
height=($(grep -oP "x\d+" ./resolution.conf | grep -oP "\d+"))
resCount=$(grep -c "x" ./resolution.conf)
resCount=`expr $resCount - 1` 
modename[0]=""
for i in $(seq 0 $resCount)
do
    modename[$i]=$(gtf ${width[$i]} ${height[$i]} 60 | grep -oP "\".+" | grep -oP '"\K[^"\047]+(?=["\047])')
done
# list available modename
echo "Listing available resolution for virtual monitor..."
for i in "${modename[@]}"
do
    echo "$i"
done
# user input
defaultResolution=""
invalid="true"
uConfirm="n"
while [  "$uConfirm" != "y" ] || [ "$invalid" == "true" ]
do
    read -p "Enter default resolution for virtual display : " defaultResolution
    read -p "Default resolution for virtual display is $defaultResolution, is that okay ? y/n : " uConfirm

    for i in "${modename[@]}"
    do
        if [ "$i" == "$defaultResolution" ]; then
            invalid="false"
            break
        fi
    done
    if [ "$invalid" == "true" ]; then
        echo "Error : Invalid resolution $defaultResolution !"
    fi

    echo ""
done


# make config file
if [ -f vmon.conf ]; then
    rm vmon.conf
fi
cp ./vmon.conf.template ./vmon.conf

# replace arg
sed -i "s/{display}/$defaultDisplay/g" vmon.conf
sed -i "s/{resolution}/$defaultResolution/g" vmon.conf

# chmod
chmod 775 vmon
chmod 775 vmon.conf
chmod 775 resolution.conf

read -p "This script will install vmon into /bin and config files into ~/.vmon , is that okay ? y/n : " uConfirm
echo ""
if [ "$uConfirm" != "y" ]; then
    echo -e "Exit installer!\n"
    exit 0
fi

yes | cp -rf vmon /bin/vmon
if [ ! -d "$configDir" ]; then
  mkdir $configDir
fi
yes | cp -rf vmon.conf $userConfFile
yes | cp -rf resolution.conf $resolutionFile

# chown
chown -R ${user[0]}:${user[0]} /home/${user[0]}/.vmon
#chown  $user:$user $userConfFile
#chown  $user:$user $resolutionFile

echo "Done!"
exit 0