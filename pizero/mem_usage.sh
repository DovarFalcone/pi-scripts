#!/bin/bash

# Run with crontab -e 
#* * * * * /home/dennis/sensor_projects/pi_monitoring/mem_usage.sh

# Replace these with your actual values
HOST="your_host"
PORT="host_port"
TOKEN="your_influxdb_token"
ORG="your_org"
BUCKET="your_bucket"

MEM_TOTAL=$(grep MemTotal /proc/meminfo | awk '{print $2}')
MEM_AVAILABLE=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
MEM_USED=$(echo "$MEM_TOTAL - $MEM_AVAILABLE" | bc)
MEM_USED_PERCENT=$(echo "scale=2; $MEM_USED / $MEM_TOTAL * 100" | bc)

curl -s -XPOST "http://$HOST:$PORT/api/v2/write?org=$ORG&bucket=$BUCKET&precision=s" \
  -H "Authorization: Token $TOKEN" \
  --data-binary "mem_usage,host=pi_zero2w value=$MEM_USED_PERCENT"
