#!/bin/bash
#OBNOVA TIPA
PKG=""

if command -v pacman &> /dev/null; then
    PKG="pacman"
elif command -v apt &> /dev/null; then
    PKG="apt"
elif command -v dnf &> /dev/null; then
    PKG="dnf"
elif command -v xbps-install &> /dev/null; then
    PKG="xbps-install"
else
    echo "pkg not found"
    exit 1
fi

case "$PKG" in
pacman)
	sudo pacman -Syu --noconfirm
	echo "updated with pacman"
	;;
apt)
	sudo apt update && sudo apt upgrade -y
	echo "updated with apt"
	;;
dnf)
	sudo dnf upgrade -y
	echo "updated with dnf"
	;;
xbps-install)
	sudo xbps-install -Su
	echo "updated with xbps"
	;;
*)
echo "Oshibka"
exit 1
;;
esac
