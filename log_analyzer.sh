#!/bin/bash

LOG_FILE="/var/log/nginx/access.log"

echo "===== Web Server Log Analysis Report ====="
echo "Log File: $LOG_FILE"
echo "Generated: $(date)"
echo "------------------------------------------"

# Count 404 errors
ERROR_404=$(grep " 404 " "$LOG_FILE" | wc -l)
echo "Total 404 Errors: $ERROR_404"

echo "------------------------------------------"
echo "Top 5 Most Requested Pages:"
awk '{print $7}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -5

echo "------------------------------------------"
echo "Top 5 IP Addresses with Most Requests:"
awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -5

echo "------------------------------------------"
echo "Report Completed."
