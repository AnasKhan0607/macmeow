#!/bin/bash
# DMG creation script for Sentient
# 
# Creates a polished DMG with:
# - App icon
# - Applications folder symlink
# - Custom background (optional)
#
# Usage: ./scripts/create-dmg.sh

set -e

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BUILD_DIR="$PROJECT_DIR/build"
APP_NAME="Sentient"
APP_PATH="$BUILD_DIR/$APP_NAME.app"
DMG_PATH="$BUILD_DIR/$APP_NAME.dmg"
VOLUME_NAME="$APP_NAME"

# Check app exists
if [ ! -d "$APP_PATH" ]; then
    echo "❌ App not found: $APP_PATH"
    echo "   Run ./scripts/build.sh first"
    exit 1
fi

# Get version from Info.plist
VERSION=$(defaults read "$APP_PATH/Contents/Info" CFBundleShortVersionString 2>/dev/null || echo "1.0.0")
DMG_FINAL="$BUILD_DIR/${APP_NAME}_v${VERSION}.dmg"

echo "📀 Creating DMG for $APP_NAME v$VERSION..."

# Clean up
rm -f "$DMG_PATH" "$DMG_FINAL"

# Create temporary directory for DMG contents
TEMP_DIR=$(mktemp -d)
cp -R "$APP_PATH" "$TEMP_DIR/"
ln -s /Applications "$TEMP_DIR/Applications"

# Create DMG
hdiutil create \
    -volname "$VOLUME_NAME" \
    -srcfolder "$TEMP_DIR" \
    -ov \
    -format UDZO \
    "$DMG_PATH"

# Clean up
rm -rf "$TEMP_DIR"

# Rename to final name
mv "$DMG_PATH" "$DMG_FINAL"

echo "✅ DMG created: $DMG_FINAL"
echo ""
echo "📊 DMG Info:"
ls -lh "$DMG_FINAL"

# Optional: Sign the DMG
if [ -n "$APPLE_ID" ] && [ -n "$TEAM_ID" ] && [ -n "$APP_PASSWORD" ]; then
    echo ""
    echo "📤 Notarizing DMG..."
    xcrun notarytool submit "$DMG_FINAL" \
        --apple-id "$APPLE_ID" \
        --team-id "$TEAM_ID" \
        --password "$APP_PASSWORD" \
        --wait
    
    xcrun stapler staple "$DMG_FINAL"
    echo "✅ DMG notarized!"
fi
