// swift-tools-version:5.10

import PackageDescription

let package = Package(
        name: "ThemeKit",
        platforms: [
            .iOS(.v14),
            .macOS(.v12)
        ],
        products: [
            .library(
                    name: "ThemeKit",
                    targets: ["ThemeKit"]),
        ],
        dependencies: [
            .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.9.1")),
            .package(url: "https://github.com/onevcat/Kingfisher.git", .upToNextMajor(from: "8.1.0")),
            .package(url: "https://github.com/sunimp/UIExtensions.git", .upToNextMajor(from: "1.0.0")),
            .package(url: "https://github.com/sunimp/SWExtensions.git", .upToNextMajor(from: "1.0.0")),
            .package(url: "https://github.com/nicklockwood/SwiftFormat.git", from: "0.54.6"),
        ],
        targets: [
            .target(
                    name: "ThemeKit",
                    dependencies: [
                        "Alamofire",
                        "Kingfisher",
                        "UIExtensions",
                        "SWExtensions"
                    ],
                    resources: [
                        .process("Fonts")
                    ]
            ),
        ]
)
