// swift-tools-version:5.10

import PackageDescription

let package = Package(
        name: "ThemeKit",
        platforms: [
            .iOS(.v13),
        ],
        products: [
            .library(
                    name: "ThemeKit",
                    targets: ["ThemeKit"]),
        ],
        dependencies: [
            .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.9.0")),
            .package(url: "https://github.com/onevcat/Kingfisher.git", .upToNextMajor(from: "7.12.0")),
            .package(url: "https://github.com/sunimp/UIExtensions.Swift.git", .upToNextMajor(from: "1.1.8")),
            .package(url: "https://github.com/sunimp/WWExtensions.Swift.git", .upToNextMajor(from: "1.0.8")),
        ],
        targets: [
            .target(
                    name: "ThemeKit",
                    dependencies: [
                        "Alamofire",
                        "Kingfisher",
                        .product(name: "UIExtensions", package: "UIExtensions.Swift"),
                        .product(name: "WWExtensions", package: "WWExtensions.Swift"),
                    ],
                    resources: [
                        .process("Fonts")
                    ]
            ),
        ]
)
