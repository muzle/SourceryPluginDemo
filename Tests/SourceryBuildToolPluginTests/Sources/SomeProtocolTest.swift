import XCTest

final class SomeProtocolTest: XCTestCase {
	func testSomeProtocolMockExist() {
		let subject = SomeProtocolMock()
		XCTAssertNil(subject.makeIntIntReturnValue)
	}
}
