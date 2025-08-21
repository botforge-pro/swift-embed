import Testing
import Foundation
@testable import SwiftEmbed

@Suite("Embedded Property Wrapper Tests")
struct EmbeddedTests {
    
    // MARK: - Test Models
    
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
    
    // MARK: - JSON Tests
    
    @Test("Load JSON file using @Embedded.json")
    func testLoadJSON() {
        @Embedded.json("TestData/sample.json", bundle: Bundle.module)
        var user: User
        
        #expect(user.name == "Test User")
        #expect(user.age == 30)
        #expect(user.email == "test@example.com")
        #expect(user.tags == ["swift", "testing", "json"])
    }
    
    @Test("JSON property wrapper maintains value")
    func testJSONValueConsistency() {
        @Embedded.json("TestData/sample.json", bundle: Bundle.module)
        var user: User
        
        let firstAccess = user
        let secondAccess = user
        
        #expect(firstAccess == secondAccess)
    }
    
    // MARK: - YAML Tests
    
    @Test("Load YAML file using @Embedded.yaml")
    func testLoadYAML() {
        @Embedded.yaml("TestData/config.yaml", bundle: Bundle.module)
        var config: Config
        
        #expect(config.app.name == "TestApp")
        #expect(config.app.version == "1.0.0")
        #expect(config.app.debug == true)
        
        #expect(config.database.host == "localhost")
        #expect(config.database.port == 5432)
        #expect(config.database.name == "testdb")
        
        #expect(config.features == ["authentication", "notifications", "analytics"])
    }
    
    @Test("YAML property wrapper maintains value")
    func testYAMLValueConsistency() {
        @Embedded.yaml("TestData/config.yaml", bundle: Bundle.module)
        var config: Config
        
        let firstAccess = config
        let secondAccess = config
        
        #expect(firstAccess == secondAccess)
    }
}