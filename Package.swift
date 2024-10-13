// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
let package = Package(
    name: "ValifySelfieFramework",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "ValifySelfieFramework",
            targets: ["ValifySelfieFramework"]),
    ],
    dependencies: [
        .package(url: "https://github.com/d-date/google-mlkit-swiftpm", from: "5.0.0"),
    ],
    targets: [
        .target(
            name: "ValifySelfieFramework",
            dependencies: ["GoogleMLKitFaceDetection"]), // Add ML Kit dependency
        .testTarget(
            name: "ValifySelfieFrameworkTests",
            dependencies: ["ValifySelfieFramework"]),
    ]
)
