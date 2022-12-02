#!/bin/bash

$(xcrun --find docc) process-archive \
transform-for-static-hosting SpaceKit.doccarchive \
--output-path $SPACEKIT_DOCS_DIRECTORY \
--hosting-base-path $SPACEKIT_HOSTING_BASE_PATH
