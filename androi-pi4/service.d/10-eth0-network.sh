#!/system/bin/sh
#
# 10-eth0-network.sh
# Configure static IP and routing on Android (Raspberry Pi 4)
#

LOGFILE="/data/eth0-network.log"

echo "[$(date)] eth0-network: starting" >> "$LOGFILE"

# Wait for Android to finish bringing up interfaces
sleep 30

# Change this if your wired interface has a different name (e.g. usb0)
IFACE="eth0"

IP_ADDR="192.168.10.5"
NETMASK="255.255.255.0"
NETWORK="192.168.10.0/24"

# OPTIONAL: if you want Pi4 to be the gateway for Pi2's Internet,
# you can later add iptables MASQUERADE rules here (commented below).

# Bring interface up with static IP
ifconfig "$IFACE" "$IP_ADDR" netmask "$NETMASK" up 2>>"$LOGFILE"

# Ensure local route to 192.168.10.0/24 exists
ip route add "$NETWORK" dev "$IFACE" 2>>"$LOGFILE"

# If you ever want to set a default route via some gateway on this subnet:
# GATEWAY="192.168.10.1"
# ip route add default via "$GATEWAY" dev "$IFACE" 2>>"$LOGFILE"

# OPTIONAL: NAT (Pi4 as router for Pi2 through Wi-Fi)
# Uncomment and adjust if you later want Internet sharing:
#
# WIFI_IFACE="wlan0"
# echo 1 > /proc/sys/net/ipv4/ip_forward
# iptables -t nat -A POSTROUTING -o "$WIFI_IFACE" -j MASQUERADE
# iptables -A FORWARD -i "$IFACE" -o "$WIFI_IFACE" -j ACCEPT
# iptables -A FORWARD -i "$WIFI_IFACE" -o "$IFACE" -m state --state RELATED,ESTABLISHED -j ACCEPT

echo "[$(date)] eth0-network: configured $IFACE with $IP_ADDR/$NETMASK" >> "$LOGFILE"
