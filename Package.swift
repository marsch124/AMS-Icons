// swift-tools-version:5.9
import PackageDescription

// AMS-Icons: the icons every AMS app shares. The hand-drawn icons from the Packing app and a
// chosen set of Apple's SF Symbols, one way to store a choice ("hand:bike", "symbol:book"), one
// search, one colour palette, and the views that draw and pick them.
let package = Package(
    name: "AMSIcons",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "AMSIcons", targets: ["AMSIcons"]),
    ],
    targets: [
        .target(name: "AMSIcons"),
        .testTarget(name: "AMSIconsTests", dependencies: ["AMSIcons"]),
    ]
)
