#!/bin/bash

# Run with crontab -e 
# * * * * * find /home/dennis/sensor_data/pi-scripts/sensor -name '*.sh' -exec bash {} \;

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load config from the same directory
source "$SCRIPT_DIR/config.cfg"

DISK_USED_PERCENT=$(df / | tail -1 | awk '{print $5}' | tr -d '%')

curl -s -XPOST "http://$HOST:$PORT/api/v2/write?org=$ORG&bucket=$BUCKET&precision=s" \
  -H "Authorization: Token $TOKEN" \
  --data-binary "disk_usage,host=$INFLUX_HOST_TAG value=$DISK_USED_PERCENT"
