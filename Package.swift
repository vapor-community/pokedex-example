import PackageDescription

let package = Package(
    name: "Pokedex",
    dependencies: [
        .Package(url: "https://github.com/qutheory/vapor.git", majorVersion: 0, minor: 14),
        .Package(url: "https://github.com/qutheory/vapor-mustache.git", majorVersion: 0, minor: 10),
        .Package(url: "https://github.com/qutheory/vapor-mysql.git", majorVersion: 0, minor: 0) // will be 0.2
    ],
    exclude: [
        "Config",
        "Database",
        "Localization",
        "Public",
        "Resources",
        "Tests",
    ]
)

