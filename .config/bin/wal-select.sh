#!/usr/bin/env bash

# --- НАСТРОЙКИ ---
# Укажите путь к папке с вашими обоями
WALLPAPER_DIR="$HOME/Wallpapers"

# Проверяем, существует ли папка с обоями
if [ ! -d "$WALLPAPER_DIR" ]; then
    echo "Ошибка: Папка $WALLPAPER_DIR не найдена."
    exit 1
fi

# 1. Находим все изображения в папке и сохраняем их в массив
mapfile -t image_paths < <(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \))

# Проверяем, есть ли изображения в папке
if [ ${#image_paths[@]} -eq 0 ]; then
    echo "Ошибка: В папке $WALLPAPER_DIR не найдено изображений."
    exit 1
fi

# Создаём список с именами файлов (без пути) для отображения в Rofi
image_names=()
for path in "${image_paths[@]}"; do
    image_names+=("$(basename "$path")")
done

# 2. Показываем меню Rofi и сохраняем выбор пользователя
chosen_name=$(printf '%s\n' "${image_names[@]}" | sort | rofi -dmenu -p "Выберите обои:")

# Если пользователь ничего не выбрал (нажал Escape), выходим
if [ -z "$chosen_name" ]; then
    exit 0
fi

# 3. Находим полный путь к выбранному файлу
chosen_path=""
for path in "${image_paths[@]}"; do
    if [ "$(basename "$path")" == "$chosen_name" ]; then
        chosen_path="$path"
        break
    fi
done

# 4. Применяем выбранные обои и генерируем цветовую схему с помощью pywal
echo "Применяю: $chosen_name"
wal -i "$chosen_path"

# 5. (Опционально) Перезапускаем i3, чтобы обновить цвета в Polybar, Rofi и т.д.
i3-msg restart

echo "Готово!"
