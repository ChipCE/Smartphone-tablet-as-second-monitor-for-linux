# Android as second monitor for linux
### Using android as second monitor for linux with teamviewer 

This script is example of Nexus 7 2013 as second monitor.You may need to change 1920 and 1200 to the resolution of your tablet screen. You may also need to change LVDS1 if the default monitor's name is different.

<code>gtf 1920 1200 60 | grep -oP "\\".+"</code>

The output will be something similar to <code>"1920x1200_60.00"  108.88  1920 1360 1496 1712  1200 1025 1028 1060  -HSync +Vsync</code>. Copy everything into the next command.

<code>xrandr --newmode "1920x1200_60.00"  108.88  1920 1360 1496 1712  1200 1025 1028 1060  -HSync +Vsync</code>

<code>xrandr --addmode VIRTUAL1 1920x1200_60.00</code>

<code>xrandr --output VIRTUAL1 --mode 1920x1200_60.00 --primary --right-of LVDS1</code>

## Configuration
- To show cursor in tablet screen, enable "show remote cursor" in teamviewer(tablet).   
- To connect with wlan, enable "incomming lan connection" in Extras > Options(linux).   
- To connect via USB cable, you need adb installed and forward Teamviewer port with <code>adb forward</code> or enable USB Tethering in android setting.   
- To turn-off VIRTUAL1 output, run <code>xrandr --output VIRTUAL1 --off</code> 

## Troubleshooting  
If you get the output VIRTUAL1 not found error, create 20-intel.conf file:   
<code>sudo nano /usr/share/X11/xorg.conf.d/20-intel.conf</code>
Add the following configuration information into the file:
<pre>
Section "Device"
    Identifier "intelgpu0"
    Driver "intel"
    Option "VirtualHeads" "2"
EndSection
</pre>
and reboot.