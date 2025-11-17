Raspberry Pi Car Camera System

Multi-Pi Smart Car Cameras • Rear Backup Assist • Android Dashboard • CAN-Bus Integration

This project turns your car into a smart camera system using multiple Raspberry Pis.
It includes a rear-view camera, parking distance sensors, an Android dashboard display, and automatic power/shutdown logic triggered from CAN-Bus signals.

 Project Overview

This system uses three Raspberry Pis working together:

Pi2 — Rear Camera Node

Runs mjpg_streamer to stream 720p/1080p video

Hosts ultrasonic distance sensors via Python

Automatically sleeps or wakes based on Pi4 commands

Pi4 — Android Dashboard (Head Unit)

Runs Android OS from SSD

Receives video feed from Pi2

Uses service scripts to enable static IP, watchdog, and auto-launch camera app

Communicates with Pi2 over Ethernet tether

Pi3 — Optional Dashboard Pi (Legacy Plan)

Initially planned as extra display/logic node

Now merged with Pi4 Android head unit

 Features

✔ Rear-view camera with low-latency MJPEG streaming
✔ Parking assist using distance sensors (HC-SR04)
✔ Auto-wakeup and auto-sleep logic
✔ Static IP communication between Pi4 and Pi2
✔ Pi4 watchdog automatically launches camera app when Pi2 stream is detected
✔ CAN-Bus controlled safe shutdown when car is turned off
✔ Ethernet-over-USB or direct Ethernet communication

 Hardware Used

Raspberry Pi 4 (Android OS) — car dashboard display

Raspberry Pi 2 — rear camera + sensors

USB Camera (UVC compatible)

Ultrasonic Sensors (HC-SR04)

12–14 inch HDMI LCD

CAN-Bus USB adapter (MCP2515 or USB-CAN)
Network Setup
Pi4 (Android):
IP: 192.168.10.5
Subnet: 255.255.255.0
Gateway: none

Pi2 (Rear Camera):
IP: 192.168.10.2
Subnet: 255.255.255.0


Connection:
Pi4 (Android) → Ethernet → Pi2 (rear camera)

 Streaming Setup (Pi2 Rear Camera)
Start mjpg_streamer

start_stream.sh

#!/bin/bash
mjpg_streamer -i "input_uvc.so -d /dev/video0 -r 1280x720 -f 30" \
              -o "output_http.so -p 8080 -w ./www"


Access stream:

http://192.168.10.2:8080/?action=stream

Distance Sensor Script (Pi2)

distance.py

from gpiozero import DistanceSensor
from time import sleep

sensor = DistanceSensor(echo=17, trigger=4)

while True:
    print(sensor.distance)
    sleep(0.1)


Output served via Flask or simple JSON file for Pi4 to read.

 Pi4 Android Automation Scripts

Android uses Magisk service scripts stored in:

/data/adb/service.d/

★ Static IP on boot

10-eth0-static.sh

#!/system/bin/sh
sleep 30
ifconfig eth0 192.168.10.5 netmask 255.255.255.0 up

★ Camera App Auto-Launch Watcher

30-cam-watcher.sh

#!/system/bin/sh
LOGFILE="/data/cam-watcher.log"
APP_PKG="com.hsn.reversecam"
APP_COMPONENT="com.hsn.reversecam/.MainActivity"
STREAM_URL="http://192.168.10.2:8080/"
STATE="DOWN"

while true; do
    if curl -Is --max-time 2 "$STREAM_URL" | head -n 1 | grep -q "200"; then
        if [ "$STATE" = "DOWN" ]; then
            am start -n "$APP_COMPONENT"
            STATE="UP"
        fi
    else
        STATE="DOWN"
    fi
    sleep 10
done

🔌 Power & CAN-Bus Logic

Pi4 stays awake for N minutes after ignition is turned off to upload footage.
Then it sends Pi2:

ssh pi@192.168.10.2 "sudo shutdown -h now"


Then power relay cuts 5V to Pi2.
Finally Pi4 enters Android deep sleep.

12V → 5V power converters

SSD (for Android Pi4)

Ethernet cable (Pi4 ⇆ Pi2)
