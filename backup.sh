#!/bin/bash

# Variables
SOURCE_DIR="/var/www/html"    # Directory to back up
DEST_DIR="/tmp"               # Local temporary backup directory
REMOTE_USER="ubuntu"
REMOTE_HOST="3.110.128.30"
REMOTE_DIR="/home/ubuntu/backups"
LOG_FILE="/var/log/backup.log"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="backup_${TIMESTAMP}.tar.gz"

# Creating backup
echo "[INFO] Starting backup process at $(date)" | tee -a "$LOG_FILE"
tar -czf "${DEST_DIR}/${BACKUP_FILE}" "$SOURCE_DIR" 2>>"$LOG_FILE"

if [ $? -ne 0 ]; then
    echo "[ERROR] Failed to create archive file" | tee -a "$LOG_FILE"
    exit 1
fi
echo "[INFO] Backup archive created successfully: ${BACKUP_FILE}" | tee -a "$LOG_FILE"

# Copy backup to remote server
scp "${DEST_DIR}/${BACKUP_FILE}" "${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}" >>"$LOG_FILE" 2>&1

if [ $? -ne 0 ]; then
    echo "[ERROR] Backup upload failed" | tee -a "$LOG_FILE"
    exit 1
fi

echo "[SUCCESS] Backup successfully uploaded to remote server" | tee -a "$LOG_FILE"
echo "[INFO] Backup Completed at $(date)" | tee -a "$LOG_FILE"
exit 0
