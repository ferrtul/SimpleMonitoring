#!/bin/bash

if [ -z "$1" ]; then
    echo "Error: parameter not specified"
    exit 1
fi

if [[ "$1" =~ ^[0-9]+$ ]]; then
    echo "Incorrect input: the parameter must not be a number."
else
    echo "$1"
fi
