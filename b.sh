#!/bin/bash
set -e

# 1. Setup local path
PROJECT_ROOT=$(pwd)
FLUTTER_BIN="$PROJECT_ROOT/flutter/bin/flutter"

echo "--- Step 1: Cloning Flutter ---"
if [ ! -d "flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b stable --depth 1
fi

# Ensure executable permissions
chmod +x "$FLUTTER_BIN"

echo "--- Step 2: Configure ---"
$FLUTTER_BIN config --no-analytics
$FLUTTER_BIN config --enable-web

echo "--- Step 3: Dependencies ---"
$FLUTTER_BIN pub get

echo "--- Step 4: Build Web ---"
# We use the absolute path to ensure we use the local stable version
$FLUTTER_BIN build web --release --web-renderer=html --base-href=/ --dart-define=SUPABASE_URL="${SUPABASE_URL}" --dart-define=SUPABASE_ANON_KEY="${SUPABASE_ANON_KEY}"

echo "--- Step 5: Finalize ---"
mkdir -p public
if [ -d "build/web" ]; then
  cp -r build/web/* public/
  echo "Success: Project built successfully."
else
  echo "Error: build/web not found."
  exit 1
fi
