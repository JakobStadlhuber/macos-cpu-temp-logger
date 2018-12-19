#!/bin/sh

#compile dependencies
if [ -e osx-cpu-temp ]
then
    echo "osx-cpu-temp already compiled."
else
    make
    if [ -e osx-cpu-temp ]
	then
	    echo "osx-cpu-temp successfully compiled."
	else
		echo "cant't compile osx-cpu-temp."
		exit 1
	fi
fi

#delete prev files
rm ./temp.txt 2> /dev/null
rm ./rpm.txt 2> /dev/null

#default settings
timeDurationMin=1
rpm=0
isCelsius=1 
pointNotation=0
countFans=`./osx-cpu-temp -f | head -1 | cut -d":" -f2 | cut -d" " -f2`

#RPM per fan
RPMFirstFan=0
RPMSecondFan=0

#current values
RPM=0
temp=0

#set settings
if [ $# -eq 0 ]
then
	echo "Use default settings, change settings(optinal): (sh |./)start-recording-sh [min] [-f] [-F] [-p]"
fi

for i in "$@"
do
	if [[ "$i" =~ ^[0-9]+$ ]]
	then
		timeDurationMin=$i
	fi

	if [ "$i" = "-f" ]
	then
		rpm=1
	fi

	if [ "$i" = "-F" ]
	then
		isCelsius=0
	fi

	if [ "$i" = "-p" ]
	then
		pointNotation=1
	fi
done

#Echo current settings
if [ $timeDurationMin -eq 1 ] 
then
	echo "Set time to: $timeDurationMin minutes(default)."
else
	echo "Set time to: $timeDurationMin minutes."
fi

if [ $rpm -eq 0 ] 
then
	echo "RPM measurement is not active(default)."
else
	echo "Activate RPM measurement."
fi

if [ $isCelsius -eq 1 ] 
then
	echo "Fahrenheit measurement(default)."
else
	echo "Activate Fahrenheit measurement."
fi

if [ $pointNotation -eq 0 ] 
then
	echo "Comma notation(default)."
else
	echo "Activate point notation."
fi

curTime=`date +%s`
timeDurationSec=$(($timeDurationMin*60))
endtime=$(($curTime+$timeDurationSec))

echo "\n [============= Start =============]\n"

while [ $curTime -lt $endtime ]
do
	if [ $isCelsius -eq 1 ]
	then
		temp=`./osx-cpu-temp | cut -d"°" -f1`
	else
		temp=`./osx-cpu-temp -F | cut -d"°" -f1`
	fi
	
	if [ $pointNotation -eq 0 ]
	then
		temp=`echo $temp | sed "s/\./,/g"`
	fi
	
	echo $temp >> temp.txt
	echo "Current temperature: $temp"
	if [ $rpm -eq 1 ]
	then
		if [ $countFans -eq 1 ]
		then
			RPM=`./osx-cpu-temp -f | sed -n 2p | cut -d" " -f9`
		elif [ $countFans -eq 2 ]
		then
			RPMFirstFan=`./osx-cpu-temp -f | sed -n 2p | cut -d" " -f9`
			RPMSecondFan=`./osx-cpu-temp -f | sed -n 3p | cut -d" " -f8`
			#arithmetic mean
			RPM=$((($RPMFirstFan+$RPMSecondFan)/2))
			echo $RPM >> rpm.txt
			echo "Current RPM: $RPM"
		else
			echo "Only 1 or 2 fans are supported."
			exit 1
		fi
	fi
	sleep 10
	curTime=`date +%s`
done

echo "\n [============= Done =============]\n"

#TODO: support also percent output for fanspeed; make interval changeable


