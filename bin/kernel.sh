#!/bin/bash

echo "Installed kernel: (from: pacman -Q linux)"
pacman -Q linux
echo ""
echo "Running kernel: (from: uname -r)"
uname -r