#!/bin/bash

PACKAGE_FILE="/home/bios/dotfiles/SCRIPTS/my-packages.txt"

if [ ! -f "$PACKAGE_FILE" ]; then
echo "File $PACKAGE_FILE not found"
exit 1
fi

PACKAGES=$(grep -v '^#' "$PACKAGE_FILE" | grep -v '^$' | tr '\n' ' ')

if [ -z "$PACKAGES" ]; then
    echo "Список пакетов пуст"
    exit 1
fi

echo "Будут установлены следующие пакеты:"
echo "$PACKAGES"
echo "Количество: $(echo "$PACKAGES" | wc -w)"

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
        sudo pacman -S --noconfirm $PACKAGES
        ;;
apt)
        sudo apt update && sudo apt install -y $PACKAGES
        ;;
dnf)
        sudo dnf install -y $PACKAGES
        ;;
xbps-install)
        sudo xbps-install -S $PACKAGES
        ;;
*)
echo "Oshibka"
exit 1
;;
esac
