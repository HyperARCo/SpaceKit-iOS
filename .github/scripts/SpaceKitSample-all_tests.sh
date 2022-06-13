#!/bin/bash

set -eo pipefail

cd SpaceKitSample

xcodebuild -project SpaceKitSample.xcodeproj  \
    -scheme SpaceKitSample \
    -destination platform=iOS\ Simulator,OS=15.5,name=iPhone\ 13\ Pro \
    clean test \
    | xcpretty

xcodebuild -project SpaceKitSample.xcodeproj  \
    -scheme SpaceKitSampleUITests \
    -destination platform=iOS\ Simulator,OS=15.5,name=iPhone\ 13\ Pro \
    test \
    | xcpretty

cd ..
