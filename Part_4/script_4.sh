#!/bin/bash

source ../Part_2/system_info.sh

CONFIG_FILE="./color_config.cfg"

# Массивы ANSI цветов для значений и фона
fg_colors=( "\e[97m" "\e[91m" "\e[92m" "\e[94m" "\e[95m" "\e[30m" )
bg_colors=( "\e[107m" "\e[101m" "\e[102m" "\e[104m" "\e[105m" "\e[40m" )
color_names=( "white" "red" "green" "blue" "purple" "black" )
reset="\e[0m"

default_column1_background=6
default_column1_font_color=1
default_column2_background=6
default_column2_font_color=1

# Загружаем конфигурацию, если файл существует
if [[ -f "$CONFIG_FILE" ]]; then
    source "$CONFIG_FILE"
fi

col1_bg=${column1_background:-$default_column1_background}
col1_fg=${column1_font_color:-$default_column1_font_color}
col2_bg=${column2_background:-$default_column2_background}
col2_fg=${column2_font_color:-$default_column2_font_color}

if [[ $col1_bg -eq $col1_fg ]]; then
    echo "Warning: Column 1 background and font color are the same. Adjusting font color to default."
    col1_fg=$default_column1_font_color
fi

if [[ $col2_bg -eq $col2_fg ]]; then
    echo "Warning: Column 2 background and font color are the same. Adjusting font color to default."
    col2_fg=$default_column2_font_color
fi

print_colored() {
    local name=$1
    local value=$2
    echo -e "${bg_colors[$col1_bg-1]}${fg_colors[$col1_fg-1]} $name ${reset} = ${bg_colors[$col2_bg-1]}${fg_colors[$col2_fg-1]} $value ${reset}"
}

print_all_info() {
    local vars=(
        "HOSTNAME" "TIMEZONE" "USER" "OS" "DATE" "UPTIME" "UPTIME_SEC"
        "IP" "MASK" "GATEWAY" "RAM_TOTAL" "RAM_USED" "RAM_FREE"
        "SPACE_ROOT" "SPACE_ROOT_USED" "SPACE_ROOT_FREE"
    )

    for var in "${vars[@]}"; do
        print_colored "$var" "${!var}"
    done
}

print_all_info

echo
echo "Column 1 background = ${column1_background:-default} (${color_names[$col1_bg-1]})"
echo "Column 1 font color = ${column1_font_color:-default} (${color_names[$col1_fg-1]})"
echo "Column 2 background = ${column2_background:-default} (${color_names[$col2_bg-1]})"
echo "Column 2 font color = ${column2_font_color:-default} (${color_names[$col2_fg-1]})"
