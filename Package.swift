// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "GenKit",
    targets: [Target(name: "gen", dependencies: ["GenKit"]),],
    dependencies: [
	.Package(url: "https://github.com/jatoben/CommandLine.git", Version(3, 0, 0, prereleaseIdentifiers: ["pre"], buildMetadataIdentifier: "1")),
        .Package(url: "https://github.com/behrang/YamlSwift.git", Version(3, 3, 1)),
        .Package(url: "https://github.com/groue/GRMustache.git", Version(7, 3, 2)),
        .Package(url: "https://github.com/kylef/Stencil.git", majorVersion: 0, minor: 9),
        .Package(url: "https://github.com/SmallPlanetSporks/FileKit", Version(4, 0, 2)),
    ]
)
