#!/bin/bash
# =============================================================================
# Script 2: FOSS Package Inspector
# Author: Shubham Kumar | Roll No: 24BCG10078
# Course: Open Source Software | Capstone Project
# Description: Checks if Python and related packages are installed,
#              displays version/license info, and explains their philosophy.
# =============================================================================

# --- Package to inspect (our chosen software) ---
PACKAGE="python3"

# --- Detect package manager (WSL usually runs Ubuntu/Debian) ---
# This makes the script work on both apt-based and rpm-based systems
if command -v dpkg &>/dev/null; then
    PKG_MANAGER="dpkg"    # Debian/Ubuntu/WSL
elif command -v rpm &>/dev/null; then
    PKG_MANAGER="rpm"     # Fedora/RHEL
else
    PKG_MANAGER="unknown"
fi

echo "============================================================"
echo "        FOSS PACKAGE INSPECTOR — Python Ecosystem          "
echo "============================================================"
echo ""

# --- if-then-else: Check if Python is installed ---
if command -v python3 &>/dev/null; then
    echo "[✔] $PACKAGE is INSTALLED on this system."
    echo ""

    # Get version info depending on package manager
    if [ "$PKG_MANAGER" = "dpkg" ]; then
        # Use dpkg to show installed python3 packages
        echo "--- Installed Python packages (dpkg) ---"
        dpkg -l | grep -E "^ii.*python3[^-]" | awk '{print "  Package:", $2, "| Version:", $3}'
    elif [ "$PKG_MANAGER" = "rpm" ]; then
        echo "--- RPM Info ---"
        rpm -qi python3 | grep -E 'Version|License|Summary'
    fi

    echo ""
    # Display Python version and location
    echo "  Python Binary : $(which python3)"
    echo "  Version       : $(python3 --version)"
    echo "  pip Version   : $(pip3 --version 2>/dev/null || echo 'pip not found')"

else
    # Package not found — inform user
    echo "[✘] $PACKAGE is NOT installed on this system."
    echo "  To install: sudo apt install python3 (Ubuntu/WSL)"
    echo "              sudo dnf install python3 (Fedora)"
fi

echo ""
echo "------------------------------------------------------------"
echo "  OPEN SOURCE PHILOSOPHY — case statement"
echo "------------------------------------------------------------"
echo ""

# --- case statement: Print philosophy note based on package ---
# This demonstrates the case construct for multi-branch decision making
case $PACKAGE in
    python3|python)
        echo "  Python: Born from Guido van Rossum's desire to make"
        echo "  programming accessible to everyone. PSF License ensures"
        echo "  Python stays free — 'batteries included' philosophy."
        ;;
    httpd|apache2)
        echo "  Apache: The web server that built the open internet."
        echo "  Powers ~30% of all websites. Apache License 2.0."
        ;;
    mysql|mariadb)
        echo "  MySQL/MariaDB: Open source at the heart of millions"
        echo "  of apps. A dual-license story — GPL and Commercial."
        ;;
    git)
        echo "  Git: The tool Linus built when proprietary VCS failed."
        echo "  GPL v2 — version control that changed software forever."
        ;;
    vlc)
        echo "  VLC: Built by students in Paris. Plays anything."
        echo "  LGPL/GPL — freedom to watch anything, anywhere."
        ;;
    firefox)
        echo "  Firefox: A nonprofit fighting for the open web."
        echo "  MPL 2.0 — because the browser matters."
        ;;
    *)
        # Default case for any other package
        echo "  This is an open-source tool that embodies the spirit"
        echo "  of sharing knowledge and building together freely."
        ;;
esac

echo ""
echo "------------------------------------------------------------"
echo "  PYTHON STANDARD LIBRARY CHECK"
echo "------------------------------------------------------------"
# Check a few important Python modules to show ecosystem richness
for MODULE in os sys json math; do
    python3 -c "import $MODULE; print('  [✔] Module:', '$MODULE', '— available')" 2>/dev/null \
        || echo "  [✘] Module: $MODULE — not available"
done

echo ""
echo "============================================================"
