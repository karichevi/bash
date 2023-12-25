#!/bin/bash

path="."
mask="*"
countofunits=$(nproc)

while [[ $# -gt 0 ]]; do
  case "$1" in
    --path)
      path="$2"
      shift 2
      ;;
    --mask)
      mask="$2"
      shift 2
      ;;
    --number)
      countofunits="$2"
      shift 2
      ;;
    *)
      break
      ;;
  esac
done

command="$@"

if [[ ! -d "$path" ]]; then
  echo "Ошибка: каталога '$path' не существует."
  exit 1
fi

if [[ ! -x "$command" ]]; then
  echo "Ошибка: не найден исполняемый файл '$command'."
  exit 1
fi

countoffiles=0
countofprocess=0

for file in "$path"/$mask; do
  if [[ -f "$file" ]]; then
    ((countoffiles++))
    
    if ((countofprocess < countofunits)); then
      "$command" "$file" & 
      ((countofprocess++))
    else
      wait -n  
      ((countofprocess--))
      "$command" "$file" &  
      ((countofprocess++))
    fi
  fi
done

# Ожидание завершения оставшихся процессов
wait
echo "Обработка $countoffiles файлов закончена."