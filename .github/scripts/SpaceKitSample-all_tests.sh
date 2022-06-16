#!/bin/bash

set -eo pipefail

cd SpaceKitSample

xcodebuild -project SpaceKitSample.xcodeproj  \
    -scheme SpaceKitSample \
    -testPlan SpaceKitSampleTestPlan \
    -destination platform=iOS\ Simulator,OS=15.5,name=iPhone\ 13\ Pro \
    clean test \
    | xcpretty

cd ..
