// swift-tools-version:5.9
// SPDX-License-Identifier: GPL-3.0-or-later
// Made with ❤️ by Muntasir Mubin

import PackageDescription

let package = Package(
    name: "MacUtils",
    platforms: [.macOS(.v14)],
    targets: [
        .systemLibrary(
            name: "HIDEventSystem",
            path: "Sources/HIDEventSystem"
        ),
        .systemLibrary(
            name: "VMStatisticsCompat",
            path: "Sources/VMStatisticsCompat"
        ),
        .executableTarget(
            name: "MacUtils",
            dependencies: ["VMStatisticsCompat", "HIDEventSystem"],
            path: "Sources/MacUtils"
        )
    ]
)
