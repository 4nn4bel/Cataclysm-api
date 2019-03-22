// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "Cataclysm",
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", .upToNextMajor(from: "3.0.0")),
        .package(url: "https://github.com/vapor/fluent-postgresql.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/vapor/auth.git", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/vapor/leaf.git", .upToNextMajor(from: "3.0.0")),
        .package(url: "https://github.com/vapor-community/stripe-provider.git", .upToNextMajor(from: "2.2.0")),
        
    ],
    targets: [
        .target(name: "App", dependencies: ["FluentPostgreSQL", "Vapor", "Authentication", "Leaf", "Stripe"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)

