#!/bin/bash
# for quick build .asm

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <input.asm>"
    exit 1
fi

input_file="$1"

# Get the filename without extension
file_name=$(basename -- "$input_file")
file_name="${file_name%.*}"

# Create a directory with the filename
mkdir -p "$file_name"

nasm -f elf "$input_file"
if [ $? -ne 0 ]; then
    echo "Error assembling $input_file"
    exit 1
fi

obj_file="${file_name}.o"

ld -m elf_i386 -s -o "$file_name/$file_name" "$obj_file"
if [ $? -ne 0 ]; then
    echo "Error linking $obj_file"
    exit 1
fi

mv "$obj_file" "$file_name/"
echo "Created /$file_name/$file_name !"
