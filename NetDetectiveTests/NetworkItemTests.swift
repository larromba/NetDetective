import XCTest

final class NetworkItemTests: XCTestCase {
    func testValidData() {
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

    func testTooFewItemsThrowsError() {
        // test
        XCTAssertThrowsError(try NetworkItem(data: "12:09:02.247187"), "", { error in
            guard case NetworkItem.InitError.invalidItemCount(_, _, _) = error else {
                XCTFail("received unexpected error \(error)")
                return
            }
        })
    }

    func testTooMayItemsThrowsError() {
        // test
        XCTAssertThrowsError(try NetworkItem(data: "12:09:02.247187,systemstats.154,0,0,0,0"), "", { error in
            guard case NetworkItem.InitError.invalidItemCount(_, _, _) = error else {
                XCTFail("received unexpected error \(error)")
                return
            }
        })
    }

    func testInvalidTimeThrowsInvalidDateError() {
        // test
        XCTAssertThrowsError(try NetworkItem(data: "12:09:02,systemstats.154,0,0,"), "", { error in
            guard case NetworkItem.InitError.invalidTime(_, _) = error else {
                XCTFail("received unexpected error \(error)")
                return
            }
        })
    }

    func testBytesMissingZerosBytes() {
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

    func testInvalidBytesThrowsError() {
        // test
        XCTAssertThrowsError(try NetworkItem(data: "12:09:02.247187,systemstats.154,z,0,"), "", { error in
            guard case NetworkItem.InitError.invalidBytes(_, _) = error else {
                XCTFail("received unexpected error \(error)")
                return
            }
        })
        // test
        XCTAssertThrowsError(try NetworkItem(data: "12:09:02.247187,systemstats.154,0,z,"), "", { error in
            guard case NetworkItem.InitError.invalidBytes(_, _) = error else {
                XCTFail("received unexpected error \(error)")
                return
            }
        })
    }

    func testMaxBytesAgnosticIsAlwaysGreatestByteValue() {
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
