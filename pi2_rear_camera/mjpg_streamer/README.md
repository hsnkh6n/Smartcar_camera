
# Pi2 – Rear Camera Node

This folder contains the scripts used on the Raspberry Pi 2 that runs the USB camera and (optionally) the distance sensor.

## Layout

- `mjpg_streamer/`
  - `start_cam_stack.sh` – starts mjpg_streamer and the sensor backend
- `sensors/`
  - `distance.py` – simple distance sensor example using gpiozero
- `systemd/`
  - `cam-stack.service` – systemd unit to launch `start_cam_stack.sh` at boot

Set a static IP on this Pi (e.g. `192.168.10.2/24`) so the Android head unit can reach the stream.


Make it executable:

chmod +x /home/pi/pi2_rear_camera/mjpg_streamer/start_cam_stack.sh


Option A – Run at boot with systemd (recommended)

Create:

File: /etc/systemd/system/cam-stack.service

[Unit]
Description=Rear Camera Stream + Sensor Stack
After=network.target

[Service]
Type=simple
User=pi
WorkingDirectory=/home/pi/pi2_rear_camera/mjpg_streamer
ExecStart=/home/pi/pi2_rear_camera/mjpg_streamer/start_cam_stack.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target


Enable it:

sudo systemctl daemon-reload
sudo systemctl enable cam-stack.service
sudo systemctl start cam-stack.service

Option B – Run at boot with crontab
crontab -e


Add:

@reboot /home/pi/pi2_rear_camera/mjpg_streamer/start_cam_stack.sh
