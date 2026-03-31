// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "NagoyaSwift",
  platforms: [
    .iOS(.v26),
    .macOS(.v26),
  ],
  products: [
    .library(
      name: "NagoyaSwiftSlides",
      targets: ["NagoyaSwiftSlides"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/mtj0928/SlideKit", branch: "main")
  ],
  targets: [
    .target(
      name: "NagoyaSwiftSlides",
      dependencies: [
        .product(name: "SlideKit", package: "SlideKit")
      ]
    )
  ]
)
