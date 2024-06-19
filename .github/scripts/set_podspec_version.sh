#!/bin/bash

set -eo pipefail

PLISTBUDDY=/usr/libexec/plistbuddy
PLIST=./SpaceKit.xcframework/ios-arm64/dSYMs/SpaceKit.framework.dSYM/Contents/Info.plist

BUILDNUMBER=$($PLISTBUDDY -c "Print CFBundleVersion" $PLIST)
BUILDSTRING='0.0.'$BUILDNUMBER

echo "Setting podspec version: " $BUILDSTRING

sed -E -i '' "s/(\spec.version *= )(\"[0-9]+.[0-9]+.[0-9]+\")/\1\"$BUILDSTRING\"/" SpaceKit.podspec

git add SpaceKit.podspec
git commit -m "Bump podspec version to '$BUILDSTRING'"
git push origin main
