// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Watchable",
    products: [
        .library(
            name: "Watchable",
            targets: ["Watchable"])
    ],
    targets: [
        .target(
            name: "Watchable")
    ]
)
