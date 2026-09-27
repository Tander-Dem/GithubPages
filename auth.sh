#!/usr/bin/env bash
# ------------------------------------------------------------
# auth.sh — імітація авторизації в системі в текстовому режимі
# Запуск:  chmod +x auth.sh && ./auth.sh
# Тестовий обліковий запис:  student / linux123
# ------------------------------------------------------------

USERNAME="student"
# Пароль не зберігаємо відкритим текстом — лише його SHA-256 хеш
PASS_HASH="791e4e58b732fdf54ab99f052d4e99d058fbe4bdd74e3463b8535e04d3d2da9d"
MAX_TRIES=3
HOST=$(hostname)

clear
echo "GNU/Linux 6.8.0 ${HOST} tty1"
echo

for (( try = 1; try <= MAX_TRIES; try++ )); do
    read -r -p "${HOST} login: " login
    read -r -s -p "Password: " password     # -s — символи не відображаються
    echo

    input_hash=$(printf '%s' "$password" | sha256sum | cut -d ' ' -f 1)

    if [[ "$login" == "$USERNAME" && "$input_hash" == "$PASS_HASH" ]]; then
        echo
        echo "Last login: $(date '+%a %b %d %H:%M:%S %Y') on tty1"
        echo "Вітаємо, ${login}! Вхід виконано успішно."
        echo "Домашній каталог: /home/${login}"
        echo
        exit 0
    fi

    sleep 1                                  # затримка ускладнює підбір пароля
    echo "Login incorrect"
    left=$(( MAX_TRIES - try ))
    if (( left > 0 )); then
        echo "Залишилось спроб: ${left}"
        echo
    fi
done

echo
echo "Забагато невдалих спроб. Доступ тимчасово заблоковано."
exit 1
