#!/bin/bash

# Название процесса, который нужно мониторить
PROCESS_NAME="test"

# URL сервера мониторинга, куда будем стучаться
MONITOR_URL="https://test.com/monitoring/test/api"

# Путь к лог-файлу
LOG_FILE="/var/log/monitoring.log"

# Файл, где будет храниться последний известный PID процесса
PID_FILE="/var/run/test_monitor.pid"

# Получаем PID процесса (точное совпадение имени, один PID)
CURRENT_PID=$(pgrep -xo "$PROCESS_NAME")

# Читаем последний PID, если файл существует
if [[ -f "$PID_FILE" ]]; then
    LAST_PID=$(cat "$PID_FILE")
else
    LAST_PID=""
fi

# Если процесс найден
if [[ -n "$CURRENT_PID" ]]; then
    # Сохраняем текущий PID в PID-файл
    echo "$CURRENT_PID" > "$PID_FILE"

    # Проверяем — изменился ли PID (значит процесс был перезапущен)
    if [[ "$LAST_PID" != "" && "$CURRENT_PID" != "$LAST_PID" ]]; then
        echo "$(date +'%Y-%m-%d %H:%M:%S') - Process $PROCESS_NAME restarted (old PID: $LAST_PID, new PID: $CURRENT_PID)" >> "$LOG_FILE"
    fi

    # Проверяем доступность сервера мониторинга
    curl -fsS --max-time 5 "$MONITOR_URL" > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        echo "$(date +'%Y-%m-%d %H:%M:%S') - Monitoring server unavailable" >> "$LOG_FILE"
    fi
fi

# Если процесса нет — ничего не делаем (по требованиям)
