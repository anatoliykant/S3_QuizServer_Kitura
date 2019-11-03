// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "QuizKituraServer",
    dependencies: [
      .package(url: "https://github.com/IBM-Swift/Kitura.git", .upToNextMinor(from: "2.7.0")),
      .package(url: "https://github.com/IBM-Swift/HeliumLogger.git", from: "1.7.1"),
      .package(url: "https://github.com/IBM-Swift/CloudEnvironment.git", from: "9.0.0"),
      .package(url: "https://github.com/RuntimeTools/SwiftMetrics.git", from: "2.0.0"),
      .package(url: "https://github.com/IBM-Swift/Kitura-OpenAPI.git", from: "1.0.0"),
      .package(url: "https://github.com/IBM-Swift/Health.git", from: "1.0.0"),
      .package(url: "https://github.com/IBM-Swift/Kitura-CORS.git", from: "2.1.1"),
      .package(url: "https://github.com/IBM-Swift/Swift-Kuery-ORM", from: "0.6.1"),
      .package(url: "https://github.com/IBM-Swift/Swift-Kuery-PostgreSQL", from: "2.1.1"),
    ],
    targets: [
      .target(name: "QuizKituraServer", dependencies: [
        .target(name: "Application"),
        "Kitura",
        "HeliumLogger",
      ]),
      .target(name: "Application", dependencies: [
        "Kitura",
        "CloudEnvironment",
        "SwiftMetrics",
        "KituraOpenAPI",
        "Health",
        "KituraCORS",
        "SwiftKueryORM",
        "SwiftKueryPostgreSQL",
      ]),

      .testTarget(name: "ApplicationTests" , dependencies: [
        .target(name: "Application"),
        "Kitura",
        "HeliumLogger",
      ])
    ]
)