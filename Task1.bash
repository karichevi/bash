#!/bin/bash

correct_guesses=()
incorrect_guesses=()
generated_numbers=()
turn=1
exit_requested=0

function generate_random_number() {
echo $((0 + $RANDOM % 9 ))
}

function print_game_stats() {
total_turns=$(( ${#correct_guesses[@]} + ${#incorrect_guesses[@]} ))
if (( $total_turns > 0 )); then
correct_percentage=$(( ${#correct_guesses[@]} / total_turns * 100 ))
incorrect_percentage=$(( ${#incorrect_guesses[@]} / total_turns * 100 ))
echo "Доля угаданных чисел: $correct_percentage%"
echo "Доля не угаданных чисел: $incorrect_percentage%"
if (( ${#generated_numbers[@]} >= 10 )); then
last_guesses="${generated_numbers[*]: -10}"
echo "Последние загаданные числа: $last_guesses"
fi
fi
}

while (( $exit_requested == 0 )); do
read -p "Ход $turn. Введите число от 0 до 9 (или 'q' для выхода):" user_input
if [ "$user_input" == "q" ]; then
echo "$user_input"
exit_requested=1
echo "Игра завершена."
break
elif [[ "$user_input" =~ ^[0-9]$ ]]; then
generated_number=$( generate_random_number )
generated_numbers+=($generated_number)
if (( user_input == generated_number )); then
correct_guesses+=($user_input)
echo "Вы угадали число!"
else
incorrect_guesses+=($user_input)
echo "Вы не угадали, загаданное число было: $generated_number"
fi
turn=$((turn + 1))
print_game_stats
else
echo "Ошибка ввода. Попробуйте снова."
fi
done
