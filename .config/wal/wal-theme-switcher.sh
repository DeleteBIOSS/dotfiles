#!/bin/bash

case "$1" in
    --set-new)
        # Генерируем новую тему из указанной картинки
        wal -i "$2"
        ;;
    --reload)
        # Перезагружаем последнюю тему из кэша
        wal -R
        ;;
esac

# Копируем сгенерированный конфиг Kitty из кэша в папку с конфигами
cp -f ~/.cache/wal/kitty.conf ~/.config/kitty/kitty-wal.conf

# Загружаем новую тему во все окна Kitty
kitty @ set-colors -a --configured ~/.config/kitty/kitty-wal.conf

