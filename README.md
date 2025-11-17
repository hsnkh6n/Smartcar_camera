🚗 SmartCar Camera System
Multi-Raspberry-Pi Rear Camera, Parking Assist & Android Head Unit

This project creates a smart rear-camera and parking assist system using a Raspberry Pi 2 (camera node) and a Raspberry Pi 4 running Android (head unit).
The goal is to replace traditional reverse cameras with a fast, low-latency streaming solution, combined with distance sensing and optional CAN-Bus integration.

📸 System Architecture
Pi4 – Android Head Unit

Runs Android from SSD
• Displays the live camera feed
• Controls power/wakeup for Pi2
• Automatically launches the camera app
• Handles networking (static IP, routing, ADB)

Pi2 – Rear Camera Node

Runs Raspberry Pi OS
• Streams MJPEG video at low-latency
• Runs ultrasonic distance sensors
• Starts automatically on boot
• Sends stream to Pi4 over Ethernet

🗂 Repository Structure
Smartcar_camera/
│
├── android_pi4/
│   ├── service.d/
│   │   ├── 10-eth0-network.sh      # Static IP + routing
│   │   ├── 30-cam-watcher.sh       # Auto-launch camera app
│   ├── configs/
│   │   ├── config.txt
│   │   ├── cmdline.txt
│   │   ├── resolution.txt
│
├── pi2_rear_camera/
│   ├── mjpg_streamer/
│   │   ├── start_cam_stack.sh      # Start streamer + sensors
│   ├── sensors/
│   │   ├── distance.py             # HC-SR04 example
│   ├── systemd/
│       ├── cam-stack.service       # Auto-start at boot
│
└── android_app/
    └── (Android Studio Project)

📡 Network Setup
Pi4 (Android Head Unit)
IP: 192.168.10.5
NETMASK: 255.255.255.0
GATEWAY: none (local link only)

Pi2 (Rear Camera Node)
IP: 192.168.10.2
NETMASK: 255.255.255.0

Direct Connection

Pi4 <—Ethernet—> Pi2
(No router required.)

⚙️ Android Pi4 Boot Scripts
📌 Static IP & Routing

android_pi4/service.d/10-eth0-network.sh configures Ethernet:

ifconfig eth0 192.168.10.5 netmask 255.255.255.0 up
ip route add 192.168.10.0/24 dev eth0

📌 Auto-Launch Camera App

android_pi4/service.d/30-cam-watcher.sh checks the stream and opens:

com.hsn.reversecam/.MainActivity

🎥 Pi2 Rear Camera (mjpg_streamer)

The Pi2 starts MJPEG streaming using:

http://192.168.10.2:8080/?action=stream

Startup Script

pi2_rear_camera/mjpg_streamer/start_cam_stack.sh

mjpg_streamer -i "input_uvc.so -d /dev/video0 -r 1280x720 -f 30" \
              -o "output_http.so -p 8080 -w /usr/local/www"

Auto-start via systemd

pi2_rear_camera/systemd/cam-stack.service

[Service]
ExecStart=/home/pi/pi2_rear_camera/mjpg_streamer/start_cam_stack.sh
Restart=on-failure


Enable with:

sudo systemctl enable cam-stack.service

🔌 Power Management (Optional CAN-Bus)

Planned features:

✔ Pi4 stays awake for N minutes after car shutdown
✔ Uploads video to cloud
✔ Sends graceful shutdown to Pi2
✔ Cuts power with a relay
✔ Pi4 enters deep sleep

(Code will be added after CAN-Bus integration)

🧪 Testing the System
1. Start the camera on Pi2
sudo systemctl start cam-stack.service

2. SSH into Android Pi4 & check static IP
ip a


You should see eth0 with 192.168.10.5.

3. Ensure the stream is reachable

Open on Pi4 browser:

http://192.168.10.2:8080/?action=stream

4. Put the car in reverse

Your Android app should auto-launch.

📱 Android App (com.hsn.reversecam)

This folder contains a minimal Android app that:

Runs full-screen

Opens the MJPEG stream

Auto-rotates to landscape

Forces keep-screen-on

📌 Located in:
android_app/

🚀 Future Features

AI lane detection

Parking overlay lines

Side cameras (3-camera setup)

Cloud upload system

GPS + acceleration logging

Full DVR recording

🧾 License

MIT License (You may use, modify, distribute freely)
This repo is made with help of ChatGpt

💬 Contact

Project by Hassan (hsnkhan)
Feel free to open Issues or submit Pull Requests.
