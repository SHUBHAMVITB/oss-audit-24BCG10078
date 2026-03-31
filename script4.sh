#!/bin/bash
# =============================================================================
# Script 4: Log File Analyzer
# Author: Shubham Kumar | Roll No: 24BCG10078
# Course: Open Source Software | Capstone Project
# Description: Reads a log file line by line, counts keyword occurrences,
#              and prints a summary. Works with WSL system logs or any log file.
# Usage: ./script4_log_analyzer.sh [logfile] [keyword]
# Example: ./script4_log_analyzer.sh /var/log/dpkg.log "install"
# =============================================================================

# --- Command-line arguments ---
# $1 = log file path (optional — defaults to a WSL-friendly log)
# $2 = search keyword (optional — defaults to "error")

# --- Default to a log file that exists in WSL/Ubuntu ---
# Try to find a readable log file automatically
if [ -z "$1" ]; then
    # Try common log locations in order of preference
    for CANDIDATE in /var/log/dpkg.log /var/log/apt/history.log /var/log/auth.log /var/log/syslog; do
        if [ -f "$CANDIDATE" ] && [ -r "$CANDIDATE" ]; then
            LOGFILE="$CANDIDATE"
            break
        fi
    done
    # If none found, generate a sample log for demonstration
    if [ -z "$LOGFILE" ]; then
        LOGFILE="/tmp/sample_oss_audit.log"
        echo "Generating sample log file at $LOGFILE for demonstration..."
        cat > "$LOGFILE" << 'EOF'
2024-01-15 10:00:01 INFO  Python interpreter started
2024-01-15 10:00:02 INFO  Loading standard library modules
2024-01-15 10:00:03 WARNING Deprecated module usage detected
2024-01-15 10:00:04 ERROR  Module 'xyz' not found in sys.path
2024-01-15 10:00:05 INFO  pip package manager initialized
2024-01-15 10:00:06 WARNING pip version is outdated
2024-01-15 10:00:07 ERROR  Permission denied: /usr/local/lib
2024-01-15 10:00:08 INFO  Virtual environment activated
2024-01-15 10:00:09 ERROR  Syntax error in user_script.py line 42
2024-01-15 10:00:10 INFO  Script execution completed
2024-01-15 10:00:11 WARNING Unresolved import: numpy
2024-01-15 10:00:12 INFO  Open source: freedom to read and fix these errors!
EOF
    fi
else
    LOGFILE="$1"   # Use the file path provided as argument
fi

# --- Keyword to search for (default: "error") ---
KEYWORD=${2:-"error"}

# --- Counters for statistics ---
COUNT=0          # Count of lines matching keyword
TOTAL=0          # Total lines in file
WARNING_COUNT=0  # Count of WARNING lines (bonus metric)

echo "============================================================"
echo "         LOG FILE ANALYZER — OSS Capstone Project          "
echo "============================================================"
echo ""
echo "  Student  : Shubham Kumar | 24BCG10078"
echo "  Log File : $LOGFILE"
echo "  Keyword  : '$KEYWORD'"
echo "  Started  : $(date '+%d %B %Y %H:%M:%S')"
echo ""

# --- Validate: Check if log file exists ---
if [ ! -f "$LOGFILE" ]; then
    echo "  [✘] Error: File '$LOGFILE' not found."
    echo "  Try: ./script4_log_analyzer.sh /var/log/dpkg.log install"
    exit 1
fi

# --- Validate: Check if file is readable ---
if [ ! -r "$LOGFILE" ]; then
    echo "  [✘] Error: Cannot read '$LOGFILE'. Permission denied."
    echo "  Try: sudo ./script4_log_analyzer.sh $LOGFILE $KEYWORD"
    exit 1
fi

# --- Validate: Check if file is empty ---
if [ ! -s "$LOGFILE" ]; then
    echo "  [!] Warning: Log file is empty."
    echo "  Retrying with a different file..."
    LOGFILE="/tmp/sample_oss_audit.log"
    echo "  Switched to sample log: $LOGFILE"
fi

echo "------------------------------------------------------------"
echo "  SCANNING LOG FILE..."
echo "------------------------------------------------------------"
echo ""

# --- while read loop: Read file line by line ---
# IFS= preserves leading/trailing whitespace in each line
# -r flag prevents backslash interpretation
while IFS= read -r LINE; do
    TOTAL=$((TOTAL + 1))   # Increment total line counter

    # --- if-then: Check if line contains our keyword (case-insensitive) ---
    if echo "$LINE" | grep -iq "$KEYWORD"; then
        COUNT=$((COUNT + 1))   # Increment match counter
    fi

    # Also count WARNING lines as a bonus metric
    if echo "$LINE" | grep -iq "warning"; then
        WARNING_COUNT=$((WARNING_COUNT + 1))
    fi

done < "$LOGFILE"   # Feed file into the while loop

# --- Display summary ---
echo "  Total lines scanned : $TOTAL"
echo "  '$KEYWORD' found    : $COUNT times"
echo "  WARNINGs found      : $WARNING_COUNT times"
echo ""

# --- Show last 5 matching lines for context ---
echo "------------------------------------------------------------"
echo "  LAST 5 LINES MATCHING '$KEYWORD':"
echo "------------------------------------------------------------"
echo ""

# Use grep (case-insensitive) piped to tail to get last 5 matches
MATCHES=$(grep -i "$KEYWORD" "$LOGFILE" | tail -5)

if [ -n "$MATCHES" ]; then
    # Print each matching line with a prefix
    while IFS= read -r MATCH_LINE; do
        echo "  >> $MATCH_LINE"
    done <<< "$MATCHES"
else
    echo "  No matching lines found for keyword: '$KEYWORD'"
fi

echo ""
echo "------------------------------------------------------------"
echo "  ANALYSIS COMPLETE"
echo "------------------------------------------------------------"
echo ""

# Final verdict based on error count
if [ "$COUNT" -eq 0 ]; then
    echo "  [✔] No '$KEYWORD' entries found. Log looks clean."
elif [ "$COUNT" -lt 5 ]; then
    echo "  [!] Low count ($COUNT). Worth investigating."
else
    echo "  [✘] High count ($COUNT). Immediate attention recommended."
fi

echo ""
echo "  Open source advantage: Python's error messages and logs"
echo "  are fully readable because the source is open. You can"
echo "  trace any error back to the actual Python source code."
echo ""
echo "============================================================"
