# default target for the raspberry pi 3
TARGET_ARCH := "aarch64-unknown-linux-gnu"
TARGET_HOST := "pi@raspberrypi.local"
TARGET_PATH := "/home/pi"
BINARY_NAME := "cross-compile-rpi"

# List all available recipes
default:
  @just --list

# Build and push the binary for the target
@build PROFILE="dev":
    echo "Building {{BINARY_NAME}} for target {{TARGET_ARCH}} with {{PROFILE}} profile"
    cross build --target {{TARGET_ARCH}} --profile {{PROFILE}}

    echo "Pushing {{BINARY_NAME}} to {{TARGET_HOST}}:{{TARGET_PATH}}"
    if [ "{{PROFILE}}" = "release" ]; then \
        rsync -avz target/{{TARGET_ARCH}}/release/{{BINARY_NAME}} {{TARGET_HOST}}:{{TARGET_PATH}}; \
    else \
        rsync -avz target/{{TARGET_ARCH}}/debug/{{BINARY_NAME}} {{TARGET_HOST}}:{{TARGET_PATH}}; \
    fi    
