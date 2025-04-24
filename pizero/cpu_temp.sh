#!/bin/bash

# Run with crontab -e 
#* * * * * /home/dennis/sensor_projects/pi_monitoring/cpu_temp.sh

# Replace these with your actual values
HOST="your_host"
PORT="host_port"
TOKEN="your_influxdb_token"
ORG="your_org"
BUCKET="your_bucket"

TEMP=$(</sys/class/thermal/thermal_zone0/temp)
TEMP_C=$(echo "scale=2; $TEMP / 1000" | bc)

curl -XPOST "http://$HOST:$PORT/api/v2/write?org=$ORG&bucket=$BUCKET&precision=s" \
  --header "Authorization: Token $TOKEN" \
  --data-binary "cpu_temp,host=pi_zero2w value=$TEMP_C"
