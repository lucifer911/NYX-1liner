#/bin/bash
# Making NYX mn install

cd root/
echo "****************************************************************************"
echo "* Ubuntu 16.04 is the recommended opearting system for this install.       *"
echo "*        lets see                                                          *"
echo "* This script will install and configure your NYX masternodes.             *"
echo "****************************************************************************"
echo && echo && echo
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "!                                                 !"
echo "! Make sure you double check before hitting enter !"
echo "!                                                 !"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo && echo && echo

  sudo apt-get update
  sudo apt-get upgrade -y
  sudo apt-get dist-upgrade -y
  sudo apt-get install -y nano htop git
  sudo apt-get install -y software-properties-common
  sudo apt-get install -y build-essential libtool autotools-dev pkg-config libssl-dev
  sudo apt-get install -y libboost-all-dev
  sudo apt-get install -y libevent-dev
  sudo apt-get install -y libminiupnpc-dev
  sudo apt-get install -y autoconf
  sudo apt-get install -y automake unzip
  sudo add-apt-repository  -y  ppa:bitcoin/bitcoin
  sudo apt-get update
  sudo apt-get install -y libdb4.8-dev libdb4.8++-dev

# make swap

  cd /var
  sudo touch swap.img
  sudo chmod 600 swap.img
  sudo dd if=/dev/zero of=/var/swap.img bs=1024k count=2000
  sudo mkswap /var/swap.img
  sudo swapon /var/swap.img
  sudo free
  sudo echo "/var/swap.img none swap sw 0 0" >> /etc/fstab
  cd
  sudo mkdir nyx && cd nyx
  
wget http://latest.nyxcoin.org/nyx-0.12.1-linux64.tar.gz
tar -xvf nyx-0.12.1-linux64.tar.gz
  sudo chmod +x nyx*
  sudo mv nyx-cli nyx-qt nyx-tx nyxd /usr/local/bin 
  sudo cd ..
  sudo rm -r -f nyx-0.12.1
  sudo nyxd -daemon


#echo ""
#echo "Configure your masternodes now!"
#echo "Type the IP of this server, followed by [ENTER]:"
#read IP

echo ""
echo "Enter masternode private key for node $ALIAS"
read PRIVKEY

CONF_DIR=/root/.nyx
CONF_FILE=nyx.conf
PORT=7777
IPADDRESS=$(ip route get 1 | awk '{print $NF;exit}')


mkdir -p $CONF_DIR
echo "rpcuser=user"`shuf -i 100000-10000000 -n 1` >> $CONF_DIR/$CONF_FILE
echo "rpcpassword=pass"`shuf -i 100000-10000000 -n 1` >> $CONF_DIR/$CONF_FILE
echo "rpcallowip=127.0.0.1" >> $CONF_DIR/$CONF_FILE
echo "listen=1" >> $CONF_DIR/$CONF_FILE
echo "server=1" >> $CONF_DIR/$CONF_FILE
echo "daemon=1" >> $CONF_DIR/$CONF_FILE
echo "masternode=1" >> $CONF_DIR/$CONF_FILE
echo "" >> $CONF_DIR/$CONF_FILE

echo "port=$PORT" >> $CONF_DIR/$CONF_FILE
echo "masternodeaddr=$IP:$PORT" >> $CONF_DIR/$CONF_FILE
echo "masternodeprivkey=$PRIVKEY" >> $CONF_DIR/$CONF_FILE

echo "" >> $CONF_DIR/$CONF_FILE
echo "addnode=104.192.102.155" >> $CONF_DIR/$CONF_FILE
echo "addnode=91.203.63.3" >> $CONF_DIR/$CONF_FILE
echo "addnode=18.216.63.158" >> $CONF_DIR/$CONF_FILE

   sudo nyxd -daemon
   
   
# installing sentinel

   sudo cd/root/nyx
   sudo apt-get update
   sudo apt-get -y install python-virtualenv
   sudo git clone https://github.com/nyxpay/sentinel.git && cd sentinel
   sudo apt install virtualenv -y
   sudo virtualenv ./venv
   sudo ./venv/bin/pip install -r requirements.txt
   sudo "nyx_conf=/root/.nyx/nyx.conf" >> $sentinel.conf
   
# add the "* * * * * cd /root/nyx/sentinel && ./venv/bin/python bin/sentinel.py >/dev/null 2>&1" in crontab    
if ! crontab -l | grep "* * * * * cd /root/nyx/sentinel && ./venv/bin/python bin/sentinel.py >/dev/null 2>&1"; then
  (crontab -l ; echo "* * * * * cd /root/nyx/sentinel && ./venv/bin/python bin/sentinel.py >/dev/null 2>&1") | crontab -
fi
   
   sudo cd /root/nyx/sentinel
   sudo SENTINEL_DEBUG=1 ./venv/bin/python bin/sentinel.py
   
   sudo nyx-cli stop
   sudo nyxd -daemon
   
   
