#!/bin/bash
smt_state=$(cat /sys/devices/system/cpu/smt/control)

if [ "$smt_state" = "on" ]; then
  echo off | sudo tee /sys/devices/system/cpu/smt/control
  notify-send "SMT turned OFF"
else
  echo on | sudo tee /sys/devices/system/cpu/smt/control
  notify-send "SMT turned ON"
fi

