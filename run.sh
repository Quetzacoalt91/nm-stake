#!/bin/sh


if [ ! -f /root/.Stake/Stake.conf ]; then
  cp /root/.Stake/Stake.conf.sample /root/.Stake/Stake.conf

  echo "masternodeaddr=$IP:$PORT" >> $CONF_DIR/Stake.conf

  ./staked -daemon
  echo ""
  sleep 2
  PRIVKEY=$(./staked masternode genkey)
  echo "$PRIVKEY"
  echo "Please copy this private key for a hot-cold setup"
  sleep 3
  echo "masternodeprivkey=$PRIVKEY" >> $CONF_DIR/Stake.conf

  ./staked stop
  echo "Pausing for 5 seconds to let the daemon restart"
  sleep 5
fi

./staked start
