#!/bin/bash

# Run with crontab -e 
#* * * * * /home/dennis/sensor_projects/pi_monitoring/cpu_usage.sh

# Replace these with your actual values
HOST="your_host"
PORT="host_port"
TOKEN="your_influxdb_token"
ORG="your_org"
BUCKET="your_bucket"

CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')

curl -s -XPOST "http://$HOST:$PORT/api/v2/write?org=$ORG&bucket=$BUCKET&precision=s" \
  -H "Authorization: Token $TOKEN" \
  --data-binary "cpu_usage,host=pi_zero2w value=$CPU_USAGE"
