import XCTest
@testable import PerfectFlock

class PerfectFlockTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(PerfectFlock().text, "Hello, World!")
    }


    static var allTests : [(String, (PerfectFlockTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
