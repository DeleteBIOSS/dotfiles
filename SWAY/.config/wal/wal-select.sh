#!/bin/bash
# Скрипт для смены обоев через Wofi + Pywal

WALLPAPER_DIR="$HOME/Wallpapers"

# Проверяем, что папка существует
if [ ! -d "$WALLPAPER_DIR" ]; then
    echo "Папка $WALLPAPER_DIR не найдена"
    exit 1
fi

# Ищем все картинки в папке (jpg, jpeg, png)
mapfile -t IMAGES < <(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | sort)

if [ ${#IMAGES[@]} -eq 0 ]; then
    echo "Нет изображений в $WALLPAPER_DIR"
    exit 1
fi

# Готовим список для Wofi (только имена файлов)
IMAGE_NAMES=()
for img in "${IMAGES[@]}"; do
    IMAGE_NAMES+=("$(basename "$img")")
done

# Показываем Wofi в режиме dmenu
CHOSEN_NAME=$(printf '%s\n' "${IMAGE_NAMES[@]}" | wofi --dmenu --prompt "Выбери обои")

if [ -z "$CHOSEN_NAME" ]; then
    exit 0  # Ничего не выбрано
fi

# Находим полный путь к выбранному файлу
for img in "${IMAGES[@]}"; do
    if [ "$(basename "$img")" = "$CHOSEN_NAME" ]; then
        CHOSEN_PATH="$img"
        break
    fi
done

# Применяем тему Pywal
wal -i "$CHOSEN_PATH"
~/.config/theme/apply-theme.sh
pkill waybar && waybar &
# Сохраняем путь к текущим обоям (чтобы wal-theme-switcher.sh мог восстановить)
echo "$CHOSEN_PATH" > ~/.cache/wal/wallpaper

# Обновляем обои в Sway
pkill swaybg 2>/dev/null
swaybg -i "$CHOSEN_PATH" -m fill &

echo "Обои обновлены: $CHOSEN_NAME"
