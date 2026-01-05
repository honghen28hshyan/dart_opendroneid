// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "OpenDroneID",
    platforms: [
        .iOS(.v13),
        .macOS(.v12)
    ],
    products: [
        .library(name: "OpenDroneID", targets: ["OpenDroneID"])
    ],
    targets: [
        .target(
            name: "OpenDroneID",
            path: "Sources"
        ),
        .testTarget(
            name: "OpenDroneIDTests",
            dependencies: ["OpenDroneID"],
            path: "Tests"
        )
    ]
)
