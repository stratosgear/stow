#!/bin/bash

echo "Installed kernel:"
echo "pacman -Q linux"
pacman -Q linux

echo ""
echo "Running kernel:"
echo "uname -r"
uname -r