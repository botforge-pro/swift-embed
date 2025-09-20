import Foundation
import Yams

/// Namespace for embedded resource property wrappers
public enum Embedded {
    /// Load JSON resource and decode it to the specified type
    public static func getJSON<T: Decodable>(_ bundle: Bundle, path: String, as type: T.Type = T.self) -> T {
        let data = loadData(path: path, bundle: bundle)

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Failed to decode JSON from '\(path)': \(error)")
        }
    }

    /// Load YAML resource and decode it to the specified type
    public static func getYAML<T: Decodable>(_ bundle: Bundle, path: String, as type: T.Type = T.self) -> T {
        let data = loadData(path: path, bundle: bundle)

        do {
            let decoder = YAMLDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Failed to decode YAML from '\(path)': \(error)")
        }
    }

    /// Load text resource as String
    public static func getText(_ bundle: Bundle, path: String) -> String {
        let data = loadData(path: path, bundle: bundle)

        guard let string = String(data: data, encoding: .utf8) else {
            fatalError("Failed to decode text from '\(path)': not valid UTF-8")
        }

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
private extension Embedded {
    static func loadData(path: String, bundle: Bundle) -> Data {
        // Split path into components
        let pathComponents = path.split(separator: "/").map(String.init)

        // Extract filename and extension from last component
        let filename = pathComponents.last ?? path
        let url = URL(fileURLWithPath: filename)
        let nameWithoutExtension = url.deletingPathExtension().lastPathComponent
        let fileExtension = url.pathExtension

        // Get subdirectory if path has multiple components
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
