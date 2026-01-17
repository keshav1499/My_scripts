#!/bin/bash
sudo nbfc sensors set -f 0 -s /sys/class/hwmon/hwmon7/temp1_input -a Average
sudo nbfc sensors set -f 1 -s /sys/class/hwmon/hwmon5/temp1_input -s /sys/class/hwmon/hwmon5/temp2_input -a Max

