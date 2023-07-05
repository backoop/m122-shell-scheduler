#!/bin/bash

target_date="$1"
target_time="$2"
time_interval="$1"
message="$2"

# Function to convert the time interval to seconds
function convert_to_seconds() {
  # Extract the time values from the interval
  seconds=$(echo "$time_interval" | grep -o '[0-9]*s' | awk -F's' '{sum += $1} END {print sum}')
  minutes=$(echo "$time_interval" | grep -o '[0-9]*m' | awk -F'm' '{sum += $1} END {print sum}')
  hours=$(echo "$time_interval" | grep -o '[0-9]*h' | awk -F'h' '{sum += $1} END {print sum}')
  days=$(echo "$time_interval" | grep -o '[0-9]*d' | awk -F'd' '{sum += $1} END {print sum}')

  # Calculate the total time in seconds
  total_seconds=$((seconds + (minutes * 60) + (hours * 3600) + (days * 86400)))

  # Return the total seconds
  echo "$total_seconds"
}


# Check if the required parameters are provided
if { [ -z "$target_date" ] || [ -z "$target_time" ]; } && { [ -z "$time_interval" ] || [ -z "$message" ]; }; then
  # echo "Usage: ./notification_script.sh <date> <time> <message>"
  echo "   or: ./notification_script.sh <time_interval> <message>"
  exit 1
fi

# Check if the target date and time are provided
if [ -n "$target_date" ] && [ -n "$target_time" ]; then
  # Get the current date and time
  current_date=$(date +%Y.%m.%d)
  current_time=$(date +%H:%M)

  # Compare the current date and time with the target parameters
  if [ "$current_date" == "$target_date" ] && [ "$current_time" == "$target_time" ]; then
    # Send a notification
    notify-send "Notification" "$message"
  fi
fi

# Check if the time interval and message are provided
if [ -n "$time_interval" ] && [ -n "$message" ]; then
  # Extract the time values from the interval
  seconds=$(echo "$time_interval" | grep -o '[0-9]*s' | awk -F's' '{sum += $1} END {print sum}')
  minutes=$(echo "$time_interval" | grep -o '[0-9]*m' | awk -F'm' '{sum += $1} END {print sum}')

  # Calculate the total time in seconds with the function
  total_seconds=$(convert_to_seconds "$time_interval")

  # Sleep for the specified time interval
  sleep "$total_seconds"

  # Send a notification
  notify-send "Notification" "$message"
fi
