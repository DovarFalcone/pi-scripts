#!/bin/bash

# Run with crontab -e 
# * * * * * find /home/dennis/sensor_data/pi-scripts/sensor -name '*.sh' -exec bash {} \;

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load config from the same directory
source "$SCRIPT_DIR/config.cfg"

# Collect CPU idle values over 10 seconds
idle_sum=0
for i in {1..10}; do
  IDLE=$(top -bn1 | grep "Cpu(s)" | awk -F',' '{print $4}' | awk '{print $1}')
  idle_sum=$(echo "$idle_sum + $IDLE" | bc)
  sleep 1
done

# Calculate average idle
avg_idle=$(echo "scale=2; $idle_sum / 10" | bc)

# Calculate usage as 100 - avg_idle
CPU_USAGE=$(echo "scale=2; 100 - $avg_idle" | bc)

# Send to InfluxDB
curl -s -XPOST "http://$HOST:$PORT/api/v2/write?org=$ORG&bucket=$BUCKET&precision=s" \
  -H "Authorization: Token $TOKEN" \
  --data-binary "cpu_usage,host=$INFLUX_HOST_TAG value=$CPU_USAGE"
