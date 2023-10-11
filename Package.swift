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
			targets: ["SpaceKitSDK"]),
	],
	dependencies: [
		.package(url: "https://github.com/GEOSwift/geos.git", from: "7.0.0"),
		.package(url: "https://github.com/airbnb/lottie-spm.git", from: "4.3.3")
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
