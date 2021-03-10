// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "WarchimedeCom",
    products: [
        .executable(
            name: "WarchimedeCom",
            targets: ["WarchimedeCom"]
        )
    ],
    dependencies: [
        .package(name: "Publish", url: "https://github.com/johnsundell/publish.git", from: "0.7.0")
    ],
    targets: [
        .target(
            name: "WarchimedeCom",
            dependencies: ["Publish"]
        )
    ]
)