#!/bin/bash
# Build script for Sentient
# Usage: ./scripts/build.sh [release|debug]

set -e

CONFIG="${1:-release}"
PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BUILD_DIR="$PROJECT_DIR/build"
APP_NAME="Sentient"

echo "🔨 Building $APP_NAME ($CONFIG)..."

# Clean build directory
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

# Regenerate Xcode project if needed
if command -v xcodegen &> /dev/null; then
    echo "📦 Regenerating Xcode project..."
    cd "$PROJECT_DIR" && xcodegen generate
fi

# Build
xcodebuild \
    -project "$PROJECT_DIR/$APP_NAME.xcodeproj" \
    -scheme "$APP_NAME" \
    -configuration "$([ "$CONFIG" = "release" ] && echo "Release" || echo "Debug")" \
    -derivedDataPath "$BUILD_DIR/DerivedData" \
    -archivePath "$BUILD_DIR/$APP_NAME.xcarchive" \
    archive

# Export app
xcodebuild \
    -exportArchive \
    -archivePath "$BUILD_DIR/$APP_NAME.xcarchive" \
    -exportPath "$BUILD_DIR" \
    -exportOptionsPlist "$PROJECT_DIR/scripts/ExportOptions.plist"

echo "✅ Build complete: $BUILD_DIR/$APP_NAME.app"
