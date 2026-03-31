#!/bin/bash
# =============================================================================
# Script 3: Disk and Permission Auditor
# Author: Shubham Kumar | Roll No: 24BCG10078
# Course: Open Source Software | Capstone Project
# Description: Loops through important system directories and reports
#              permissions, ownership, and disk usage. Also checks
#              Python-specific directories.
# =============================================================================

# --- List of standard system directories to audit ---
DIRS=("/etc" "/var/log" "/home" "/usr/bin" "/tmp" "/usr/lib")

echo "============================================================"
echo "       DISK AND PERMISSION AUDITOR — OSS Capstone          "
echo "============================================================"
echo ""
echo "  Student: Shubham Kumar | Roll: 24BCG10078"
echo "  Software Audited: Python (PSF License)"
echo "  Date: $(date '+%d %B %Y %H:%M:%S')"
echo ""
echo "------------------------------------------------------------"
echo "  STANDARD SYSTEM DIRECTORIES"
echo "------------------------------------------------------------"
printf "  %-20s %-20s %-10s\n" "Directory" "Permissions(type user grp)" "Size"
echo "  $(printf '%0.s-' {1..55})"

# --- for loop: Iterate over each directory in the list ---
for DIR in "${DIRS[@]}"; do
    # Check if directory exists before trying to read it
    if [ -d "$DIR" ]; then
        # Extract permissions, owner, and group using awk on ls output
        PERMS=$(ls -ld "$DIR" | awk '{print $1, $3, $4}')
        # Get human-readable size; suppress permission errors with 2>/dev/null
        SIZE=$(du -sh "$DIR" 2>/dev/null | cut -f1)
        printf "  %-20s %-20s %-10s\n" "$DIR" "$PERMS" "${SIZE:-N/A}"
    else
        # Directory doesn't exist on this system (common in WSL)
        printf "  %-20s %s\n" "$DIR" "[ does not exist on this system ]"
    fi
done

echo ""
echo "------------------------------------------------------------"
echo "  PYTHON-SPECIFIC DIRECTORY AUDIT"
echo "------------------------------------------------------------"
echo ""

# --- Find where Python is installed on this system ---
PYTHON_BIN=$(which python3 2>/dev/null)

if [ -n "$PYTHON_BIN" ]; then
    echo "  Python binary found at: $PYTHON_BIN"
    echo ""

    # Build list of Python-specific paths to check
    PYTHON_DIRS=(
        "/usr/lib/python3"
        "/usr/lib/python3.10"
        "/usr/lib/python3.11"
        "/usr/lib/python3.12"
        "/usr/local/lib/python3"
        "/etc/python3"
    )

    # Also dynamically find the real python lib path
    PYTHON_LIB=$(python3 -c "import sys; print([p for p in sys.path if 'lib/python3' in p and p != ''][0])" 2>/dev/null)
    if [ -n "$PYTHON_LIB" ]; then
        PYTHON_DIRS+=("$PYTHON_LIB")
    fi

    echo "  Checking Python-related directories:"
    echo "  $(printf '%0.s-' {1..52})"

    # Loop through Python directories
    for PDIR in "${PYTHON_DIRS[@]}"; do
        if [ -d "$PDIR" ]; then
            PERMS=$(ls -ld "$PDIR" | awk '{print $1, $3, $4}')
            SIZE=$(du -sh "$PDIR" 2>/dev/null | cut -f1)
            echo "  [✔] $PDIR"
            echo "      Permissions: $PERMS | Size: ${SIZE:-N/A}"
            echo ""
        fi
    done

    # Check the pip packages directory (user installs)
    PIP_DIR="$HOME/.local/lib"
    if [ -d "$PIP_DIR" ]; then
        PERMS=$(ls -ld "$PIP_DIR" | awk '{print $1, $3, $4}')
        echo "  [✔] $PIP_DIR (user pip packages)"
        echo "      Permissions: $PERMS"
        echo ""
    fi

else
    echo "  [✘] Python3 not found in PATH."
fi

echo "------------------------------------------------------------"
echo "  SECURITY NOTE"
echo "------------------------------------------------------------"
echo ""
echo "  Why permissions matter for open-source software:"
echo "  - /usr/bin: world-readable (r-xr-xr-x) so all users can"
echo "    run installed programs like python3."
echo "  - /etc: config files should be root-owned to prevent"
echo "    unauthorized modification of system behaviour."
echo "  - /tmp: world-writable (rwxrwxrwx) but sticky bit (+t)"
echo "    prevents users from deleting each other's files."
echo "  - Python libs in /usr/lib are root-owned to prevent"
echo "    supply chain attacks via malicious module injection."
echo ""
echo "============================================================"
