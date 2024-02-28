// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

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
        .library(
            name: "LaunchTask",
            targets: ["LaunchTask"]),
        .library(
            name: "AppConfig",
            targets: ["AppConfig"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0"),
        .package(url: "https://github.com/agisboye/SwiftLMDB.git", from: "2.1.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        // Macro implementation that performs the source transformation of a macro.
        .macro(
            name: "LaunchTaskMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ]
        ),
        .target(name: "LaunchTask", dependencies: ["LaunchTaskMacros"]),
        .executableTarget(name: "LaunchTaskClient", dependencies: ["AppFoundation", "LaunchTask"]),
        .target(
            name: "AppFoundation",
            dependencies: ["SwiftLMDB"]),
        .target(
            name: "AppConfig",
            dependencies: ["AppFoundation"]),
        .testTarget(
            name: "AppFoundationTests",
            dependencies: ["AppFoundation"]),
    ]
)
