#!/bin/bash
# Notarization script for Sentient
# 
# Prerequisites:
# 1. Apple Developer account with Developer ID certificate
# 2. App-specific password from appleid.apple.com
# 3. Team ID from developer.apple.com
#
# Usage: ./scripts/notarize.sh
#
# Environment variables:
#   APPLE_ID        - Your Apple ID email
#   TEAM_ID         - Your Team ID
#   APP_PASSWORD    - App-specific password (not your account password)

set -e

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BUILD_DIR="$PROJECT_DIR/build"
APP_NAME="Sentient"
APP_PATH="$BUILD_DIR/$APP_NAME.app"
ZIP_PATH="$BUILD_DIR/$APP_NAME.zip"

# Check environment
if [ -z "$APPLE_ID" ] || [ -z "$TEAM_ID" ] || [ -z "$APP_PASSWORD" ]; then
    echo "❌ Missing environment variables"
    echo ""
    echo "Required:"
    echo "  export APPLE_ID='your@email.com'"
    echo "  export TEAM_ID='XXXXXXXXXX'"
    echo "  export APP_PASSWORD='xxxx-xxxx-xxxx-xxxx'"
    echo ""
    echo "Get app-specific password at: https://appleid.apple.com"
    echo "Get Team ID at: https://developer.apple.com/account"
    exit 1
fi

# Check app exists
if [ ! -d "$APP_PATH" ]; then
    echo "❌ App not found: $APP_PATH"
    echo "   Run ./scripts/build.sh first"
    exit 1
fi

echo "📦 Creating ZIP for notarization..."
ditto -c -k --keepParent "$APP_PATH" "$ZIP_PATH"

echo "📤 Submitting for notarization..."
xcrun notarytool submit "$ZIP_PATH" \
    --apple-id "$APPLE_ID" \
    --team-id "$TEAM_ID" \
    --password "$APP_PASSWORD" \
    --wait

echo "📎 Stapling notarization ticket..."
xcrun stapler staple "$APP_PATH"

echo "✅ Notarization complete!"
echo "   App: $APP_PATH"

# Verify
echo ""
echo "🔍 Verifying..."
spctl -a -vvv -t install "$APP_PATH"
