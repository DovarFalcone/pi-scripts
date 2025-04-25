import adafruit_dht
import board
import time
import subprocess
import os

# Load config from config.cfg in the same directory
config = {}
script_dir = os.path.dirname(os.path.realpath(__file__))
with open(os.path.join(script_dir, "config.cfg")) as f:
    for line in f:
        if line.strip() and not line.strip().startswith("#"):
            key, value = line.strip().split("=", 1)
            config[key.strip()] = value.strip().strip('"')

# Extract config values
HOST = config.get("HOST")
PORT = config.get("PORT")
TOKEN = config.get("TOKEN")
ORG = config.get("ORG")
BUCKET = config.get("BUCKET")
INFLUX_HOST_TAG = config.get("INFLUX_HOST_TAG")

# Setup DHT22 on GPIO4 (pin 36)
dht_device = adafruit_dht.DHT22(board.D16)

def read_sensor():
    for _ in range(5):
        try:
            temp_c = dht_device.temperature
            temp_f = temp_c * 9 / 5 + 32 if temp_c is not None else None
            humidity = dht_device.humidity
            if temp_c is not None and humidity is not None:
                return temp_c, temp_f, humidity
        except RuntimeError:
            time.sleep(1.0)
    return None, None, None

temp_c, temp_f, humidity = read_sensor()

if temp_c is not None and humidity is not None:
    line = (
        f'dht22,host={INFLUX_HOST_TAG} '
        f'temp_c={temp_c:.2f},temp_f={temp_f:.2f},humidity={humidity:.2f}'
    )
    curl_cmd = [
        "curl", "-s", "-XPOST",
        f"http://{HOST}:{PORT}/api/v2/write?org={ORG}&bucket={BUCKET}&precision=s",
        "-H", f"Authorization: Token {TOKEN}",
        "--data-binary", line
    ]
    subprocess.run(curl_cmd)