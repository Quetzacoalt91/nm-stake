FROM ubuntu:17.10

EXPOSE 33234
EXPOSE 33232
ENV PORT 33234
ENV IP 0.0.0.0
ENV CONF_DIR=/root/.Stake
ENV CONF_FILE=Stake.conf.sample

# Initial setup
RUN apt-get update && \
  apt-get -y upgrade && \
  apt-get -y autoremove && \
  apt-get -y install libgmp3-dev software-properties-common build-essential \
    libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils git cmake libboost-all-dev zlib1g-dev libz-dev libseccomp-dev libcap-dev libminiupnpc-dev \
    libminiupnpc10 libzmq5 libcanberra-gtk-module libqrencode-dev libzmq3-dev \
    libqt5gui5 libqt5core5a libqt5webkit5-dev libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler && \
  add-apt-repository -y ppa:bitcoin/bitcoin && \
  apt-get -y update && \
  apt-get install -y libdb4.8-dev libdb4.8++-dev libdb5.3 libdb5.3++ && \
  rm -rf /var/lib/apt/lists/*

# RUN cd /var && \
#   touch swap.img && \
#   chmod 600 swap.img && \
#   dd if=/dev/zero of=/var/swap.img bs=1024k count=2000 && \
#   mkswap /var/swap.img && \
#   swapon /var/swap.img && \
#   free && \
#   echo "/var/swap.img none swap sw 0 0" >> /etc/fstab && \
#   cd -

# Build
RUN cd /root && \
  git clone https://github.com/StakeDeveloper/stake.git && \
  cd stake/src && \
  make -f makefile.unix

RUN mkdir $CONF_DIR

RUN echo "rpcuser=user"`shuf -i 100000-10000000 -n 1` >> $CONF_DIR/$CONF_FILE && \
  echo "rpcpassword=pass"`shuf -i 100000-10000000 -n 1` >> $CONF_DIR/$CONF_FILE && \
  echo "rpcallowip=127.0.0.1" >> $CONF_DIR/$CONF_FILE && \
  echo "listen=1" >> $CONF_DIR/$CONF_FILE && \
  echo "server=1" >> $CONF_DIR/$CONF_FILE && \
  echo "daemon=1" >> $CONF_DIR/$CONF_FILE && \
  echo "" >> $CONF_DIR/$CONF_FILE && \
  echo "" >> $CONF_DIR/$CONF_FILE && \
  echo "port=$PORT" >> $CONF_DIR/$CONF_FILE

RUN cd /root/stake/src && \
  echo "masternode=1" >> $CONF_DIR/$CONF_FILE && \
  echo "masternodeprivkey=$PRIVKEY" >> $CONF_DIR/$CONF_FILE && \
  echo "" && \
  echo "addnode=104.33.47.15:33234" >> $CONF_DIR/$CONF_FILE && \
  echo "addnode=212.237.7.165:33234" >> $CONF_DIR/$CONF_FILE && \
  echo "addnode=94.142.142.19:33234" >> $CONF_DIR/$CONF_FILE && \
  echo "addnode=45.77.90.228:9027" >> $CONF_DIR/$CONF_FILE && \
  echo "addnode=83.248.130.95:33234" >> $CONF_DIR/$CONF_FILE && \
  echo "addnode=54.36.252.117:56627" >> $CONF_DIR/$CONF_FILE && \
  echo "addnode=94.130.245.71:33234" >> $CONF_DIR/$CONF_FILE && \
  echo "addnode=82.147.93.32:33234" >> $CONF_DIR/$CONF_FILE && \
  echo "addnode=51.15.162.24:33234" >> $CONF_DIR/$CONF_FILE && \
  echo "addnode=78.134.86.121:33234" >> $CONF_DIR/$CONF_FILE && \
  echo "addnode=173.249.40.44:33234" >> $CONF_DIR/$CONF_FILE && \
  echo "addnode=94.156.35.95:33234" >> $CONF_DIR/$CONF_FILE && \
  echo "addnode=197.32.88.3:64484" >> $CONF_DIR/$CONF_FILE && \
  echo "addnode=176.101.59.134:49864" >> $CONF_DIR/$CONF_FILE && \
  echo "addnode=77.37.218.80:65108" >> $CONF_DIR/$CONF_FILE

COPY run.sh /root/run.sh

WORKDIR /root/stake/src
ENTRYPOINT /root/run.sh
