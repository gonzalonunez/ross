// swift-tools-version: 5.6

import PackageDescription

let package = Package(
  name: "Ross",
  platforms: [.macOS(.v12)],
  products: [
    .executable(
      name: "ross",
      targets: ["ross"]),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.2"),
    .package(url: "https://github.com/apple/swift-syntax.git", exact: "0.50800.0-SNAPSHOT-2022-12-29-a"),
  ],
  targets: [
    .executableTarget(
      name: "ross",
      dependencies: [
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
        .product(name: "SwiftParser", package: "swift-syntax"),
        .product(name: "SwiftSyntax", package: "swift-syntax"),
      ]),

      .testTarget(
        name: "RossTests",
        dependencies: [
          "ross"
        ]),
  ]
)
