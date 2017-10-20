#!/bin/bash

set -e

date
ps axjf

sudo apt-get update

NPROC=$(nproc)
echo "nproc: $NPROC"

sudo apt-get install -y qt4-qmake libqt4-dev libminiupnpc-dev libdb++-dev libdb-dev libcrypto++-dev libqrencode-dev libboost-all-dev build-essential libboost-system-dev libboost-filesystem-dev libboost-program-options-dev libboost-thread-dev libboost-filesystem-dev libboost-program-options-dev libboost-thread-dev libssl-dev libdb++-dev libssl-dev ufw git
sudo add-apt-repository -y ppa:bitcoin/bitcoin
sudo apt-get update
sudo apt-get install -y libdb4.8-dev libdb4.8++-dev

cd /
file=/hshare
if [ ! -e "$file" ]
then
        sudo git clone https://github.com/ivories/Hshare.git
fi

cd /hshare/src
file=/hshare/src/hshared
if [ ! -e "$file" ]
then
        sudo make -j$NPROC -f makefile.unix
fi

sudo cp /hshare/src/hshared /usr/bin/hshared

################################################################
# Configure to auto start at boot                                      #
################################################################
file=$HOME/.hshare
if [ ! -e "$file" ]
then
        sudo mkdir $HOME/.hshare
fi
printf '%s\n%s\n%s\n%s\n' 'daemon=1' 'server=1' 'rpcuser=u' 'rpcpassword=p' | sudo tee $HOME/.hshare/hshare.conf

/usr/bin/hshared

