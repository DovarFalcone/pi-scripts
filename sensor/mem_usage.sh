#!/bin/bash

# Run with crontab -e 
#* * * * * /home/dennis/sensor_projects/pi_monitoring/mem_usage.sh

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load config from the same directory
source "$SCRIPT_DIR/config.cfg"

MEM_TOTAL=$(grep MemTotal /proc/meminfo | awk '{print $2}')
MEM_AVAILABLE=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
MEM_USED=$(echo "$MEM_TOTAL - $MEM_AVAILABLE" | bc)
MEM_USED_PERCENT=$(echo "scale=2; $MEM_USED / $MEM_TOTAL * 100" | bc)

curl -s -XPOST "http://$HOST:$PORT/api/v2/write?org=$ORG&bucket=$BUCKET&precision=s" \
  -H "Authorization: Token $TOKEN" \
  --data-binary "mem_usage,host=$INFLUX_HOST_TAG value=$MEM_USED_PERCENT"
