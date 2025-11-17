Permissions on Android:

chmod 755 /data/adb/service.d/10-eth0-network.sh
chmod 755 /data/adb/service.d/30-cam-watcher.sh
You can later extend this script to close the app when the stream is down, but Android doesn’t 
like force-closing apps from shell too much, so this basic version just opens when required.
