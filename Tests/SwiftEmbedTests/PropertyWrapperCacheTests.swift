import Testing
import Foundation
@testable import SwiftEmbed

@Suite("Property Wrapper Cache Tests")
struct PropertyWrapperCacheTests {

    @Test("Property wrappers use shared cache")
    func testPropertyWrappersUseCache() {
        // First instance loads from disk
        struct Instance1 {
            @Embedded.JSON(Bundle.module, path: "TestData/sample.json")
            var user: User
        }

        // Second instance should get from cache
        struct Instance2 {
            @Embedded.JSON(Bundle.module, path: "TestData/sample.json")
            var user: User
        }

        // Direct call also uses same cache
        let directUser = Embedded.getJSON(Bundle.module, path: "TestData/sample.json", as: User.self)

        let inst1 = Instance1()
        let inst2 = Instance2()

        #expect(inst1.user == inst2.user)
        #expect(inst1.user == directUser)
    }

    // Reuse model from other tests
    struct User: Decodable, Equatable {
        let name: String
        let age: Int
        let email: String
        let tags: [String]
    }
}
