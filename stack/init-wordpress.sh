#!/bin/sh
# Устанавливает WordPress при первом запуске, сохраняя существующий сайт.
set -eu

if wp core is-installed; then
    exit 0
fi

wp core install \
    --url='http://127.0.0.1:8083' \
    --title='OTUS WordPress' \
    --admin_user=otusadmin \
    --admin_password="$WORDPRESS_ADMIN_PASSWORD" \
    --admin_email=admin@example.test \
    --skip-email

# Версия 1 · 2026-11-11 · Автоматическая первоначальная установка WordPress.
