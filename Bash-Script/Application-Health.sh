#!/bin/bash
# app_health.sh
# Checks if a web application is UP or DOWN using HTTP status codes

URL="http://localhost:8080"   # Replace with your app URL
LOG_FILE="/var/log/app_health.log"

STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$URL")

if [ "$STATUS_CODE" -eq 200 ]; then
    echo "$(date): Application is UP (Status: $STATUS_CODE)" | tee -a "$LOG_FILE"
else
    echo "$(date): ALERT - Application is DOWN (Status: $STATUS_CODE)" | tee -a "$LOG_FILE"
fi
