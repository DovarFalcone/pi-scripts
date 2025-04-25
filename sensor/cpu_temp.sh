#!/bin/bash

# Run with crontab -e 
#* * * * * /home/dennis/sensor_projects/pi_monitoring/cpu_temp.sh

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load config from the same directory
source "$SCRIPT_DIR/config.cfg"

TEMP=$(</sys/class/thermal/thermal_zone0/temp)
TEMP_C=$(echo "scale=2; $TEMP / 1000" | bc)

curl -XPOST "http://$HOST:$PORT/api/v2/write?org=$ORG&bucket=$BUCKET&precision=s" \
  --header "Authorization: Token $TOKEN" \
  --data-binary "cpu_temp,host=$INFLUX_HOST_TAG value=$TEMP_C"
