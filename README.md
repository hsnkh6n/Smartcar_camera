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

12V → 5V power converters

SSD (for Android Pi4)

Ethernet cable (Pi4 ⇆ Pi2)
