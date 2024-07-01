// swift-tools-version: 5.7
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
            targets: ["SpaceKitSDK"]),
    ],
    dependencies: [
        .package(url: "https://github.com/GEOSwift/geos.git", from: "8.1.0"),
        .package(url: "https://github.com/airbnb/lottie-spm.git", exact: "4.4.3"),
    ],
    targets: [
        .target(name: "SpaceKitSDK", dependencies: [
            "SpaceKit",
            .product(name: "geos", package: "geos"),
            .product(name: "Lottie", package: "lottie-spm")
        ]),
        .binaryTarget(
            name: "SpaceKit",
            path: "SpaceKit.xcframework"),
    ]
)
