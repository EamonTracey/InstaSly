// swift-tools-version:5.2

import PackageDescription
import Foundation

let theosPath = ProcessInfo.processInfo.environment["THEOS"]!

let libFlags: [String] = [
    "-F\(theosPath)/vendor/lib",
    "-F\(theosPath)/lib",
    "-I\(theosPath)/vendor/include",
    "-I\(theosPath)/include"
]

let cFlags: [String] = libFlags + [
    "-Wno-unused-command-line-argument",
    "-Qunused-arguments",
]

let package = Package(
    name: "InstaSlyPreferences",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "InstaSlyPreferences",
            targets: ["InstaSlyPreferences"]
        ),
    ],
    targets: [
        .target(
            name: "InstaSlyPreferencesC",
            cSettings: [.unsafeFlags(cFlags)]
        ),
        .target(
            name: "InstaSlyPreferences",
            dependencies: ["InstaSlyPreferencesC"],
            swiftSettings: [.unsafeFlags(libFlags)]
        )
    ]
)
