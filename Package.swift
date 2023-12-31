// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppFoundation",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
        .macOS(.v10_15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AppFoundation",
            targets: ["AppFoundation"]),
    ],
    dependencies: [
        .package(url: "https://github.com/agisboye/SwiftLMDB.git", from: "2.1.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AppFoundation",
            dependencies: ["SwiftLMDB"]),
        .testTarget(
            name: "AppFoundationTests",
            dependencies: ["AppFoundation"]),
    ]
)
