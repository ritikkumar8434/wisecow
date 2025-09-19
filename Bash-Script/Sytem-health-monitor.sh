#!/bin/bash
# system_health.sh
# Monitors CPU, memory, disk usage, and running processes
# Logs alerts if thresholds are breached

LOG_FILE="/var/log/system_health.log"
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=80
PROCESS_THRESHOLD=300   # Example: alert if too many processes

echo "===== System Health Check: $(date) =====" >> "$LOG_FILE"

# CPU Usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
CPU_USAGE=${CPU_USAGE%.*}
if [ "$CPU_USAGE" -gt "$CPU_THRESHOLD" ]; then
    echo "ALERT: High CPU Usage - $CPU_USAGE% used" | tee -a "$LOG_FILE"
fi

# Memory Usage
MEM_USAGE=$(free | awk '/Mem/{printf("%.0f"), $3/$2*100}')
if [ "$MEM_USAGE" -gt "$MEM_THRESHOLD" ]; then
    echo "ALERT: High Memory Usage - $MEM_USAGE% used" | tee -a "$LOG_FILE"
fi

# Disk Usage
DISK_USAGE=$(df / | grep / | awk '{print $5}' | sed 's/%//')
if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
    echo "ALERT: High Disk Usage - $DISK_USAGE% used" | tee -a "$LOG_FILE"
fi

# Running Processes
PROC_COUNT=$(ps -e --no-headers | wc -l)
if [ "$PROC_COUNT" -gt "$PROCESS_THRESHOLD" ]; then
    echo "ALERT: High Number of Processes - $PROC_COUNT running" | tee -a "$LOG_FILE"
fi

echo "System Health Check Completed." >> "$LOG_FILE"
