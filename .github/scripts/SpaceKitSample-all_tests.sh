#!/bin/bash

set -eo pipefail

cd SpaceKitSample

xcodebuild -project SpaceKitSample.xcodeproj  \
    -scheme SpaceKitSample \
    -testPlan SpaceKitSampleTestPlan \
    -destination platform=iOS\ Simulator,OS=17.4,name=iPhone\ 15\ Pro \
    clean test \
    | xcbeautify --renderer github-actions

cd ..
