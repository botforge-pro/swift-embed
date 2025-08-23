[![Tests](https://github.com/botforge-pro/swift-embed/actions/workflows/tests.yml/badge.svg)](https://github.com/botforge-pro/swift-embed/actions/workflows/tests.yml)

# SwiftEmbed

A lightweight Swift library for embedding JSON, YAML and text resources using property wrappers.

## Features

- 🎯 **Simple API** - Clean property wrapper syntax
- 📦 **JSON Support** - Built-in JSON decoding
- 📝 **YAML Support** - Full YAML decoding via Yams
- 📄 **Text Support** - Load plain text files as strings
- 🔒 **Type Safe** - Compile-time type checking with Decodable
- 🚀 **Zero Runtime Cost** - Resources loaded once and cached
- 📱 **Cross-Platform** - Works on iOS, macOS, tvOS, watchOS

## Installation

### Swift Package Manager

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/botforge-pro/swift-embed.git", from: "1.3.0")
]
```

## Usage

SwiftEmbed provides two ways to load resources:
- **Property wrappers** (`@Embedded.json` / `@Embedded.yaml` / `@Embedded.text`) - for class/struct properties
- **Direct loading** (`Embedded.getJSON` / `Embedded.getYAML` / `Embedded.getText`) - for immediate use

### Property Wrappers

```swift
import SwiftEmbed

struct Config: Decodable {
    let apiURL: String
    let timeout: Int
    let features: [String]
}

struct User: Decodable {
    let name: String
    let email: String
}

struct MyApp {
    @Embedded.json(Bundle.main, path: "Resources/users.json")
    var users: [User]
    
    @Embedded.yaml(Bundle.main, path: "Config/settings.yaml")
    var config: Config
    
    @Embedded.text(Bundle.main, path: "Resources/template.html")
    var htmlTemplate: String
    
    func printInfo() {
        print("API: \(config.apiURL)")
        print("Users: \(users.count)")
        print("Template size: \(htmlTemplate.count) bytes")
    }
}
```

### In Tests

Perfect for loading test data with parametrized tests:

```swift
import Testing
import SwiftEmbed

@Suite("API Tests")
struct APITests {
    struct TestCase: Decodable {
        let input: String
        let expected: String
    }
    
    @Test("URL Validation", arguments: Embedded.getJSON(Bundle.module, path: "TestData/url_tests.json", as: [TestCase].self))
    func testURLs(testCase: TestCase) {
        // Test implementation
    }
}
```

### Direct Loading

You can also load resources directly without property wrappers:

```swift
import SwiftEmbed

// Load and decode JSON
let users = Embedded.getJSON(Bundle.main, path: "users.json", as: [User].self)

// Load and decode YAML
let config = Embedded.getYAML(Bundle.main, path: "config.yaml", as: Config.self)

// Load plain text
let template = Embedded.getText(Bundle.main, path: "template.html")

// In tests with Bundle.module
let testData = Embedded.getJSON(Bundle.module, path: "TestData/tests.json", as: [TestCase].self)
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
        .copy("Resources")  // Use .copy() to preserve directory structure
        // .process() will flatten the directory structure
    ]
)
```

**Important:** Always use `.copy()` instead of `.process()` to preserve your directory structure. The `.process()` rule will flatten directories and may cause resource loading to fail.

## Requirements

- Swift 6.0+
- iOS 15.0+ / macOS 12.0+ / tvOS 15.0+ / watchOS 8.0+