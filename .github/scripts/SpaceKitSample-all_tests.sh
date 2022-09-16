#!/bin/bash

set -eo pipefail

cd SpaceKitSample

xcodebuild -project SpaceKitSample.xcodeproj  \
    -scheme SpaceKitSample \
    -testPlan SpaceKitSampleTestPlan \
    -destination platform=iOS\ Simulator,OS=16.0,name=iPhone\ 14\ Pro \
    clean test \
    | xcpretty

cd ..
