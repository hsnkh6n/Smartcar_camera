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
