#!/usr/bin/env bash
set -euo pipefail

CON_NAME="Auto Ethernet"
UUID="42946314-4a7b-467b-8235-9c793edd64c0"
IFACE="enp5s0"

IP_ADDR="172.16.8.104/22"
GATEWAY="172.16.8.101"
DNS_SERVERS="218.248.112.193 218.248.112.225"

# check nmcli available
if ! command -v nmcli >/dev/null 2>&1; then
  echo "nmcli not found. Install NetworkManager and nmcli first."
  exit 2
fi

# If connection with that name exists, back it up & remove it
if nmcli -g NAME connection show | grep -xFq "$CON_NAME"; then
  echo "Connection '$CON_NAME' already exists. Backing it up then replacing it."
  BACKUP="/root/${CON_NAME// /_}-backup-$(date +%Y%m%d%H%M%S).nmconnection"
  nmcli connection export "$CON_NAME" "$BACKUP"
  echo "Backup saved to: $BACKUP"
  nmcli connection delete "$CON_NAME"
fi

echo "Creating static connection '$CON_NAME' for interface $IFACE"

# Create the ethernet connection with manual IPv4
nmcli connection add \
  type ethernet \
  con-name "$CON_NAME" \
  ifname "$IFACE" \
  uuid "$UUID" \
  autoconnect yes \
  connection.autoconnect-priority 0 \
  ipv4.method manual \
  ipv4.addresses "$IP_ADDR" \
  ipv4.gateway "$GATEWAY" \
  ipv4.dns "$DNS_SERVERS" \
  ipv4.dns-priority 0 \
  ipv4.never-default no \
  ipv6.method ignore \
  802-3-ethernet.mtu auto \
  802-3-ethernet.auto-negotiate no

# Optional: set some additional fields similar to your old profile
nmcli connection modify "$CON_NAME" \
  connection.zone "" \
  connection.metered unknown

echo "Bringing connection up now (this will apply the static IP to $IFACE)..."
if nmcli connection up "$CON_NAME"; then
  echo "Connection activated."
else
  echo "Warning: failed to bring connection up immediately. The profile was created — try:"
  echo "  nmcli connection up \"$CON_NAME\""
fi

echo
nmcli -f GENERAL,IP4,IP6,802-3-ethernet connection show "$CON_NAME"


