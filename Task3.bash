#!/bin/bash

# Создание игрового поля
create_board() {
    board=( $(shuf -e {1..15} -n 15) "" )
}

# Вывод игрового поля
print_board() {
    echo "Ход: $moves"
    for ((i=0; i<4; i++)); do
        echo "${board[i*4]} ${board[i*4+1]} ${board[i*4+2]} ${board[i*4+3]}"
    done
    echo "Следующий ход (q для выхода): "
}

# Проверка завершения игры
check_win() {
    local win_board=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 "")
    if [ "${board[*]}" = "${win_board[*]}" ]; then
        echo "Поздравляем! Вы выиграли за $moves ходов."
        exit 0
    fi
}

# Обработка ввода пользователя
process_input() {
    local input
    read -r input
    if [ "$input" = "q" ]; then
        echo "Выход из игры."
        exit 0
    fi
    local empty_index=$(get_empty_index)
    local input_index=$(get_input_index $input)
    if [ -n "$input_index" ] && $(is_adjacent $empty_index $input_index); then
        board[$empty_index]=${board[$input_index]}
        board[$input_index]=""
        ((moves++))
    else
        echo "Некорректный ход. Попробуйте снова."
    fi
}

# Получение индекса пустой ячейки
get_empty_index() {
    for i in {0..15}; do
        if [ -z "${board[$i]}" ]; then
            echo $i
            break
        fi
    done
}

# Получение индекса ячейки по значению
get_input_index() {
    local value=$1
    for i in {0..15}; do
        if [ "${board[$i]}" = "$value" ]; then
            echo $i
            break
        fi
    done
}

# Проверка, являются ли ячейки соседними
is_adjacent() {
    local index1=$1
    local index2=$2
    local row1=$((index1 / 4))
    local col1=$((index1 % 4))
    local row2=$((index2 / 4))
    local col2=$((index2 % 4))
    if [ $row1 -eq $row2 ] && ( [ $((col1 - col2)) -eq 1 ] || [ $((col2 - col1)) -eq 1 ] ); then
        return 0
    elif [ $col1 -eq $col2 ] && ( [ $((row1 - row2)) -eq 1 ] || [ $((row2 - row1)) -eq 1 ] ); then
        return 0
    else
        return 1
    fi
}

# Основная часть игры

moves=0
create_board

while true; do
    print_board
    process_input
    check_win
done
