#!/usr/bin/env bash
# Проверяет маршрутизацию трёх сайтов через проброшенные порты VirtualBox.
set -euo pipefail

# Проверяет HTTP 200, метку маршрута Nginx и заголовок страницы.
# Параметры: порт хоста, идентификатор приложения и текст заголовка.
check_site() {
    local port=$1 app=$2 title=$3
    local url="http://127.0.0.1:$port/" response

    if ! response=$(curl --noproxy '*' --silent --show-error --include --max-time 10 "$url" | tr -d '\r'); then
        printf 'Ошибка HTTP для %s на %s\n' "$app" "$url" >&2
        return 1
    fi

    if ! head -n 1 <<< "$response" | grep -Eq '^HTTP/[0-9.]+ 200([[:space:]]|$)' ||
        ! grep -Fxiq "X-Otus-App: $app" <<< "$response" ||
        ! grep -Fq "$title" <<< "$response"; then
        printf '%s на %s: ожидались HTTP 200, X-Otus-App: %s и текст %s\n%s\n' \
            "$app" "$url" "$app" "$title" "$(head -n 12 <<< "$response")" >&2
        return 1
    fi

    printf '%s → %s (HTTP 200)\n' "$url" "$title"
}

check_site 8081 django "OTUS Django"
check_site 8082 node "OTUS Node.js"
check_site 8083 wordpress "OTUS WordPress"

# Версия 1 · 2026-11-11 · Проверка HTTP, маршрута и страницы на каждом порту.
