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
      name: "MarkdownToView",
      targets: ["MarkdownToView"]
    ),
    .library(
      name: "NagoyaSwiftSlides",
      targets: ["NagoyaSwiftSlides"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/mtj0928/SlideKit", branch: "main"),
    .package(url: "https://github.com/swiftlang/swift-markdown.git", from: "0.7.3"),
  ],
  targets: [
    .target(
      name: "MarkdownToView",
      dependencies: [
        .product(name: "Markdown", package: "swift-markdown"),
      ]
    ),
    .target(
      name: "NagoyaSwiftSlides",
      dependencies: [
        "MarkdownToView",
        .product(name: "SlideKit", package: "SlideKit"),
      ]
    ),
  ]
)
