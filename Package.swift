// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "NDAMapsSDK",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .tvOS(.v16),
        .watchOS(.v9)
    ],
    products: [
        .library(name: "NDAMapsSDK", targets: ["NDAMapsSDK"]),
        .executable(name: "NDAMapsExample", targets: ["NDAMapsExample"])
    ],
    targets: [
        .target(name: "NDAMapsSDK", dependencies: []),
        .executableTarget(name: "NDAMapsExample", dependencies: ["NDAMapsSDK"]),
        .testTarget(name: "NDAMapsSDKTests", dependencies: ["NDAMapsSDK"]),
    ]
)
