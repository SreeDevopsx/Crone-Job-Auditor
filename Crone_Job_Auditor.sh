#!/bin/bash

# ======================================================
# Cron Job Auditor
# Author: Sreedevops
# Purpose: Audit Linux Cron Jobs
# ======================================================

REPORT_DIR="$HOME/cron_audit_reports"
mkdir -p "$REPORT_DIR"

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
REPORT_FILE="$REPORT_DIR/cron_audit_$TIMESTAMP.txt"

echo "======================================================" > "$REPORT_FILE"
echo " CRON JOB AUDIT REPORT"
echo "======================================================" >> "$REPORT_FILE"
echo "Generated On : $(date)" >> "$REPORT_FILE"
echo "Hostname : $(hostname)" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# ------------------------------------------------------
# /etc/crontab
# ------------------------------------------------------

echo "1. SYSTEM CRONTAB (/etc/crontab)" >> "$REPORT_FILE"
echo "------------------------------------------------------" >> "$REPORT_FILE"

if [ -f /etc/crontab ]; then
    cat /etc/crontab >> "$REPORT_FILE"
else
    echo "/etc/crontab not found" >> "$REPORT_FILE"
fi

echo "" >> "$REPORT_FILE"

# ------------------------------------------------------
# Cron Directories
# ------------------------------------------------------

echo "2. CRON DIRECTORIES" >> "$REPORT_FILE"
echo "------------------------------------------------------" >> "$REPORT_FILE"

for DIR in \
/etc/cron.hourly \
/etc/cron.daily \
/etc/cron.weekly \
/etc/cron.monthly
do
    echo "" >> "$REPORT_FILE"
    echo "$DIR" >> "$REPORT_FILE"
    ls -la "$DIR" 2>/dev/null >> "$REPORT_FILE"
done

echo "" >> "$REPORT_FILE"

# ------------------------------------------------------
# Root Cron Jobs
# ------------------------------------------------------

echo "3. ROOT USER CRON JOBS" >> "$REPORT_FILE"
echo "------------------------------------------------------" >> "$REPORT_FILE"

crontab -l 2>/dev/null >> "$REPORT_FILE"

echo "" >> "$REPORT_FILE"

# ------------------------------------------------------
# All User Cron Jobs
# ------------------------------------------------------

echo "4. ALL USER CRON JOBS" >> "$REPORT_FILE"
echo "------------------------------------------------------" >> "$REPORT_FILE"

for USER in $(cut -f1 -d: /etc/passwd)
do
    CRON=$(crontab -u "$USER" -l 2>/dev/null)

    if [ ! -z "$CRON" ]; then
        echo "" >> "$REPORT_FILE"
        echo "User: $USER" >> "$REPORT_FILE"
        echo "----------------------" >> "$REPORT_FILE"
        echo "$CRON" >> "$REPORT_FILE"
    fi
done

echo "" >> "$REPORT_FILE"

# ------------------------------------------------------
# Suspicious Cron Entries
# ------------------------------------------------------

echo "5. SUSPICIOUS COMMAND DETECTION" >> "$REPORT_FILE"
echo "------------------------------------------------------" >> "$REPORT_FILE"

grep -RiE \
"curl|wget|nc |netcat|bash -i|python -c|perl -e" \
/etc/cron* 2>/dev/null >> "$REPORT_FILE"

echo "" >> "$REPORT_FILE"
