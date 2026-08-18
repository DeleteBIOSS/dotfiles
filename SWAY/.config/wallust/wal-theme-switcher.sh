#!/usr/bin/env bash
# Восстанавливаем последнюю тему и обои

WALLPAPER=$(cat ~/.cache/wallust/last_wallpaper 2>/dev/null || echo ~/Wallpapers/Oboi.png)

if [ -f "$WALLPAPER" ]; then
    # Генерируем тему из последней картинки
    wallust run "$WALLPAPER"

    # Запускаем awww и ставим обои
    awww img "$WALLPAPER"
else
    echo "Файл обоев не найден: $WALLPAPER"
fi