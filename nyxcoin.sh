#!/bin/bash
OUTPUT="$(cat /etc/*release)"
testseq="17.10"
sudo apt-get install curl -y
clear
RESULT = $("n");
EXIP="$(curl ipinfo.io/ip)"
PRIVKEY="$()"
while [[ x$RESULT != xy && x$RESULT != xY ]]
do
        clear
        echo "-------------------------------------------------"
        echo "|Setup your NYX Masternode"
        echo "-------------------------------------------------"
        echo "Your External IP is: "$EXIP
        echo "We need your masternode private key to setup it"
        echo -n "Copy your masternode private key and paste here :"
        read PRIVKEY
        clear
        echo "-------------------------------------------------"
        echo "MN private key: "$PRIVKEY
        echo -n "Your masternode private key is correct?(y/n)"
        read RESULT;

done
clear
if [[ $OUTPUT =~ $testseq ]];
then
	echo "=============================================================="
	echo "|"
    echo "| No need to compile, just clone Magnetd, I will do it!"
	echo "|"
	echo "| It will be take 5 minutes :)"	
	echo "=============================================================="
	echo "Installation will start in 10 seconds"
	sleep 10
	#installs dependencies
	echo "=============================================================="
	echo "|"
    echo "| Installing dependencies"
	echo "|"	
	echo "=============================================================="
	sudo apt-get update -y
	sudo apt-get install build-essential libtool automake autotools-dev autoconf pkg-config libssl-dev libgmp3-dev libevent-dev bsdmainutils -y
	sudo apt-get install libboost-all-dev -y
	sudo add-apt-repository ppa:bitcoin/bitcoin -y
	sudo apt-get update -y
	sudo apt-get install libdb4.8-dev libdb4.8++-dev -y
	sudo apt-get install libminiupnpc-dev -y
	sudo apt-get install unrar -y
	sudo apt-get install curl -y
	#clone magnet
	echo "=============================================================="
	echo "|"
    echo "| Cloning Magnet repository"
	echo "|"	
	echo "=============================================================="
	mkdir magnet
	cd magnet
	wget http://magnetwork.io/Wallets/magnet-qt-LINUX.rar
	unrar e magnet-qt-LINUX.rar
	chmod +x magnetd
	./magnetd	
	printf 'rpcallowip=127.0.0.1\nrpcport=17179\nrpcuser=/RANDOMUSERNAME/\nrpcpassword=/RANDOMPASSWORD/\nserver=1\nlisten=1\ndaemon=1\nport=17177\naddnode=146.148.79.31:17177\naddnode=104.196.202.240:17177\naddnode=35.195.167.40:17177\naddnode=35.199.188.194:17177\naddnode=104.196.155.39:17177\naddnode=35.197.228.109:17177\naddnode=35.198.35.45:17177\naddnode=52.224.232.188:17177\naddnode=150.95.198.182:17177\naddnode=45.76.181.186:17177\naddnode=108.45.164.191:17177\naddnode=45.63.28.187:17177\nexternalip='$EXIP'\nmasternodeaddr='$EXIP':17177\nmasternode=1\nmasternodeprivkey='$PRIVKEY'\n' > ~/.magnet/magnet.conf
	echo "=============================================================="
	echo "|"
    echo "| If the message bellow is: 'Magnet server starting' everything is work! You can start your MN on local cold wallet!"
	echo "|"	
	echo "=============================================================="
	./magnetd
else
	echo "=============================================================="
	echo "|"
    echo "| This linux version need to compile the Magnetd, I will do it!"
	echo "|"
	echo "| It will be take 30 minutes, have a coffee and relax :)"
	echo "=============================================================="
	echo "Installation will start in 10 seconds"
	sleep 10	
	sudo apt-get install make -y #micro VPS sometimes need to install make
	#create swap of 2GB to have enought memory to compile the Magnet
	echo "=============================================================="
	echo "|"
    echo "| Create 2GB swap to compile"
	echo "|"	
	echo "=============================================================="
	cd /
	sudo dd if=/dev/zero of=swapfile bs=1M count=2000 
	sudo mkswap swapfile
	sudo swapon swapfile
	echo "/swapfile none swap sw 0 0" >> etc/fstab
	#installs dependencies
	echo "=============================================================="
	echo "|"
    echo "| Installing dependencies"
	echo "|"	
	echo "=============================================================="
	sudo apt-get update -y
	sudo apt-get install make -y
	sudo apt-get install build-essential libtool automake autotools-dev autoconf pkg-config libssl-dev libgmp3-dev libevent-dev bsdmainutils -y
	sudo apt-get install libboost-all-dev -y
	sudo add-apt-repository ppa:bitcoin/bitcoin -y
	sudo apt-get update -y
	sudo apt-get install libdb4.8-dev libdb4.8++-dev -y
	sudo apt-get install libminiupnpc-dev -y
	#clone repository of Magnet
	echo "=============================================================="
	echo "|"
    echo "| Clone Magnet repository"
	echo "|"	
	echo "=============================================================="
	git clone https://github.com/magnetwork/magnet.git
	#compile Magnetd
	echo "=============================================================="
	echo "|"
    echo "| Compiling Magnet repository"
	echo "|"	
	echo "=============================================================="
	cd /
	cd magnet && \
	chmod +x compile.sh && \
	./compile.sh
	#move magnetd file to /root/magnet/ folder
	mkdir ~/magnet
	mv /magnet/src/magnetd ~/magnet/magnetd
	~/magnet/./magnetd
	printf 'rpcallowip=127.0.0.1\nrpcport=17179\nrpcuser=/RANDOMUSERNAME/\nrpcpassword=/RANDOMPASSWORD/\nserver=1\nlisten=1\ndaemon=1\nport=17177\naddnode=146.148.79.31:17177\naddnode=104.196.202.240:17177\naddnode=35.195.167.40:17177\naddnode=35.199.188.194:17177\naddnode=104.196.155.39:17177\naddnode=35.197.228.109:17177\naddnode=35.198.35.45:17177\naddnode=52.224.232.188:17177\naddnode=150.95.198.182:17177\naddnode=45.76.181.186:17177\naddnode=108.45.164.191:17177\naddnode=45.63.28.187:17177\nexternalip='$EXIP'\nmasternodeaddr='$EXIP':17177\nmasternode=1\nmasternodeprivkey='$PRIVKEY'\n' > ~/.magnet/magnet.conf
	echo "=============================================================="
	echo "|"
    echo "| If the message bellow is: 'Magnet server starting' everything is work! You can start your MN on local cold wallet!"
	echo "|"	
	echo "=============================================================="
	~/magnet/./magnetd
	
fi
