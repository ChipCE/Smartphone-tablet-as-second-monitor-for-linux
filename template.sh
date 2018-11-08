#!/bin/bash
vmonitor-help () {
    echo "Virtual monitor - easy virtual monitor setup tool"
    echo "USAGE : vmonitor [setup] [enable] [disable]"
    echo -e "\t setup\t: Setup profile for virtual monitor.Need to execute each time X server start."
    echo -e "\t enable\t: Enable virtual monitor."
    echo -e "\t disable: Disable virtual monitor."
}

if [ -z "$1" ]; then
    vmonitor-help
    echo "Error : Too few arguments!"
    exit 0
fi
if [ $# -gt 1 ]; then
    echo "Error : Too much arguments!"
    exit 1
fi

if [ "$1" = "setup" ]; then
    echo "Done!"
    xrandr --newmode {modeline}
    xrandr --addmode VIRTUAL1 {modename}
    exit 0
fi

if [ "$1" = "enable" ]; then
    echo "VIRTUAL1 is enabled"
    xrandr --output VIRTUAL1 --mode {modename} --primary --right-of {display}
    exit 1
fi

if [ "$1" = "disable" ]; then
    echo "VIRTUAL1 is disabled"
    xrandr --output VIRTUAL1 --off
    exit 1
fi

echo -e "Error : Unknown argument \"$1\" !"
exit 1