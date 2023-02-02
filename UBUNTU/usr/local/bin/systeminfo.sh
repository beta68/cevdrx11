#!/bin/bash
# systeminfo.sh: external data collection script
# This file belongs to the VDR plugin systeminfo
#
# See the main source file 'systeminfo.c' for copyright information and
# how to reach the author.
#
# $Id$
#
# possible output formats:
# (blanks around tabs only for better reading)
# 1)   Name \t Value         	displays Name and Value
# 2)   Name \t Value1 \t Value2 displays Name, Value1 and Value2
# 3)   Name \t total used       displays an additional progress bar (percentage) after the values
# 4)   s \t Name \t ...         defines a static value, this line is only requested during the first cycle
#
# special keywords (they are replaced by the plugin with the actual value):
#      CPU%    CPU usage in percent
#
# test with: for i in $(seq 1 16); do systeminfo.sh $i;echo;done
#

PATH=/usr/bin:/bin:/sbin

case "$1" in
	1)	# kernel version (static)
		KERNEL=$(uname -rm)
		echo -ne "s\tLinux Kernel:\t"$KERNEL
        	;;

	2)	# distribution release (static)
		if test -f /etc/os-release; then
			DISTRI=$(grep "^NAME=" /etc/os-release|cut -d"=" -f 2)
			RELEASE=$(grep "^PRETTY_NAME=" /etc/os-release|cut -d"=" -f 2|tr -d '"'|tr -d "'")
		elif test -f /etc/SuSE-release; then
			DISTRI="openSuSE"
			RELEASE=$(head -n 1 /etc/SuSE-release)
		elif test -f /etc/redhat-release; then
			DISTRI="RedHat"
			RELEASE=$(head -n 1 /etc/redhat-release)
		elif test -f /etc/debian_version; then
			DISTRI="Debian"
			RELEASE=$(head -n 1 /etc/debian_version)
		elif test -f /etc/gentoo-release; then
			DISTRI="Gentoo"
			RELEASE=$(head -n 1 /etc/gentoo-release)
		elif test -f /etc/lsb-release; then
			DISTRI=$(grep DISTRIB_ID /etc/lsb-release|cut -d"=" -f 2)
			RELEASE=$(grep DISTRIB_DESCRIPTION /etc/lsb-release|cut -d"=" -f 2)
		elif test -x /usr/bin/crux; then
			DISTRI="Crux"
			RELEASE=$(crux|cut -d" " -f 3)
		elif test -f /etc/arch-release; then
			DISTRI="Arch Linux"
			RELEASE="rolling-release"
		else
			DISTRI="unknown"
			RELEASE="unknown"
		fi
		echo -ne "s\tDistribution:\t"$RELEASE
		exit
        	;;

	3)	# CPU type (static)
		CPUTYPE=$(grep 'model name' /proc/cpuinfo | cut -d':' -f 2  | cut -d' ' -f2- | uniq)
		echo -ne "s\tCPU Type:\t"$CPUTYPE
        	;;

	4)	# current CPU speed
		VAR=$(grep 'cpu MHz' /proc/cpuinfo | sed 's/.*: *\([0-9]*\)\.[0-9]*/\1 MHz/')
		echo -ne "CPU speed:\t"$VAR
		exit
        	;;

	5)	# hostname and IP (static)
		hostname=$(hostname)
		dnsname=$(dnsdomainname)
		#IP=$(ifconfig enp2s0 | grep inet | cut -d: -f2 | cut -d' ' -f1)
		IP=$(ip addr show enp2s0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
		echo -ne "s\tHostname:\t"${hostname:-<unknown>}"."${dnsname:-<unknown>}"\tIP: "${IP:-N/A}
		exit
        	;;

	6)      # uptime
		#UPTIME=$(last -1 reboot|head -n 1|tr -s " "|cut -d' ' -f5-)
		UPTIME=$(uptime | awk '{print $1}')
		echo -ne "uptime:\t${UPTIME}"
		exit
		;;

	7)	# fan speeds
		CPU=0 #$( sensors | grep -i 'CPU FAN' | tr -s ' ' | cut -d' ' -f 3)
		CASE=0 #$(sensors | grep -i 'SYS Fan' | tr -s ' ' | cut -d' ' -f 3)
		echo -ne "Fans:\tCPU: "$CPU" rpm\tCase: "$CASE" rpm"
		exit
        	;;

	8)	# temperature of CPU and mainboard
		#CPU=$(sensors | grep -i 'CPU TEMP' | tr -s ' ' | cut -d' ' -f 3)
		CPU=$(cat /sys/devices/virtual/thermal/thermal_zone0/temp | awk '{print $1 / 1000. " °C"}') #$(sensors | grep 'Core 0:' | awk '{print $3}')
		#MB=$( sensors | grep -i 'Sys temp' | tr -s ' ' | cut -d' ' -f 3)
		MB=$(cat /sys/devices/virtual/thermal/thermal_zone1/temp | awk '{print $1 / 1000. " °C"}') #$(sensors | grep 'temp1:' -m 1 | awk '{print $2}')
		echo -ne "Temperatures:\tCPU: "$CPU"\tMB: "$MB
		exit
        	;;

	9)	# temperature of hard disks
		#DISK1=$(hddtemp /dev/sda | cut -d: -f1,3)
		#DISK2=$(hddtemp /dev/sdb | cut -d: -f1,3)
		DISK1=0 #$(sensors | grep 'temp1:' | tail -1 | awk '{print $2}')
		DISK2=0 #$(sensors | grep 'temp1:' | tail -1 | awk '{print $2}')
		echo -ne "\t"$DISK1"\t"$DISK2
		exit
        	;;

	10)	# CPU usage
		echo -e "CPU time:\tCPU%"
		exit
        	;;

	11)	# header (static)
		echo -ne "s\t\ttotal / free"
		exit
		;;

	12)	# video disk usage
		VAR=$(df -Pk /video | tail -n 1 | tr -s ' ' | cut -d' ' -f 2,4)
		echo -ne "Video Disk:\t"$VAR
		exit
        	;;

	13)	# memory usage
		VAR=$( grep -E 'MemTotal|MemFree' /proc/meminfo | cut -d: -f2 | tr -d ' ')
		echo -ne "Memory:\t"$VAR
		exit
        	;;

	14)	# swap usage
		VAR=$(grep -E 'SwapTotal|SwapFree' /proc/meminfo | cut -d: -f2 | tr -d ' ')
		echo -ne "Swap:\t"$VAR
		exit
        	;;
	test)
		echo ""
		echo "Usage: systeminfo.sh {1|2|3|4|...}"
		echo ""
		exit 1
		;;
esac
exit
