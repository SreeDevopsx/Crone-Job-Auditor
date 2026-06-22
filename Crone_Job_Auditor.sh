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

