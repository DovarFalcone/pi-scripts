#!/bin/bash

# Run with crontab -e 
#* * * * * /home/dennis/sensor_projects/temperature/cpu_temp.sh

# Replace these with your actual values
TOKEN="your_influxdb_token"
ORG="your_org"
BUCKET="raspberrypi"

TEMP=$(</sys/class/thermal/thermal_zone0/temp)
TEMP_C=$(echo "scale=2; $TEMP / 1000" | bc)

curl -XPOST "http://10.0.0.120:8086/api/v2/write?org=$ORG&bucket=$BUCKET&precision=s" \
  --header "Authorization: Token $TOKEN" \
  --data-binary "cpu_temp,host=pi_zero2w value=$TEMP_C"
