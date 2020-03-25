import Combine
import XCTest

final class CommandTests: XCTestCase {
    private var cancellable: Set<AnyCancellable>!
    private var command: Command!
    private var process: MockProcess!
    private var output: Pipe!
    private var notificationCenter: NotificationCenter!

    override func setUp() {
        super.setUp()
        cancellable = Set<AnyCancellable>()
        notificationCenter = .default
        process = MockProcess()
        output = Pipe()
        command = Command(launchPath: .nettop, arguments: [], process: process, output: output,
                          notificationCenter: notificationCenter)
    }

    override func tearDown() {
        cancellable = nil
        notificationCenter = nil
        command = nil
        output = nil
        command = nil
        super.tearDown()
    }

    func testCommandThrowsErrorWhenReceivesSystemError() {
        // mocks
        let expectation = self.expectation(description: "throws error")
        let code = 999
        command.publisher.sink(receiveCompletion: {
            if case Command.ProcessError.failed(999)? = $0.error {
                expectation.fulfill()
            } else {
                XCTFail(.unexpectedError($0.error))
            }
        }, receiveValue: {
            XCTFail(.unexpectedValue($0))
        }).store(in: &cancellable)

        // sut
        let notification = Notification(
            name: .NSFileHandleReadToEndOfFileCompletion,
            object: output.fileHandleForReading,
            userInfo: ["NSFileHandleError": code]
        )
        notificationCenter.post(notification)

        // test
        waitForExpectations(timeout: 0.1) { XCTAssertNil($0) }
    }

    func testCommandThrowsErrorWhenReceivesMissingData() {
        // mocks
        let expectation = self.expectation(description: "throws error")
        command.publisher.sink(receiveCompletion: {
            if case Command.ProcessError.missingData? = $0.error {
                expectation.fulfill()
            } else {
                XCTFail(.unexpectedError($0.error))
            }
        }, receiveValue: {
            XCTFail(.unexpectedValue($0))
        }).store(in: &cancellable)

        // sut
        let notification = Notification(
            name: .NSFileHandleReadToEndOfFileCompletion,
            object: output.fileHandleForReading,
            userInfo: [NSFileHandleNotificationDataItem: 0]
        )
        notificationCenter.post(notification)

        // test
        waitForExpectations(timeout: 0.1) { XCTAssertNil($0) }
    }

    func testCommandThrowsErrorWhenReceivesInvalidString() {
        // mocks
        let expectation = self.expectation(description: "throws error")
        command.publisher.sink(receiveCompletion: {
            if case Command.ProcessError.invalidString? = $0.error {
                expectation.fulfill()
            } else {
                XCTFail(.unexpectedError($0.error))
            }
        }, receiveValue: {
            XCTFail(.unexpectedValue($0))
        }).store(in: &cancellable)

        // sut
        let notification = Notification(
            name: .NSFileHandleReadToEndOfFileCompletion,
            object: output.fileHandleForReading,
            userInfo: [NSFileHandleNotificationDataItem: NSImage.invalidData.tiffRepresentation!]
        )
        notificationCenter.post(notification)

        // test
        waitForExpectations(timeout: 0.1) { XCTAssertNil($0) }
    }

    func testCommandProcessLaunchesAndWaitsWhenLaunchCalled() {
        // sut
        command.launch()

        // test
        XCTAssertTrue(process.invocations.isInvoked(MockProcess.launch1.name))
        XCTAssertTrue(process.invocations.isInvoked(MockProcess.waitUntilExit2.name))
    }

    func testCommandProcessHasOutputWhenLaunchCalled() {
        // sut
        command.launch()

        // test
        XCTAssertNotNil(process.standardOutput)
    }
}
