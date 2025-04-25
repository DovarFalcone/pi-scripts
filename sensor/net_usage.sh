#!/bin/bash

# Run with crontab -e 
# * * * * * find /home/dennis/sensor_data/pi-scripts/sensor -name '*.sh' -exec bash {} \;


# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load config from the same directory
source "$SCRIPT_DIR/config.cfg"
 
RX_BYTES=$(cat /sys/class/net/wlan0/statistics/rx_bytes)
TX_BYTES=$(cat /sys/class/net/wlan0/statistics/tx_bytes)

curl -s -XPOST "http://$HOST:$PORT/api/v2/write?org=$ORG&bucket=$BUCKET&precision=s" \
  -H "Authorization: Token $TOKEN" \
  --data-binary "net_usage,host=$INFLUX_HOST_TAG rx_bytes=$RX_BYTES,tx_bytes=$TX_BYTES"
