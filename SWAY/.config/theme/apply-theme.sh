#!/bin/bash
# Универсальный мостик Pywal -> Waybar + Wofi (v2)

COLORS_JSON="$HOME/.cache/wal/colors.json"
WAYBAR_CSS="$HOME/.config/theme/colors-waybar.css"
WOFI_STYLE="$HOME/.config/wofi/style.css"

# Проверка наличия файла цветов
if [ ! -f "$COLORS_JSON" ]; then
    echo "Ошибка: $COLORS_JSON не найден. Сначала запустите wal."
    exit 1
fi

# --- Определяем структуру JSON и извлекаем цвета ---
if jq -e '.colors.color0' "$COLORS_JSON" > /dev/null 2>&1; then
    # Новая структура (объект с вложенным "colors")
    BACKGROUND=$(jq -r '.colors.color0' "$COLORS_JSON")
    FOREGROUND=$(jq -r '.colors.color7' "$COLORS_JSON")
    ACCENT=$(jq -r '.colors.color4' "$COLORS_JSON")
elif jq -e '.color0' "$COLORS_JSON" > /dev/null 2>&1; then
    # Старая структура (плоский объект color0, color7...)
    BACKGROUND=$(jq -r '.color0' "$COLORS_JSON")
    FOREGROUND=$(jq -r '.color7' "$COLORS_JSON")
    ACCENT=$(jq -r '.color4' "$COLORS_JSON")
else
    echo "Неизвестная структура $COLORS_JSON"
    exit 1
fi

# --- 1. Генерируем файл для Waybar ---
cat > "$WAYBAR_CSS" << EOF
@define-color background $BACKGROUND;
@define-color foreground $FOREGROUND;
@define-color accent $ACCENT;
EOF

# --- 2. Генерируем самодостаточный CSS для Wofi ---
cat > "$WOFI_STYLE" << EOF
window {
    font-family: "JetBrainsMono Nerd Font", "Hack", sans-serif;
    font-size: 12px;
    background: $BACKGROUND;
    opacity: 0.9;
    border: 1px solid $FOREGROUND;
    border-radius: 8px;
}

#outer-box {
    padding: 10px;
}

#input {
    background: $BACKGROUND;
    opacity: 0.6;
    border: none;
    border-radius: 4px;
    padding: 8px;
    margin-bottom: 8px;
    color: $FOREGROUND;
}

#scroll {
    margin: 0;
}

#entry {
    padding: 6px 10px;
    margin: 2px 0;
    color: $FOREGROUND;
}

#entry:selected {
    background: $FOREGROUND;
    opacity: 0.4;
    color: $BACKGROUND;
    border-radius: 4px;
}
EOF

echo "Тема обновлена: $WAYBAR_CSS, $WOFI_STYLE"
# --- Генерация цветов для бордеров Sway ---
SWAY_THEME="$HOME/.config/theme/sway-theme.conf"

cat > "$SWAY_THEME" << EOF
# Автоматически сгенерировано apply-theme.sh из Pywal
set \$accent $ACCENT
set \$background $BACKGROUND
set \$foreground $FOREGROUND

# Цвета бордеров окон
client.focused          \$accent \$accent \$foreground \$accent \$accent
client.focused_inactive \$background \$background \$foreground \$background \$background
client.unfocused        \$background \$background \$foreground \$background \$background
client.urgent           \$accent \$accent \$foreground \$accent \$accent
EOF
swaymsg reload
