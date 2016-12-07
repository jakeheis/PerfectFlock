import PackageDescription

let package = Package(
    name: "PerfectFlock",
    dependencies: [
        .Package(url: "https://github.com/jakeheis/Flock", majorVersion: 0, minor: 1)
    ]
)
