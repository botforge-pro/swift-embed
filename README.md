[![Tests](https://github.com/botforge-pro/swift-embed/actions/workflows/tests.yml/badge.svg)](https://github.com/botforge-pro/swift-embed/actions/workflows/tests.yml)

# SwiftEmbed

A lightweight Swift library for embedding JSON and YAML resources using property wrappers.

## Features

- 🎯 **Simple API** - Clean property wrapper syntax
- 📦 **JSON Support** - Built-in JSON decoding
- 📝 **YAML Support** - Full YAML decoding via Yams
- 🔒 **Type Safe** - Compile-time type checking with Decodable
- 🚀 **Zero Runtime Cost** - Resources loaded once and cached
- 📱 **Cross-Platform** - Works on iOS, macOS, tvOS, watchOS

## Installation

### Swift Package Manager

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/botforge-pro/swift-embed.git", from: "1.0.0")
]
```

## Usage

### JSON Files

```swift
import SwiftEmbed

struct User: Decodable {
    let name: String
    let email: String
}

struct MyClass {
    @Embedded.json("Resources/users.json")
    var users: [User]
    
    func printUsers() {
        for user in users {
            print("\(user.name): \(user.email)")
        }
    }
}
```

### YAML Files

```swift
import SwiftEmbed

struct Config: Decodable {
    let apiURL: String
    let timeout: Int
}

struct Settings {
    @Embedded.yaml("Config/settings.yaml")
    var config: Config
    
    func configure() {
        print("API URL: \(config.apiURL)")
        print("Timeout: \(config.timeout)s")
    }
}
```

### In Tests

Perfect for loading test data:

```swift
import Testing
import SwiftEmbed

@Suite("API Tests")
struct APITests {
    struct TestCase: Decodable {
        let input: String
        let expected: String
    }
    
    @Embedded.json("TestData/url_tests.json")
    var testCases: [TestCase]
    
    @Test("URL Validation", arguments: testCases)
    func testURLs(testCase: TestCase) {
        // Test implementation
    }
}
```

## File Organization

Place your resource files in your target:

```
MyApp/
├── Sources/
│   └── MyApp/
│       └── MyClass.swift
└── Resources/
    ├── data.json
    └── config.yaml
```

For Swift packages, ensure resources are declared in `Package.swift`:

```swift
.target(
    name: "MyApp",
    resources: [
        .copy("Resources")
    ]
)
```

## Requirements

- Swift 6.0+
- iOS 15.0+ / macOS 12.0+ / tvOS 15.0+ / watchOS 8.0+