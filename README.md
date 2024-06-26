# SpaceKit-iOS

This repository contains: 
* iOS `SpaceKitSample` project 
* Binary `SpaceKit.xcframework`
* Documentation archive `SpaceKit.doccarchive`

The Android repository can be found [here](https://github.com/HyperARCo/SpaceKit-Android).

## Requirements

* iOS 13.0+ (Swift Package Manager, CocoaPods)
* Swift 5.5

## Installation

### CocoaPods

1. Update your `Podfile` to include:

        use_frameworks!
        pod 'SpaceKit', :git => 'https://github.com/HyperARCo/SpaceKit-iOS'

2. Run `$ pod install`

### Swift Package Manager

1. Update the top-level dependencies in your `Package.swift` to include:

        .package(url: "https://github.com/HyperARCo/SpaceKit-iOS", from: "0.0.1")

2. Update the target dependencies in your `Package.swift` to include

        "SpaceKit"

### Frameworks

1. Download `SpaceKit.xcframework` and then drag it into your project's Frameworks, Libraries and Embedded Content pane in project settings.

2. Add [geos](https://github.com/GEOSwift/geos) as a dependency, using the method of your choosing (CocoaPods, SPM or manual).

3. Embed and sign `SpaceKit` and `geos` in your project settings. 

## Documentation

API documentation is available [here](https://HyperARCo.github.io/SpaceKit-iOS/documentation/spacekit/).
