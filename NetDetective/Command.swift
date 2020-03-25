import Cocoa
import Combine

protocol Commanding {
    var publisher: AnyPublisher<String, Error> { get }

    func launch()
}

final class Command: Commanding {
    enum ProcessError: Error {
        case failed(code: Int)
        case missingData
        case invalidString
    }

    private let process: Processing
    private let output: Pipeable
    private let notificationCenter: NotificationCenter
    var publisher: AnyPublisher<String, Error> {
        notificationCenter.publisher(for: .NSFileHandleReadToEndOfFileCompletion,
                                     object: output.fileHandleForReading)
        .tryMap { notification -> String in
            if let errorNumber = notification.userInfo?[.fileHandlerErrorKey] as? NSNumber {
                throw ProcessError.failed(code: errorNumber.intValue)
            }
            guard let item = notification.userInfo?[NSFileHandleNotificationDataItem] as? Data else {
                throw ProcessError.missingData
            }
            guard let string = String(data: item, encoding: String.Encoding.utf8) else {
                throw ProcessError.invalidString
            }
            return string
        }.eraseToAnyPublisher()
    }

    init(launchPath: LaunchPath, arguments: [String]?, process: Processing = Process(), output: Pipeable = Pipe(),
         notificationCenter: NotificationCenter = .default) {
        self.process = process
        self.output = output
        self.notificationCenter = notificationCenter

        process.launchPath = launchPath.rawValue
        // macOS bug:
        //   process.arguments = nil
        //   cases: caught "NSInvalidArgumentException", "must provide array of arguments"
        //   it seems arguments can't be nil, even though they're optional in the file definition
        process.arguments = arguments ?? []
        process.standardOutput = output
        output.fileHandleForReading.readToEndOfFileInBackgroundAndNotify()
    }

    func launch() {
        process.launch()
        process.waitUntilExit()
    }
}
