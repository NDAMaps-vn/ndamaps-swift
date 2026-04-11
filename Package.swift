// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "NDAMapsSDK",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6)
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
