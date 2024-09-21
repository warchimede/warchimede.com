// swift-tools-version:5.10

import PackageDescription

let name = "WarchimedeCom"
let package = Package(
    name: name,
    platforms: [.macOS(.v14)],
    products: [
        .executable(name: name, targets: [name])
    ],
    dependencies: [
        .package(url: "https://github.com/johnsundell/publish.git", from: "0.9.0"),
        .package(url: "https://github.com/johnsundell/splashpublishplugin.git", from: "0.2.0")
    ],
    targets: [
        .target(
            name: name,
            dependencies: [
              .product(name:"Publish", package:"publish"),
              .product(name:"SplashPublishPlugin", package:"splashpublishplugin")
            ]
        )
    ]
)
