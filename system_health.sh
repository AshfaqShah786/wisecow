#!/bin/bash

# Thresholds
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=90
LOG_FILE="system_health.log"

echo "------ System Health Check: $(date) ------" >> $LOG_FILE

# CPU Usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print int($2 + $4)}')
if [ "$CPU_USAGE" -gt "$CPU_THRESHOLD" ]; then
  echo "[WARNING] CPU usage is high: ${CPU_USAGE}%" >> $LOG_FILE
else
  echo "CPU usage: ${CPU_USAGE}%" >> $LOG_FILE
fi

# Memory Usage
MEM_USAGE=$(free | awk '/Mem/{printf("%d"), $3/$2*100}')
if [ "$MEM_USAGE" -gt "$MEM_THRESHOLD" ]; then
  echo "[WARNING] Memory usage is high: ${MEM_USAGE}%" >> $LOG_FILE
else
  echo "Memory usage: ${MEM_USAGE}%" >> $LOG_FILE
fi

# Disk Usage
DISK_USAGE=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
  echo "[WARNING] Disk usage is high: ${DISK_USAGE}%" >> $LOG_FILE
else
  echo "Disk usage: ${DISK_USAGE}%" >> $LOG_FILE
fi

# Running Processes
PROC_COUNT=$(ps aux | wc -l)
echo "Number of running processes: $PROC_COUNT" >> $LOG_FILE

echo "---------------------------------------" >> $LOG_FILE

