import PackageDescription

let package = Package(
    name: "PerfectFlock",
    dependencies: [
        .Package(url: "/Users/jakeheiser/Desktop/Projects/Swift/Flock", majorVersion: 0, minor: 1)
    ]
)
