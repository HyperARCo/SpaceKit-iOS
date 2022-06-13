// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SpaceKit",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "SpaceKit",
            targets: ["SpaceKit"]),
    ],
    dependencies: [],
    targets: [
        .binaryTarget(
            name: "SpaceKit",
            path: "SpaceKit.xcframework"),
    ]
)
