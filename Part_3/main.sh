#!/bin/bash

source ../Part_2/system_info.sh

if [[ $# -ne 4 ]]; then
    echo "Usage: $0 <background_name> <font_name> <values_background> <values_font>"
    echo "Colors: 1-white, 2-red, 3-green, 4-blue, 5-purple, 6-black"
    exit 1
fi

bg_name=$1
fg_name=$2
bg_value=$3
fg_value=$4

# Прверяем чтобы цвета фона и значений не совпадали
if [[ $bg_name -eq $fg_name ]]; then
    echo "Error: background color and font of the titles should different"
    exit 1
fi

if [[ $bg_value -eq $fg_value ]]; then
    echo "Error: background color and font of the titles should different"
    exit 1
fi

# Массивы ANSI цветов для значений и фона
fg_colors=( "\e[97m" "\e[91m" "\e[92m" "\e[94m" "\e[95m" "\e[30m" )
bg_colors=( "\e[107m" "\e[101m" "\e[102m" "\e[104m" "\e[105m" "\e[40m" )
reset="\e[0m"

print_colored() {
    local name=$1
    local value=$2
    echo -e "${bg_colors[$bg_name-1]}${fg_colors[$fg_name-1]} $name ${reset} = ${bg_colors[$bg_value-1]}${fg_colors[$fg_value-1]} $value ${reset}"
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