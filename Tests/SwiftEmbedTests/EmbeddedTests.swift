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

    struct ConfigApp: Decodable, Equatable {
        let name: String
        let version: String
        let debug: Bool
    }

    struct ConfigDatabase: Decodable, Equatable {
        let host: String
        let port: Int
        let name: String
    }

    struct Config: Decodable, Equatable {
        let app: ConfigApp
        let database: ConfigDatabase
        let features: [String]
    }

    // MARK: - JSON Tests

    @Test("Load JSON file using @Embedded.JSON")
    func testLoadJSON() {
        @Embedded.JSON(Bundle.module, path: "TestData/sample.json")
        var user: User

        #expect(user.name == "Test User")
        #expect(user.age == 30)
        #expect(user.email == "test@example.com")
        #expect(user.tags == ["swift", "testing", "json"])
    }

    @Test("JSON property wrapper maintains value")
    func testJSONValueConsistency() {
        @Embedded.JSON(Bundle.module, path: "TestData/sample.json")
        var user: User

        let firstAccess = user
        let secondAccess = user

        #expect(firstAccess == secondAccess)
    }

    // MARK: - YAML Tests

    @Test("Load YAML file using @Embedded.YAML")
    func testLoadYAML() {
        @Embedded.YAML(Bundle.module, path: "TestData/config.yaml")
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
        @Embedded.YAML(Bundle.module, path: "TestData/config.yaml")
        var config: Config

        let firstAccess = config
        let secondAccess = config

        #expect(firstAccess == secondAccess)
    }

    // MARK: - Text Tests

    @Test("Load text file using @Embedded.Text")
    func testLoadText() {
        @Embedded.Text(Bundle.module, path: "TestData/sample.txt")
        var content: String

        #expect(content.contains("Hello, World!"))
        #expect(content.contains("This is a test text file."))
        #expect(content.contains("With multiple lines."))
    }

    @Test("Load text file using getText method")
    func testGetText() {
        let content = Embedded.getText(Bundle.module, path: "TestData/sample.txt")

        #expect(content.contains("Hello, World!"))
        #expect(content.contains("This is a test text file."))
        #expect(content.contains("With multiple lines."))
    }

    @Test("Text property wrapper maintains value")
    func testTextValueConsistency() {
        @Embedded.Text(Bundle.module, path: "TestData/sample.txt")
        var content: String

        let firstAccess = content
        let secondAccess = content

        #expect(firstAccess == secondAccess)
    }
}
