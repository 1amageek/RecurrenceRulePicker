// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RecurrenceRulePicker",
    defaultLocalization: "en",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        .library(
            name: "RecurrenceRulePicker",
            targets: ["RecurrenceRulePicker"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "RecurrenceRulePicker",
            dependencies: []),
        .testTarget(
            name: "RecurrenceRulePickerTests",
            dependencies: ["RecurrenceRulePicker"]),
    ]
)
