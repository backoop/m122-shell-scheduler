#!bin/bash

# Formats
bold=$(tput bold)
normal=$(tput sgr0)

message=$2
if (( $# < 1 )); then
    echo "Usage: scheduler.sh <date> <message>"
    exit 1
fi
if (( $# < 2 )); then
    # Promt user for message and save it to variable
    read -p "Enter message: " message
fi

echo "Message: $bold$message$normal"

# function to convert 1d1h1m10s to date relative to current date 
convert_time_to_date() {
    time_str="$1"

    # Extracting individual components from the time string
    days=$(echo "$time_str" | awk -F'd' '{print $1}')
    hours=$(echo "$time_str" | awk -F'h' '{print $1}' | awk -F'd' '{print $2}')
    minutes=$(echo "$time_str" | awk -F'm' '{print $1}' | awk -F'h' '{print $2}')
    seconds=$(echo "$time_str" | awk -F's' '{print $1}' | awk -F'm' '{print $2}')

    # Getting the current date in seconds since epoch
    current_date=$(date +%s)

    # Calculating the relative date in seconds
    relative_date=$((current_date + (days * 24 * 60 * 60) + (hours * 60 * 60) + (minutes * 60) + seconds))

    # Converting the relative date to a human-readable format
    converted_date=$(date -d "@$relative_date")

    echo "Converted date: $converted_date"
}

convert_time_to_date "1d1h1m10s"