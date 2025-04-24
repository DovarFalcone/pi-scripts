#!/bin/bash

# Run with crontab -e 
#* * * * * /home/dennis/sensor_projects/pi_monitoring/cpu_usage.sh

# Replace these with your actual values
HOST="your_host"
PORT="host_port"
TOKEN="your_influxdb_token"
ORG="your_org"
BUCKET="your_bucket"

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
  --data-binary "cpu_usage,host=pi_zero2w value=$CPU_USAGE"
