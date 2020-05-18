import XCTest

final class NetworkItemTests: XCTestCase {
    func test_networkItem_whenGivenValidData_expectCorrectOutput() {
        // sut
        let item = try? NetworkItem(data: "12:09:02.247187,systemstats.154,2000,10000000,")

        // test
        XCTAssertEqual(item?.timeFormatted, "12:09:02")
        XCTAssertEqual(item?.name, "systemstats.154")
        XCTAssertEqual(item?.nameFormatted, "systemstats")
        XCTAssertEqual(item?.bytesIn, 2000)
        XCTAssertEqual(item?.bytesInFormatted, "2 KB")
        XCTAssertEqual(item?.bytesOut, 10_000_000)
        XCTAssertEqual(item?.bytesOutFormatted, "9.5 MB")
    }

    func test_networkItem_whenGivenTooFewItems_expectCorrectError() {
        // test
        XCTAssertThrowsError(try NetworkItem(data: "12:09:02.247187"), "", {
            guard case NetworkItem.InitError.invalidItemCount(_, _, _) = $0 else {
                XCTFail(.unexpectedError($0))
                return
            }
        })
    }

    func test_networkItem_whenGivenTooManyItems_expectCorrectError() {
        // test
        XCTAssertThrowsError(try NetworkItem(data: "12:09:02.247187,systemstats.154,0,0,0,0"), "", {
            guard case NetworkItem.InitError.invalidItemCount(_, _, _) = $0 else {
                XCTFail(.unexpectedError($0))
                return
            }
        })
    }

    func test_networkItem_whenGivenInvalidDate_expectCorrectError() {
        // test
        XCTAssertThrowsError(try NetworkItem(data: "12:09:02,systemstats.154,0,0,"), "", {
            guard case NetworkItem.InitError.invalidTime(_, _) = $0 else {
                XCTFail(.unexpectedError($0))
                return
            }
        })
    }

    func test_networkItem_whenMissingBytes_expectZeroBytes() {
        // sut
        var item = try? NetworkItem(data: "12:09:02.247187,systemstats.154")
        // test
        XCTAssertEqual(item?.bytesIn, 0)
        XCTAssertEqual(item?.bytesOut, 0)

        // sut
        item = try? NetworkItem(data: "12:09:02.247187,systemstats.154,")
        // test
        XCTAssertEqual(item?.bytesIn, 0)
        XCTAssertEqual(item?.bytesOut, 0)

        // sut
        item = try? NetworkItem(data: "12:09:02.247187,systemstats.154,,")
        // test
        XCTAssertEqual(item?.bytesIn, 0)
        XCTAssertEqual(item?.bytesOut, 0)
    }

    func test_networkItem_whenGivenInvalidBytes_expectCorrectError() {
        // test
        XCTAssertThrowsError(try NetworkItem(data: "12:09:02.247187,systemstats.154,z,0,"), "", {
            guard case NetworkItem.InitError.invalidByte(_, _) = $0 else {
                XCTFail(.unexpectedError($0))
                return
            }
        })
        // test
        XCTAssertThrowsError(try NetworkItem(data: "12:09:02.247187,systemstats.154,0,z,"), "", {
            guard case NetworkItem.InitError.invalidByte(_, _) = $0 else {
                XCTFail(.unexpectedError($0))
                return
            }
        })
    }

    func test_maxBytesAgnostic_whenGivenBytes_expectHighestByte() {
        // sut
        var item = try? NetworkItem(data: "12:09:02.247187,systemstats.154,20,30")
        // test
        XCTAssertEqual(item?.maxBytesAgnostic, 30)

        // sut
        item = try? NetworkItem(data: "12:09:02.247187,systemstats.154,30,20")
        // test
        XCTAssertEqual(item?.bytesIn, 30)
    }
}
