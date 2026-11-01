#!/bin/sh
# Build uji (Linux): tanpa backend OS — hanya sink file untuk tes otomatis.
set -e
cd "$(dirname "$0")/.."
mkdir -p build
g++ -std=c++17 -O2 -Wall -Wextra -pthread -o build/ritm-audio \
  src/main.cpp src/engine.cpp src/io.cpp src/decode/wav.cpp src/decode/flac.cpp src/backend/file.cpp src/platform_stub.cpp
g++ -std=c++17 -O2 -Wall -Wextra -o build/dsp_test tests/dsp_test.cpp
echo "OK build/ritm-audio build/dsp_test"
