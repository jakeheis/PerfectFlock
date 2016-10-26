import PackageDescription

let package = Package(
    name: "PerfectFlock",
    dependencies: [
        .Package(url: "../Flock", majorVersion: 0, minor: 0)
    ]
)
