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
    dependencies: [
        .package(name: "RecurrenceRule", url: "git@github.com:1amageek/RecurrenceRule.git", .branch("main")),
        .package(name: "PickerGroup", url: "git@github.com:1amageek/PickerGroup.git", .branch("main"))
    ],
    targets: [
        .target(
            name: "RecurrenceRulePicker",
            dependencies: ["RecurrenceRule", "PickerGroup"],
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "RecurrenceRulePickerTests",
            dependencies: ["RecurrenceRulePicker"]),
    ]
)
