import Combine
import XCTest

final class DataHandlerTests: XCTestCase {
    private var cancellable: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        cancellable = Set<AnyCancellable>()
    }

    override func tearDown() {
        cancellable = nil
        super.tearDown()
    }

    func testDataHandlerCanProcessesValidNettopOutput() {
        // mocks
        let expectation = self.expectation(description: "can process valid nettop output")

        // sut
        DataHandler.process(string: .validNettopOutput).sink(receiveCompletion: {
            XCTAssertNil($0.error)
        }, receiveValue: { items in
            XCTAssertEqual(items.count, 11)
            expectation.fulfill()
        }).store(in: &cancellable)

        // test
        waitForExpectations(timeout: 0.1) { XCTAssertNil($0) }
    }

    func testDataHandlerThrowsErrorForInvalidNettopOutput() {
        // mocks
        let expectation = self.expectation(description: "can handle invalid nettop output")

        // sut
        DataHandler.process(string: .invalidNettopOutput).sink(receiveCompletion: {
            XCTAssertNotNil($0.error)
            expectation.fulfill()
        }, receiveValue: { _ in
            XCTFail("unexpected success")
        }).store(in: &cancellable)

        // test
        waitForExpectations(timeout: 0.1) { XCTAssertNil($0) }
    }

    func testDataHandlerFiltersOutProcessesWithNoBytes() {
        // mocks
        let expectation = self.expectation(description: "can filter out 0 byte processes")

        // sut
        DataHandler.process(string: .noBytesNettopOutput).sink(receiveCompletion: {
            XCTAssertNil($0.error)
        }, receiveValue: { items in
            XCTAssertEqual(items.count, 0)
            expectation.fulfill()
        }).store(in: &cancellable)

        // test
        waitForExpectations(timeout: 0.1) { XCTAssertNil($0) }
    }

    func testDataHandlerSortsProcessesMaxToMinBytes() {
        // mocks
        let expectation = self.expectation(description: "can sort processes +>-")

        // sut
        DataHandler.process(string: .validNettopOutput).sink(receiveCompletion: {
            XCTAssertNil($0.error)
        }, receiveValue: { items in
            XCTAssertGreaterThan(items.first?.maxBytesAgnostic ?? 0,
                                 items.last?.maxBytesAgnostic ?? 0)
            expectation.fulfill()
        }).store(in: &cancellable)

        // test
        waitForExpectations(timeout: 0.1) { XCTAssertNil($0) }
    }

    func testDataHandlerCanHandleNoProcesses() {
        // mocks
        let expectation = self.expectation(description: "can handle no processes")

        // sut
        DataHandler.process(string: .noProcessesNettopOutput).sink(receiveCompletion: {
            XCTAssertNil($0.error)
        }, receiveValue: { items in
            XCTAssertEqual(items.count, 0)
            expectation.fulfill()
        }).store(in: &cancellable)

        // test
        waitForExpectations(timeout: 0.1) { XCTAssertNil($0) }
    }
}
