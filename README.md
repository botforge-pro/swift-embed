[![Tests](https://github.com/botforge-pro/swift-embed/actions/workflows/tests.yml/badge.svg)](https://github.com/botforge-pro/swift-embed/actions/workflows/tests.yml)

# SwiftEmbed

A lightweight Swift library for embedding JSON, YAML and text resources with automatic caching and Swift 6 concurrency support.

## Features

- 🎯 **Simple API** - Clean property wrapper and computed property syntax
- 📦 **JSON Support** - Built-in JSON decoding
- 📝 **YAML Support** - Full YAML decoding via Yams
- 📄 **Text Support** - Load plain text files as strings
- 🔒 **Type Safe** - Compile-time type checking with Decodable
- ⚡ **Automatic Caching** - Resources cached after first load
- 🔄 **Swift 6 Ready** - No concurrency warnings with static properties
- 📱 **Cross-Platform** - Works on iOS, macOS, tvOS, watchOS

## Installation

### Swift Package Manager

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/botforge-pro/swift-embed.git", from: "1.5.0")
]
```

## Usage

SwiftEmbed provides three ways to load resources:

### 1. Computed Properties (Recommended for Swift 6)

Best for static configuration and avoids Swift 6 concurrency warnings:

```swift
import SwiftEmbed

struct AppConfig {
    // Clean syntax, no Swift 6 warnings, automatic caching
    static var config: Config {
        Embedded.getJSON(Bundle.main, path: "Resources/config.json")
    }
    
    static var users: [User] {
        Embedded.getJSON(Bundle.main, path: "Resources/users.json")
    }
    
    static var template: String {
        Embedded.getText(Bundle.main, path: "Resources/template.html")
    }
}

// Usage
let apiURL = AppConfig.config.apiURL  // Loaded and cached on first access
let userCount = AppConfig.users.count // Retrieved from cache
```

### 2. Property Wrappers

For instance properties in classes/structs:

```swift
import SwiftEmbed

struct MyApp {
    @Embedded.JSON(Bundle.main, path: "Resources/users.json")
    var users: [User]
    
    @Embedded.YAML(Bundle.main, path: "Config/settings.yaml")
    var config: Config
    
    @Embedded.Text(Bundle.main, path: "Resources/template.html")
    var htmlTemplate: String
}
```

### 3. Direct Loading

For immediate use or dynamic loading:

```swift
import SwiftEmbed

// Load and decode JSON
let users = Embedded.getJSON(Bundle.main, path: "users.json", as: [User].self)

// Load and decode YAML
let config = Embedded.getYAML(Bundle.main, path: "config.yaml", as: Config.self)

// Load plain text
let template = Embedded.getText(Bundle.main, path: "template.html")
```

## Caching

All methods use an internal cache powered by `NSCache`:
- Resources are loaded from disk only once
- Subsequent accesses return cached values
- Memory-safe with automatic purging under pressure
- Thread-safe for concurrent access

## Testing

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
    
    // Load test data once, cached for all test runs
    static var testCases: [TestCase] {
        Embedded.getJSON(Bundle.module, path: "TestData/url_tests.json")
    }
    
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
        .copy("Resources")  // Use .copy() to preserve directory structure
        // .process() will flatten the directory structure
    ]
)
```

**Important:** Always use `.copy()` instead of `.process()` to preserve your directory structure. The `.process()` rule will flatten directories and may cause resource loading to fail.

## Swift 6 Concurrency

SwiftEmbed is fully compatible with Swift 6's strict concurrency checking:

```swift
// ✅ No warnings - computed property approach
struct MyConfig {
    static var settings: Settings {
        Embedded.getJSON(Bundle.module, path: "config.json")
    }
}

// ✅ No warnings - static let with direct call
struct MyData {
    static let data = Embedded.getJSON(Bundle.module, path: "data.json", as: DataModel.self)
}

// ⚠️ Warning with property wrapper on static var
struct BadExample {
    @Embedded.JSON(Bundle.module, path: "config.json")
    static var config: Config  // Swift 6 warning: static var not concurrency-safe
}
```

## Known Issues

### Xcode 14+ Simulator Build Error with "Resources" Folder

If you encounter a code signing error when building for iOS Simulator in Xcode 14 or later:

```
CodeSign failed with a nonzero exit code
bundle format unrecognized, invalid, or unsuitable
```

This is a known Xcode issue where it tries to code sign SPM resource bundles named "Resources" for the simulator, which is not supported.

**Solution:** Rename your resources folder to something else (e.g., `TestData`, `Assets`, `Files`):

```swift
.target(
    name: "MyApp",
    resources: [
        .copy("TestData")  // Instead of "Resources"
    ]
)
```

This issue only affects iOS Simulator builds. Device builds work fine with any folder name.

## Requirements

- Swift 6.0+
- iOS 15.0+ / macOS 12.0+ / tvOS 15.0+ / watchOS 8.0+