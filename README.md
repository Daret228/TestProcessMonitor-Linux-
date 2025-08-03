# 🔍 Test Process Monitor (Linux)

Мониторинг процесса `test` с уведомлением о перезапусках и проверкой доступности сервера мониторинга. Лёгкий Bash-скрипт + systemd timer для автоматизации.

---

## 📋 Описание

Этот проект предназначен для:
- Отслеживания процесса `test` в системе Linux.
- Проверки его перезапуска (смены PID).
- Периодического отправления HTTP-запросов на сервер мониторинга.
- Логирования ошибок при недоступности сервера или перезапуске процесса.

---

## 🗂️ Состав проекта

| Файл                             | Назначение                                    |
|----------------------------------|-----------------------------------------------|
| `bin/test_monitor.sh`            | Основной Bash-скрипт мониторинга              |
| `systemd/test-monitor.service`   | systemd-сервис для однократного запуска скрипта |
| `systemd/test-monitor.timer`     | systemd-таймер для запуска сервиса каждую минуту |

---

## ⚙️ Установка

### 1. Установить Bash-скрипт
```bash
sudo cp bin/test_monitor.sh /usr/local/bin/test_monitor.sh
sudo chmod +x /usr/local/bin/test_monitor.sh
sudo touch /var/log/monitoring.log
sudo chmod 644 /var/log/monitoring.log
````

### 2. Установить systemd service & timer

```bash
sudo cp systemd/test-monitor.service /etc/systemd/system/
sudo cp systemd/test-monitor.timer /etc/systemd/system/
```

### 3. Активировать таймер

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now test-monitor.timer
```

---

## 🛠️ Проверка работы

* Список таймеров:

  ```bash
  systemctl list-timers | grep test-monitor
  ```
* Просмотр логов скрипта:

  ```bash
  cat /var/log/monitoring.log
  ```
* Журнал выполнения сервиса:

  ```bash
  journalctl -u test-monitor.service
  ```

---

## 🚨 Логирование

Лог пишется в `/var/log/monitoring.log`:

* При перезапуске процесса (смене PID).
* При недоступности сервера мониторинга `https://test.com/monitoring/test/api`.

---

## 🔒 Требования

* Linux с systemd (Ubuntu 20.04+, CentOS 7+, Debian 10+).
* Утилиты: `bash`, `pgrep`, `curl`.

---

## ✍️ TODO (развитие)

* [ ] Email-уведомления о сбоях.
* [ ] Вебхуки в Telegram/Slack.
* [ ] Интеграция с Prometheus/Grafana (node\_exporter textfile collector).

---

## 📄 Лицензия

MIT License.

