#!/bin/bash
#
# start_cam_stack.sh
# Start MJPEG stream and optional sensor backend on Pi2
#

LOGFILE="/var/log/cam_stack.log"

echo "[$(date)] cam-stack: starting" >> "$LOGFILE"

# Camera device and resolution
VIDEO_DEV="/dev/video0"
RESOLUTION="1280x720"
FPS="30"
PORT="8080"
WWW_DIR="/usr/local/www"   # adjust to where mjpg_streamer www folder is

# Start mjpg_streamer
/usr/bin/mjpg_streamer \
  -i "input_uvc.so -d ${VIDEO_DEV} -r ${RESOLUTION} -f ${FPS}" \
  -o "output_http.so -p ${PORT} -w ${WWW_DIR}" \
  >> "$LOGFILE" 2>&1 &

echo "[$(date)] cam-stack: mjpg_streamer started on port ${PORT}" >> "$LOGFILE"

# OPTIONAL: Start distance sensor JSON backend
SENSOR_SCRIPT="/home/pi/sensors/distance.py"

if [ -x "$SENSOR_SCRIPT" ]; then
    echo "[$(date)] cam-stack: starting distance sensor script" >> "$LOGFILE"
    "$SENSOR_SCRIPT" >> "$LOGFILE" 2>&1 &
else
    echo "[$(date)] cam-stack: sensor script not found or not executable: $SENSOR_SCRIPT" >> "$LOGFILE"
fi

echo "[$(date)] cam-stack: all processes started" >> "$LOGFILE"
