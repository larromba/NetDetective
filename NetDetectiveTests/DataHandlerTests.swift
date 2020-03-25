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

    func testDataHandlerReturnsItemsWhenGivenValidInput() {
        // mocks
        let expectation = self.expectation(description: "returns items")

        // sut
        DataHandler.process(string: .validNettopInput).sink(receiveCompletion: {
            XCTAssertNil($0.error)
        }, receiveValue: { items in
            XCTAssertEqual(items.count, 11)
            expectation.fulfill()
        }).store(in: &cancellable)

        // test
        waitForExpectations(timeout: 0.1) { XCTAssertNil($0) }
    }

    func testDataHandlerThrowsErrorWhenGivenInvalidNettopInput() {
        // mocks
        let expectation = self.expectation(description: "throws error")

        // sut
        DataHandler.process(string: .invalidNettopInput).sink(receiveCompletion: {
            if case DataHandler.ProcessingError.unexpectedFormat? = $0.error {
                expectation.fulfill()
            } else {
                XCTFail(.unexpectedError($0.error))
            }
        }, receiveValue: {
            XCTFail(.unexpectedValue($0))
        }).store(in: &cancellable)

        // test
        waitForExpectations(timeout: 0.1) { XCTAssertNil($0) }
    }

    func testDataHandlerFiltersOutProcessesWithZeroBytes() {
        // mocks
        let expectation = self.expectation(description: "0 byte processes filtered out")

        // sut
        DataHandler.process(string: .noBytesNettopInput).sink(receiveCompletion: {
            XCTAssertNil($0.error)
        }, receiveValue: { items in
            XCTAssertEqual(items.count, 1)
            XCTAssertGreaterThan(items.first?.maxBytesAgnostic ?? 0, 0)
            expectation.fulfill()
        }).store(in: &cancellable)

        // test
        waitForExpectations(timeout: 0.1) { XCTAssertNil($0) }
    }

    func testDataHandlerSortsProcessesMaxToMinBytes() {
        // mocks
        let expectation = self.expectation(description: "processes sorted +(top) -(bottom)")

        // sut
        DataHandler.process(string: .validNettopInput).sink(receiveCompletion: {
            XCTAssertNil($0.error)
        }, receiveValue: { items in
            XCTAssertGreaterThan(items.first?.maxBytesAgnostic ?? 0,
                                 items.last?.maxBytesAgnostic ?? 0)
            expectation.fulfill()
        }).store(in: &cancellable)

        // test
        waitForExpectations(timeout: 0.1) { XCTAssertNil($0) }
    }

    func testDataHandlerReturnsNoItemsWhenGivenNoProcesses() {
        // mocks
        let expectation = self.expectation(description: "returns no items")

        // sut
        DataHandler.process(string: .noProcessesNettopInput).sink(receiveCompletion: {
            XCTAssertNil($0.error)
        }, receiveValue: { items in
            XCTAssertEqual(items.count, 0)
            expectation.fulfill()
        }).store(in: &cancellable)

        // test
        waitForExpectations(timeout: 0.1) { XCTAssertNil($0) }
    }
}
