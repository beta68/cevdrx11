# cevdrx11 for Amlogic powered devices
CoreElec - VDR - X11 with ambilight

This README decribes the installation of a CoreElec based Ubuntu 20.04
including VDR, switching between VDR and KODI and switching from VDR to X11.

The complete procedure is explained for a Radxa Zero and was tested on
Radxa Zero, Radxa Zero 2 and Odroid N2(+). However, it should work for all
Amlogic based devices supported by CoreElec.

For Radxa Zero please follow this instruction:

# 1. Erase eMMC  
Erase Radxa Zero's eMMC using radxa-zero-erase-emmc.bin. Please follow
the instructions on Radxa website on how this can be done.

# 2. Flash CoreElec  
Flash CoreElec distribution for Radxa Zero to eMMC. Please read Radxa's
website for further details.

# 3. Boot CoreElec and configure 
Boot into CoreElec. Set your network and enable ssh access. Please change
ssh password. Configure CoreElec as required language support etc.)

# 4. In CE: prepare storage directory
Login into CoreElec from external computer and copy files from storage directory
to /storage (please see README in storage directory).

# 5. In CE: copy rootfs
Execute 

mkdir /storage/UBUNTU

and copy rootfs to UBUNTU directory in CoreElec.
See README in rootfs-directory for further details and directories to be made.
IMPORTANT NOTE: if you change /home/rudi to another name, you must change 'rudi'
in all bash scripts to the other name.

# 6. In CE: copy system.d files
In CoreElec please copy all scripts in system.d to /storage/.config/system.d.
See README for enabling these scripts (please enable these scripts once your
complete setup is ready and not now!).

# 7. In CE: set your chroot network
Adapt UBUNTU/etc/resolv.conf to your network requirements as follows

cd /storage/UBUNTU/etc

rm resolv.conf

Generate a new resolv.conf with e.g. following content:

nameserver 192.168.178.1

This example is for dhcp. Adapt, if required.

# 8.  In CE: change to chroot environment
Invoke ubuntu.sh in /storage. Followed by

cd UBUNTU

chroot . /bin/bash

This will bring you to chroot environment.

# 9. In chroot: install packages
Copy packages.list to /storage/UBUNTU (which is rootfs of your chroot) and invoke

xargs -a "packages.list" apt install

This will install all required packages for Ubuntu 20.04 for VDR (all of my plugins
are working with this package set and X11 is working correctly as well).

# 10. In chroot: purge packagekit
chroot does allow systemd running. Therefore, please purge packagekit:

apt purge packagekit

It is not required and will not run anyway.

# 11. In chroot: prepare all chroot directories
Copy all directories located under UBUNTU (etc, home, use, var, vdr) to UBUNTU directory
in your CoreElec installation.
IMPORTANT NOTE: Do not overwrite etc/resolv.conf with the example located in etc.

# 12. In chroot: install VDR and plugins
Look into directories in /home/rudi, download everything from git and invoke scripts, if
existing, e.g. for generating channel logos
Download VDR from git and all required plugins. As a graphical output device use https://github.com/jojo61/vdr-plugin-softhdodroid.

# 13. In chroot: adapt VDR configuration
Adapt /var/lib/vdr configurations, if required.

# 14. In chroot: compile and install VDR.

In /home/rudi/vdr:

make

make plugins

make install

cp PLUGINS/lib /usr/local/lib/vdr

# 15. In CE: enable systemd-scripts
Now enable all system-scripts (please see 5).

# 16. In CE: reboot
After a reboot CoreElec will start KODI and play 1s of short video. This is required
on my Odroid N2 for smooth remote control experience. Afterwards, VDR will start. If this
procedure is not required you can disable it in /storage/UBUNTU/vdr/vdr.sh script.

# 17. X11
X11 can be started using VDR -> Commands -> Kill VDR and start X11. A manual reboot is required
to boot KODI or VDR again. X-forwarding works using an additional sshd frmo chroot.
x11vnc is also working. Scripts can be adapted to directly boot KODI or X11 instead of VDR.

# IMPORTANT hints

I am using FLIRC as remote control for Radxa Zero. Therefore, VDR is bound to a virtual terminal.
For other remote controls (lirc, meson) adapt runvdr script accordingly (see commentsin runvdr).
Simply comment chvt 7 command and delete -t /dev/tty7. In order to re-configure remote control for
VDR please delete /var/lib/vdr/remote.conf.
  
/home/rudi/on.sh requests 'POWER' event from FLIRC. Change it to your POWER event and use the
correct /dev/input/eventX. Odroid N2+ features a RTC and can be switched off completely. Adapt /usr/local/bin/runvdr
accordingly.

Have fun!
