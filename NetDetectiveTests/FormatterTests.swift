import Combine
import XCTest

final class FormatterTests: XCTestCase {
    private var cancellable: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        cancellable = Set<AnyCancellable>()
    }

    override func tearDown() {
        cancellable = nil
        super.tearDown()
    }

    func testFormatterReturnsMessageWhenGivenEmptyItems() {
        // test
        Formatter.format(items: []).sink(receiveCompletion: {
            XCTAssertNil($0.error)
        }, receiveValue: {
            XCTAssertEqual($0, "no processes are sending or receiving data")
        }).store(in: &cancellable)
    }

    //swiftlint:disable force_try
    func testFormatterMessageWhenGivenValidInput() {
        // mocks
        let items = ["12:09:02.247187,systemstats.154,1000,0,",
                     "12:09:02.243847,udp4 *:*<->*:*,,,",
                     "12:09:02.247191,configd.155,0,1000000,"].map { try! NetworkItem(data: $0) }

        // test
        Formatter.format(items: items).sink(receiveCompletion: {
            XCTAssertNil($0.error)
        }, receiveValue: {
            XCTAssertEqual($0, .validFormatterOutput)
        }).store(in: &cancellable)
    }
}
