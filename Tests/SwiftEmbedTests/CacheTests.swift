import Testing
import Foundation
@testable import SwiftEmbed

@Suite("Cache Tests")
struct CacheTests {
    
    struct TestData: Decodable, Equatable {
        let value: String
    }
    
    @Test("Computed properties use cache")
    func testComputedPropertyCache() {
        // Using computed property multiple times
        var data1: TestData {
            Embedded.getJSON(Bundle.module, path: "TestData/sample.json", as: User.self)
                .tags.isEmpty ? TestData(value: "empty") : TestData(value: "has_tags")
        }
        
        var data2: TestData {
            Embedded.getJSON(Bundle.module, path: "TestData/sample.json", as: User.self)
                .tags.isEmpty ? TestData(value: "empty") : TestData(value: "has_tags")
        }
        
        // Both should return same result from cache
        #expect(data1 == data2)
        #expect(data1.value == "has_tags")
    }
    
    struct Container {
        static var user: User {
            Embedded.getJSON(Bundle.module, path: "TestData/sample.json")
        }
        
        static var config: Config {
            Embedded.getYAML(Bundle.module, path: "TestData/config.yaml")
        }
        
        static var text: String {
            Embedded.getText(Bundle.module, path: "TestData/sample.txt")
        }
    }
    
    @Test("Static computed properties work in Swift 6")
    func testStaticComputedProperties() {
        // Access multiple times to verify caching
        let user1 = Container.user
        let user2 = Container.user
        #expect(user1 == user2)
        #expect(user1.name == "Test User")
        
        let config1 = Container.config
        let config2 = Container.config
        #expect(config1 == config2)
        
        let text1 = Container.text
        let text2 = Container.text
        #expect(text1 == text2)
    }
    
    // Reuse models from EmbeddedTests
    struct User: Decodable, Equatable {
        let name: String
        let age: Int
        let email: String
        let tags: [String]
    }
    
    struct Config: Decodable, Equatable {
        struct App: Decodable, Equatable {
            let name: String
            let version: String
            let debug: Bool
        }
        struct Database: Decodable, Equatable {
            let host: String
            let port: Int
            let name: String
        }
        let app: App
        let database: Database
        let features: [String]
    }
}