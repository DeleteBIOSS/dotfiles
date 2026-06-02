#!/bin/bash

# Убиваем все процессы polybar
killall -q polybar

# Ждём, пока они завершатся
while pgrep -u $UID -x polybar >/dev/null; do sleep 0.5; done

# Запускаем polybar для основного монитора
MONITOR=$(polybar -m | head -1 | cut -d: -f1)
MONITOR=$MONITOR polybar example &
