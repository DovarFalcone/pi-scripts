#!/bin/bash

# Run with crontab -e 
# * * * * * /home/dennis/sensor_projects/pi_monitoring/net_usage.sh

# Replace these with your actual values
HOST="your_host"
PORT="host_port"
TOKEN="your_influxdb_token"
ORG="your_org"
BUCKET="your_bucket"
 
RX_BYTES=$(cat /sys/class/net/wlan0/statistics/rx_bytes)
TX_BYTES=$(cat /sys/class/net/wlan0/statistics/tx_bytes)

curl -s -XPOST "http://$HOST:$PORT/api/v2/write?org=$ORG&bucket=$BUCKET&precision=s" \
  -H "Authorization: Token $TOKEN" \
  --data-binary "net_usage,host=pi_zero2w rx_bytes=$RX_BYTES,tx_bytes=$TX_BYTES"
