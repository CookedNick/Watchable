// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Observable",
    products: [
        .library(
            name: "Observable",
            targets: ["Observable"])
    ],
    targets: [
        .target(
            name: "Observable")
    ]
)
