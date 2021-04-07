// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KeyboardAvoidingView",
    platforms: [
        .iOS(.v9),
    ],
    products: [
        .library(
            name: "KeyboardAvoidingView",
            targets: ["KeyboardAvoidingView"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/APUtils/ViewState.git", .upToNextMajor(from: "1.2.1")),
    ],
    targets: [
        .target(
            name: "KeyboardAvoidingView",
            dependencies: ["ViewState"],
            path: "KeyboardAvoidingView/Classes",
            exclude: ["KeyboardAvoidingViewLoader.h", "KeyboardAvoidingViewLoader.m"]
        ),
    ]
)
