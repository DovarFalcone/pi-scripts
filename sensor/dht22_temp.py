import adafruit_dht
import board
import time

# Initialize the DHT22 sensor (adjust the pin number as needed)
dht_device = adafruit_dht.DHT22(board.D4)  # GPIO pin 4 (adjust as needed)

while True:
    try:
        # Read temperature and humidity
        temperature = dht_device.temperature
        humidity = dht_device.humidity

        if temperature is not None and humidity is not None:
            print(f"Temperature: {temperature:.1f}C  Humidity: {humidity:.1f}%")
        else:
            print("Failed to read from the sensor")

    except RuntimeError as error:
        # Errors are often caused by timing issues with the sensor
        print(error.args[0])

    time.sleep(2.0)
