#!/bin/bash

while getopts "d:n:" opt; do
case $opt in
d) path=$OPTARG ;;
n) name=$OPTARG ;;
*) echo "$0 -d <path> -n <name>"; exit 1 ;;
esac
done
if [ -z "$path" ] || [ -z "$name" ]; then
echo "Укажите путь к каталогу и название архива"
exit 1
fi
# Генерирование bash скрипта
cat > "$name" <<'EOF'
unpackdirectory=""
while getopts "o:" opt; do
case $opt in
o) unpackdirectory=$OPTARG ;;
*) echo "$0 [-o unpackdirectory]"; exit 1 ;;
esac
done
if ! [ -z "$unpackdirectory" ]; then
echo "Распаковываем в $unpackdirectory"
tar -xzf "$0" -C "$unpackdirectory"
else
echo "Распаковываем в этот каталог"
tar -xzf "$0"
fi
EOF
# Упаковка и сжатие
tar -czf - "$path" | cat - > "$name"
chmod +x "$name"
echo "Скрипт $name создался и архивировался"