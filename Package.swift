// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftEmbed",
    platforms: [
        .macOS(.v12),
        .iOS(.v15),
        .tvOS(.v15),
        .watchOS(.v8)
    ],
    products: [
        .library(
            name: "SwiftEmbed",
            targets: ["SwiftEmbed"]),
    ],
    dependencies: [
        .package(url: "https://github.com/jpsim/Yams.git", from: "5.0.0")
    ],
    targets: [
        .target(
            name: "SwiftEmbed",
            dependencies: ["Yams"],
            resources: []),
        .testTarget(
            name: "SwiftEmbedTests",
            dependencies: ["SwiftEmbed"],
            resources: [
                .copy("TestData")
            ]
        ),
    ]
)
