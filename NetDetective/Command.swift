import Cocoa
import Combine

protocol Commanding {
    var launchPath: LaunchPath { get }
    var arguments: [String]? { get set }
    var publisher: AnyPublisher<String, Error> { get }

    func launch()
}

final class Command: Commanding {
    enum ProcessError: Error {
        case failed(code: Int)
        case missingData
        case invalidDataType
    }

    private let process = Process()
    private let output = Pipe()
    private let notificationCenter: NotificationCenter
    let launchPath: LaunchPath
    var arguments: [String]? {
        get { return process.arguments }
        set { process.arguments = newValue }
    }
    var publisher: AnyPublisher<String, Error> {
        return notificationCenter.publisher(for: .NSFileHandleReadToEndOfFileCompletion,
                                                 object: output.fileHandleForReading)
        .tryMap { notification -> String in
            if let errorNumber = notification.userInfo?["NSFileHandleError"] as? NSNumber {
                throw ProcessError.failed(code: errorNumber.intValue)
            }
            guard let item = notification.userInfo?[NSFileHandleNotificationDataItem] as? Data else {
                throw ProcessError.missingData
            }
            guard let string = String(data: item, encoding: String.Encoding.utf8) else {
                throw ProcessError.invalidDataType
            }
            return string
        }.mapError { error in
            return error
        }.eraseToAnyPublisher()
    }

    init(launchPath: LaunchPath, arguments: [String]?, notificationCenter: NotificationCenter = .default) {
        self.launchPath = launchPath
        self.notificationCenter = notificationCenter
        self.arguments = arguments

        process.launchPath = launchPath.rawValue
        process.arguments = arguments
        process.standardOutput = output
        output.fileHandleForReading.readToEndOfFileInBackgroundAndNotify()
    }

    func launch() {
        process.launch()
        process.waitUntilExit()
    }
}
