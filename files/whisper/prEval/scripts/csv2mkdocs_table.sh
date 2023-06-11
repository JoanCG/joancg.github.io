#!/bin/bash

# Check if a file name is provided
if [ $# -eq 0 ]; then
    echo "Please provide the CSV file name as an argument."
    exit 1
fi

# Check if the file exists
if [ ! -f "$1" ]; then
    echo "File '$1' not found."
    exit 1
fi

# Process the file
output_file="processed_$1"
sed 's/,/ | /g' "$1" > "$output_file"

echo "Processed file: $output_file"
