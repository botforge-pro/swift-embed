import Foundation
import Yams

/// Namespace for embedded resource property wrappers
public enum Embedded {
    // Apple docs: "You can add, remove, and query items in the cache from different threads"
    // https://developer.apple.com/documentation/foundation/nscache
    nonisolated(unsafe) private static let cache = NSCache<NSString, AnyObject>()
    public static func getJSON<T: Decodable>(_ bundle: Bundle, path: String, as type: T.Type = T.self) -> T {
        let cacheKey = "\(bundle.bundleIdentifier ?? "unknown"):\(path):json:\(T.self)" as NSString

        if let cached = cache.object(forKey: cacheKey),
           let typedBox = cached as? Box<T> {
            return typedBox.value
        }

        let data = loadData(path: path, bundle: bundle)

        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(T.self, from: data)
            cache.setObject(Box(result), forKey: cacheKey)
            return result
        } catch {
            fatalError("Failed to decode JSON from '\(path)': \(error)")
        }
    }

    public static func getYAML<T: Decodable>(_ bundle: Bundle, path: String, as type: T.Type = T.self) -> T {
        let cacheKey = "\(bundle.bundleIdentifier ?? "unknown"):\(path):yaml:\(T.self)" as NSString

        if let cached = cache.object(forKey: cacheKey),
           let typedBox = cached as? Box<T> {
            return typedBox.value
        }

        let data = loadData(path: path, bundle: bundle)

        do {
            let decoder = YAMLDecoder()
            let result = try decoder.decode(T.self, from: data)
            cache.setObject(Box(result), forKey: cacheKey)
            return result
        } catch {
            fatalError("Failed to decode YAML from '\(path)': \(error)")
        }
    }

    public static func getText(_ bundle: Bundle, path: String) -> String {
        let cacheKey = "\(bundle.bundleIdentifier ?? "unknown"):\(path):text" as NSString

        if let cached = cache.object(forKey: cacheKey) as? NSString {
            return cached as String
        }

        let data = loadData(path: path, bundle: bundle)

        guard let string = String(data: data, encoding: .utf8) else {
            fatalError("Failed to decode text from '\(path)': not valid UTF-8")
        }

        cache.setObject(string as NSString, forKey: cacheKey)
        return string
    }

    @propertyWrapper
    public struct JSON<T: Decodable>: Sendable where T: Sendable {
        private let value: T

        public var wrappedValue: T {
            value
        }

        public init(_ bundle: Bundle, path: String) {
            let data = Self.loadData(path: path, bundle: bundle)

            do {
                let decoder = JSONDecoder()
                self.value = try decoder.decode(T.self, from: data)
            } catch {
                fatalError("Failed to decode JSON from '\(path)': \(error)")
            }
        }
    }

    @propertyWrapper
    public struct YAML<T: Decodable>: Sendable where T: Sendable {
        private let value: T

        public var wrappedValue: T {
            value
        }

        public init(_ bundle: Bundle, path: String) {
            let data = Self.loadData(path: path, bundle: bundle)

            do {
                let decoder = YAMLDecoder()
                self.value = try decoder.decode(T.self, from: data)
            } catch {
                fatalError("Failed to decode YAML from '\(path)': \(error)")
            }
        }
    }

    @propertyWrapper
    public struct Text: Sendable {
        private let value: String

        public var wrappedValue: String {
            value
        }

        public init(_ bundle: Bundle, path: String) {
            let data = Self.loadData(path: path, bundle: bundle)

            guard let string = String(data: data, encoding: .utf8) else {
                fatalError("Failed to decode text from '\(path)': not valid UTF-8")
            }

            self.value = string
        }
    }
}

// MARK: - Private Helpers

// Helper class to box values for type-safe caching
private final class Box<T>: NSObject {
    let value: T
    init(_ value: T) {
        self.value = value
    }
}

private extension Embedded {
    static func loadData(path: String, bundle: Bundle) -> Data {

        // Split path into components
        let pathComponents = path.split(separator: "/").map(String.init)
        let filename = pathComponents.last ?? path
        let url = URL(fileURLWithPath: filename)
        let nameWithoutExtension = url.deletingPathExtension().lastPathComponent
        let fileExtension = url.pathExtension
        let subdirectory: String? = pathComponents.count > 1
            ? pathComponents.dropLast().joined(separator: "/")
            : nil

        guard let resourceURL = bundle.url(
            forResource: nameWithoutExtension,
            withExtension: fileExtension,
            subdirectory: subdirectory
        ) else {
            fatalError("Resource not found: '\(path)' in bundle: \(bundle.bundlePath)")
        }

        do {
            return try Data(contentsOf: resourceURL)
        } catch {
            fatalError("Failed to load resource '\(path)': \(error)")
        }
    }
}

private extension Embedded.JSON {
    static func loadData(path: String, bundle: Bundle) -> Data {
        Embedded.loadData(path: path, bundle: bundle)
    }
}

private extension Embedded.YAML {
    static func loadData(path: String, bundle: Bundle) -> Data {
        Embedded.loadData(path: path, bundle: bundle)
    }
}

private extension Embedded.Text {
    static func loadData(path: String, bundle: Bundle) -> Data {
        Embedded.loadData(path: path, bundle: bundle)
    }
}
