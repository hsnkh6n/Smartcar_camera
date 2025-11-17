#!/system/bin/sh
#
# 30-cam-watcher.sh
# Monitor Pi2 MJPEG stream and auto-launch reverse camera app
#

LOGFILE="/data/cam-watcher.log"

# Your Android app package + main activity
APP_PKG="com.hsn.reversecam"
APP_COMPONENT="com.hsn.reversecam/.MainActivity"

# Stream URL exposed by Pi2 (mjpg_streamer)
STREAM_URL="http://192.168.10.2:8080/"

STATE="DOWN"

echo "[$(date)] cam-watcher: starting" >> "$LOGFILE"

# Give network stack time to come up
sleep 40

while true; do
    # Check if the Pi2 stream is up (HTTP 200)
    if curl -Is --max-time 2 "$STREAM_URL" 2>/dev/null | head -n 1 | grep -q "200"; then
        if [ "$STATE" = "DOWN" ]; then
            echo "[$(date)] cam-watcher: stream UP, launching app" >> "$LOGFILE"
            # Start the Android activity
            am start -n "$APP_COMPONENT" >> "$LOGFILE" 2>&1
            STATE="UP"
        fi
    else
        if [ "$STATE" = "UP" ]; then
            echo "[$(date)] cam-watcher: stream DOWN, marking OFFLINE" >> "$LOGFILE"
        fi
        STATE="DOWN"
    fi

    # Check every 10 seconds
    sleep 10
done
