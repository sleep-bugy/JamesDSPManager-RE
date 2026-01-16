#!/system/bin/sh
# JamesDSPManager-RE Service Script
# Runs on boot

MODDIR=${0%/*}

# Wait for boot to complete
while [ "$(getprop sys.boot_completed)" != "1" ]; do
  sleep 1
done

# Wait a bit more for system to settle
sleep 5

# Start JamesDSP service
am startservice james.dsp/.service.HeadsetService

# Log
log -t JamesDSPRE "Service started"
