# Android Pi4 – Head Unit

This folder contains scripts and configs used on the Raspberry Pi 4 running Android (head unit).

## Layout

- `service.d/`
  - `10-eth0-network.sh` – sets static IP on `eth0` and basic routing
  - `30-cam-watcher.sh` – watches Pi2 stream URL and launches the reverse camera app
- `configs/`
  - `config.txt` – sample Raspberry Pi boot config for HDMI display
  - `cmdline.txt` – sample Android kernel command line
  - `resolution.txt` – list of supported HDMI resolutions for this build

These files are examples: you copy them to the appropriate locations on your SD card or Android image (boot partition + `/data/adb/service.d/`).


chmod 755 /data/adb/service.d/10-eth0-network.sh
chmod 755 /data/adb/service.d/30-cam-watcher.sh
You can later extend this script to close the app when the stream is down, but Android doesn’t 
like force-closing apps from shell too much, so this basic version just opens when required.

