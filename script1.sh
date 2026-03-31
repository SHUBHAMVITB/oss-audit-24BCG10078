#!/bin/bash
# =============================================================================
# Script 1: System Identity Report
# Author: Shubham Kumar | Roll No: 24BCG10078
# Course: Open Source Software | Capstone Project
# Description: Displays a welcome screen with system info and license details
# Software Audited: Python (PSF License)
# =============================================================================

# --- Variables ---
STUDENT_NAME="Shubham Kumar"        # Student's full name
ROLL_NO="24BCG10078"               # Registration number
SOFTWARE_CHOICE="Python"           # Chosen open-source software
LICENSE="Python Software Foundation License (PSF)" # Software license

# --- Gather System Information using command substitution $() ---
KERNEL=$(uname -r)                              # Linux kernel version
USER_NAME=$(whoami)                             # Current logged-in user
HOME_DIR=$HOME                                  # User's home directory
UPTIME=$(uptime -p)                             # Human-readable system uptime
CURRENT_DATE=$(date '+%A, %d %B %Y')           # Formatted current date
CURRENT_TIME=$(date '+%H:%M:%S')               # Current time in HH:MM:SS
DISTRO=$(grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')  # Distro name
PYTHON_VERSION=$(python3 --version 2>/dev/null || echo "Not installed")  # Python version

# --- OS License Detection ---
# Check if running under WSL (Windows Subsystem for Linux)
if grep -qi microsoft /proc/version 2>/dev/null; then
    OS_LICENSE="GNU General Public License v2 (GPLv2) — Linux Kernel"
    ENV_NOTE="Running inside WSL (Windows Subsystem for Linux)"
else
    OS_LICENSE="GNU General Public License v2 (GPLv2) — Linux Kernel"
    ENV_NOTE="Running on native Linux"
fi

# --- Display the System Identity Report ---
echo "============================================================"
echo "        OPEN SOURCE AUDIT — SYSTEM IDENTITY REPORT         "
echo "============================================================"
echo ""
echo "  Student   : $STUDENT_NAME"
echo "  Roll No   : $ROLL_NO"
echo "  Software  : $SOFTWARE_CHOICE"
echo ""
echo "------------------------------------------------------------"
echo "  SYSTEM INFORMATION"
echo "------------------------------------------------------------"
echo "  Distribution : $DISTRO"
echo "  Kernel       : $KERNEL"
echo "  Environment  : $ENV_NOTE"
echo ""
echo "  Logged-in As : $USER_NAME"
echo "  Home Dir     : $HOME_DIR"
echo "  Uptime       : $UPTIME"
echo "  Date         : $CURRENT_DATE"
echo "  Time         : $CURRENT_TIME"
echo ""
echo "------------------------------------------------------------"
echo "  OPEN SOURCE LICENSE INFO"
echo "------------------------------------------------------------"
echo "  OS License       : $OS_LICENSE"
echo "  Software License : $LICENSE"
echo "  Python Version   : $PYTHON_VERSION"
echo ""
echo "  Note: Python is released under the PSF License, which"
echo "  is a permissive license allowing free use, modification,"
echo "  and distribution — even in proprietary software."
echo "============================================================"
echo ""
