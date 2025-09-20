#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 /path/to/directory/"
    exit 1
fi

DIR="$1"

if [[ "$DIR" != */ ]]; then
    echo "Directory path must end with '/'"
    exit 1
fi

if [ ! -d "$DIR" ]; then
    echo "Directory does not exist: $DIR"
    exit 1
fi

START_TIME=$(date +%s.%N)

TOTAL_FOLDERS=$(find "$DIR" -type d | wc -l)

TOP_FOLDERS=$(du -sh "$DIR"* 2>/dev/null | sort -rh | head -5)

TOTAL_FILES=$(find "$DIR" -type f | wc -l)

# Количество файлов по типам
CONF_FILES=$(find "$DIR" -type f -name "*.conf" | wc -l)
TEXT_FILES=$(find "$DIR" -type f -exec file --mime-type {} + | grep 'text/' | wc -l)
EXEC_FILES=$(find "$DIR" -type f -executable | wc -l)
LOG_FILES=$(find "$DIR" -type f -name "*.log" | wc -l)
ARCHIVE_FILES=$(find "$DIR" -type f \( -name "*.zip" -o -name "*.tar" -o -name "*.gz" -o -name "*.bz2" -o -name "*.rar" \) | wc -l)
SYMLINKS=$(find "$DIR" -type l | wc -l)

# Топ-10 файлов по размеру
TOP_FILES=$(find "$DIR" -type f -exec ls -lhS {} + 2>/dev/null | head -10 | awk '{printf "%s, %s, %s\n", $9, $5, $NF}')

# Топ-10 исполняемых файлов по размеру с MD5
TOP_EXEC_FILES=$(find "$DIR" -type f -executable -exec ls -lS {} + 2>/dev/null | head -10 | awk '{print $9}' | while read f; do
    SIZE=$(ls -lh "$f" | awk '{print $5}')
    MD5=$(md5sum "$f" | awk '{print $1}')
    echo "$f, $SIZE, $MD5"
done)

END_TIME=$(date +%s.%N)
EXEC_TIME=$(echo "$END_TIME - $START_TIME" | bc)

#
echo "Total number of folders (including all nested ones) = $TOTAL_FOLDERS"
echo "TOP 5 folders of maximum size arranged in descending order (path and size):"
i=1
while read -r line; do
    echo "$i - $line"
    i=$((i+1))
done <<< "$TOP_FOLDERS"

echo "Total number of files = $TOTAL_FILES"
echo "Number of:"
echo "Configuration files (with the .conf extension) = $CONF_FILES"
echo "Text files = $TEXT_FILES"
echo "Executable files = $EXEC_FILES"
echo "Log files (with the extension .log) = $LOG_FILES"
echo "Archive files = $ARCHIVE_FILES"
echo "Symbolic links = $SYMLINKS"

echo "TOP 10 files of maximum size arranged in descending order (path, size and type):"
i=1
while read -r line; do
    echo "$i - $line"
    i=$((i+1))
done <<< "$TOP_FILES"

echo "TOP 10 executable files of the maximum size arranged in descending order (path, size and MD5 hash):"
i=1
while read -r line; do
    echo "$i - $line"
    i=$((i+1))
done <<< "$TOP_EXEC_FILES"

echo "Script execution time (in seconds) = $EXEC_TIME"
