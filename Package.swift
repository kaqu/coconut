// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "Coconut",
    products: [
        .library(
            name: "Coconut",
            targets: ["Coconut"]),
    ],
    dependencies: [
        .package(url: "https://github.com/miquido/futura.git", from: "2.1.0"),
    ],
    targets: [
        .target(
            name: "Coconut",
            dependencies: ["Futura"]),
        .testTarget(
            name: "CoconutTests",
            dependencies: ["Futura", "Coconut"]),
    ]
)
