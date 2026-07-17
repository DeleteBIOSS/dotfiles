#!/bin/bash

# Файл, где хранится путь к последней картинке
WALLPAPER_CACHE="$HOME/.cache/wal/wallpaper"

# --- Восстановление последней темы и обоев ---
if [ -f "$WALLPAPER_CACHE" ]; then
    # Если есть сохранённый путь к обоям, используем его
    wal -i "$(cat $WALLPAPER_CACHE)"
else
    # Иначе берём дефолтную картинку
    wal -i ~/Wallpapers/Oboi.png
fi

# --- Обновление обоев в Sway ---
# Убиваем старый swaybg (если висит)
pkill swaybg 2>/dev/null
# Запускаем новый swaybg с текущими обоями
swaybg -i "$(cat $WALLPAPER_CACHE 2>/dev/null || echo ~/Wallpapers/Oboi.png)" -m fill &

# --- Применение цветов к Kitty ---
cp -f ~/.cache/wal/kitty.conf ~/.config/kitty/kitty-wal.conf
kitty @ set-colors -a --configured ~/.config/kitty/kitty-wal.conf 2>/dev/null
~/.config/theme/apply-theme.sh
