#!/usr/bin/env bash
WALLPAPER_DIR="$HOME/Wallpapers"

if [ ! -d "$WALLPAPER_DIR" ]; then
    echo "Папка $WALLPAPER_DIR не найдена"
    exit 1
fi

# Поиск картинок
mapfile -t IMAGES < <(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | sort)
if [ ${#IMAGES[@]} -eq 0 ]; then
    echo "Нет изображений в $WALLPAPER_DIR"
    exit 1
fi

IMAGE_NAMES=()
for img in "${IMAGES[@]}"; do
    IMAGE_NAMES+=("$(basename "$img")")
done

CHOSEN_NAME=$(printf '%s\n' "${IMAGE_NAMES[@]}" | wofi --dmenu --prompt "Выбери обои")
if [ -z "$CHOSEN_NAME" ]; then
    exit 0
fi

for img in "${IMAGES[@]}"; do
    if [ "$(basename "$img")" = "$CHOSEN_NAME" ]; then
        CHOSEN_PATH="$img"
        break
    fi
done

# Устанавливаем обои через awww
awww img "$CHOSEN_PATH"

# Сохраняем путь к текущим обоям
echo "$CHOSEN_PATH" > ~/.cache/wallust/last_wallpaper

# Генерируем цветовую схему wallust
wallust run "$CHOSEN_PATH"

# Перезапускаем Waybar (чтобы подхватил новые цвета из colors-waybar.css)
pkill -SIGUSR2 waybar 2>/dev/null

echo "Обои обновлены: $CHOSEN_NAME"
swaymsg reload
