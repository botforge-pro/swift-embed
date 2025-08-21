import Foundation
import Yams

/// Namespace for embedded resource property wrappers
public enum Embedded {
    /// Load JSON resource and decode it to the specified type
    public static func getJSON<T: Decodable>(_ path: String, bundle: Bundle = Bundle.main, as type: T.Type = T.self) -> T {
        @Embedded.json(path, bundle: bundle)
        var value: T
        return value
    }
    
    /// Load YAML resource and decode it to the specified type
    public static func getYAML<T: Decodable>(_ path: String, bundle: Bundle = Bundle.main, as type: T.Type = T.self) -> T {
        @Embedded.yaml(path, bundle: bundle)
        var value: T
        return value
    }
    
    @propertyWrapper
    public struct json<T: Decodable> {
        private let value: T
        
        public var wrappedValue: T {
            value
        }
        
        public init(_ path: String, bundle: Bundle = Bundle.main) {
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
    public struct yaml<T: Decodable> {
        private let value: T
        
        public var wrappedValue: T {
            value
        }
        
        public init(_ path: String, bundle: Bundle = Bundle.main) {
            let data = Self.loadData(path: path, bundle: bundle)
            
            do {
                let decoder = YAMLDecoder()
                self.value = try decoder.decode(T.self, from: data)
            } catch {
                fatalError("Failed to decode YAML from '\(path)': \(error)")
            }
        }
    }
}

// MARK: - Private Helpers
private extension Embedded.json {
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

private extension Embedded.yaml {
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