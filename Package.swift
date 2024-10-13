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
    ],
    targets: [
        .target(
            name: "ValifySelfieFramework",
            dependencies: [] 
        ),
        .testTarget(
            name: "ValifySelfieFrameworkTests",
            dependencies: ["ValifySelfieFramework"]),
    ]
)

