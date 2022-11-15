#!/bin/bash

set -eo pipefail

TAG=$(grep -E 'spec.version *= "[0-9]+.[0-9]+.[0-9]+"' SpaceKit.podspec | grep -oE '[0-9]+.[0-9]+.[0-9]+')

echo "Adding tag:" $TAG

git tag $TAG
git push origin $TAG
