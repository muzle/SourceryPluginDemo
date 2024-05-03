// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SourceryPlugin",
    products: [
        // Products can be used to vend plugins, making them visible to other packages.
        .plugin(
            name: "SourceryBuildToolPlugin",
            targets: ["SourceryBuildToolPlugin", "SourceryCommandPlugin"]
		),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .plugin(
            name: "SourceryBuildToolPlugin",
            capability: .buildTool(),
			dependencies: ["sourcery"]
        ),
		.plugin(
			name: "SourceryCommandPlugin",
			capability: .command(
				intent: .custom(verb: "Run sourcery", description: "Generates data"),
				permissions: [
					.writeToPackageDirectory(reason: "This command generate resources")
				]
			),
			dependencies: ["sourcery"]
		),
		.testTarget(
			name: "SourceryBuildToolPluginTests",
			dependencies: ["SourceryBuildToolPlugin"]
		),
		.testTarget(
			name: "SourceryCommandPluginTests"
		),
		.binaryTarget(name: "sourcery", path: "sourcery.artifactbundle")
    ]
)
