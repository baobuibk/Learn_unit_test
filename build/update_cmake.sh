#!/bin/bash

echo "Running CMake..."
cmake -G "MinGW Makefiles" -DCMAKE_TOOLCHAIN_FILE=./arm-none-eabi-gcc.cmake -DCMAKE_BUILD_TYPE=Debug .

if [ $? -ne 0 ]; then
    echo "CMake failed with error code $?"
    exit $?
fi

echo "CMake completed successfully."