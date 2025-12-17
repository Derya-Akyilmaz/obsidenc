#!/bin/bash
# Build and run obsidenc with passed arguments

set -e  # Exit on error

echo "Building obsidenc..."
cargo build --release

if [ $? -ne 0 ]; then
    echo "Build failed!"
    exit 1
fi

echo ""
echo "Running obsidenc..."
target/release/obsidenc "$@"

