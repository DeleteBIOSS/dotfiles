#!/bin/bash
# Восстанавливаем последнюю тему и обои при старте

WALLPAPER=$(cat ~/.cache/wallust/last_wallpaper 2>/dev/null || echo ~/Wallpapers/Oboi.png)

if [ -f "$WALLPAPER" ]; then
    wallust run "$WALLPAPER"
    # Запускаем swww, если ещё не запущен, и ставим обои
    if ! pgrep -x swww-daemon > /dev/null; then
        swww init
        sleep 0.5
    fi
    swww img "$WALLPAPER"
else
    echo "Файл обоев не найден: $WALLPAPER"
fi