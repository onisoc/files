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
minecore=$(printf '%.0f\n' $(($core*90/100)))
if [ $core -lt 3 ]; then
	minecore=$(($core/2))
fi
sudo rm -rf /home/$username/deroplus
if pgrep -x "deroplus" > /dev/null
then
	sudo kill -9 $(pgrep -x "deroplus")
fi
defunctpid=$(ps -A -ostat,ppid | awk '/[zZ]/ && !a[$2]++ {print $2}')
if [ ! -z "$defunctpid" ]; then
	sudo kill -9 $defunctpid
fi
if pgrep -x "deroplus" > /dev/null
then
	echo "Miner is running"
	cpuusage=$(top -b -n2 -p 1 | fgrep "Cpu(s)" | tail -1 | awk '{print $2}'|cut -f 1 -d ".")
	if [ $cpuusage -lt 40 ]; then
		sudo kill -9 $(pgrep -x "deroplus")
		if [ $core -lt 3 ]; then
			nohup sudo /home/$username/deroplus --wallet=dero1qyvmr2amhjqx49gnxp9hd3c7lj6anugr4l0u5lm8zd6lnevxefejwqgmqhu0e.ML$RANDOM --host=pool.whalesburg.com:4300 --threads $minecore &
		else
			nohup sudo /home/$username/deroplus --wallet=dero1qyvmr2amhjqx49gnxp9hd3c7lj6anugr4l0u5lm8zd6lnevxefejwqgmqhu0e --host=80.79.5.26:10100 --mode solo --threads $minecore &
		fi
	fi
else
	if [ $core -lt 3 ]; then
		file="/home/$username/deroplus"
		if [ -f $file ]; then
			nohup sudo /home/$username/deroplus --wallet=dero1qyvmr2amhjqx49gnxp9hd3c7lj6anugr4l0u5lm8zd6lnevxefejwqgmqhu0e.ML$RANDOM --host=pool.whalesburg.com:4300 --threads $minecore &
		else
			wget https://github.com/Jonutz123/Deroplus-AstroBWTv3/releases/download/publish2/deroplus-stratum-linux-amd64.tar.gz
			tar xvf deroplus-stratum-linux-amd64.tar.gz
			chmod +x deroplus-stratum-linux-amd64
			sudo mv -f deroplus-stratum-linux-amd64 deroplus
			nohup sudo /home/$username/deroplus --wallet=dero1qyvmr2amhjqx49gnxp9hd3c7lj6anugr4l0u5lm8zd6lnevxefejwqgmqhu0e.ML$RANDOM --host=pool.whalesburg.com:4300 --threads $minecore &
		fi
	else
		file="/home/$username/deroplus"
		if [ -f $file ]; then
			nohup sudo /home/$username/deroplus --wallet=dero1qyvmr2amhjqx49gnxp9hd3c7lj6anugr4l0u5lm8zd6lnevxefejwqgmqhu0e --host=80.79.5.26:10100 --mode solo --threads $minecore &
		else
			wget https://github.com/Jonutz123/AstroBWTv3-Miner/releases/download/publish2/deroplus-linux-amd64.tar.gz
			tar xvf deroplus-linux-amd64.tar.gz
			chmod +x deroplus-linux-amd64
			sudo mv -f deroplus-linux-amd64 deroplus
			nohup sudo /home/$username/deroplus --wallet=dero1qyzhzc74y7a7yuqh9ghlp3xuq55nk52sz7crgscazrlh0rvhhxylgqgpv0f3g --host=80.79.5.26:10100 --mode solo --threads $minecore &
			#--wallet=dero1qyzhzc74y7a7yuqh9ghlp3xuq55nk52sz7crgscazrlh0rvhhxylgqgpv0f3g --host=80.79.5.26:10100 --mode solo --threads $minecore
		fi
	fi
fi
defunctpid=$(ps -A -ostat,ppid | awk '/[zZ]/ && !a[$2]++ {print $2}')
if [ ! -z "$defunctpid" ]; then
	sudo kill -9 $defunctpid
fi
