// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RecurrenceRulePicker",
    defaultLocalization: "en",
    platforms: [.iOS(.v18), .macOS(.v15)],
    products: [
        .library(
            name: "RecurrenceRulePicker",
            targets: ["RecurrenceRulePicker"]),
    ],
    dependencies: [
        .package(url: "https://github.com/1amageek/PickerGroup.git", branch: "main")
    ],
    targets: [
        .target(
            name: "RecurrenceRulePicker",
            dependencies: ["PickerGroup"],
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "RecurrenceRulePickerTests",
            dependencies: ["RecurrenceRulePicker"]),
    ]
)
