import Foundation
import Combine

enum StringFormatError: Error {
    case cString
    case length
}

extension Formatter {
    static func format(items: [NetworkItem]) -> AnyPublisher<String, Error> {
        do {
            let column1Length = try self.column1Length(from: items)
            let column2Length = try self.column2Length(from: items)
            var output = String(format: "%-\(column1Length)s %-\(column2Length)s %@\n",
                                try "PROCESS".cString(),
                                try "SENT".cString(),
                                "MORE INFO...")

            try items.forEach {
                output.append(String(format: "%-\(column1Length)s %-\(column2Length)s %@\n",
                                     try $0.nameFormatted.cString(),
                                     try $0.bytesFormatted.cString(),
                                     "https://www.google.com/search?q=what+is+\($0.nameFormatted)"))
            }
            return .success(output)
        } catch {
            return .failure(error)
        }
    }

    // MARK: - private

    private static func column1Length(from items: [NetworkItem]) throws -> Int {
        var strings = items.map { $0.nameFormatted }
        strings = strings.sorted(by: { $0.count > $1.count })
        guard let length = strings.first?.count else { throw StringFormatError.length }
        return length + 5
    }

    private static func column2Length(from items: [NetworkItem]) throws -> Int {
        var strings = items.map { $0.bytesFormatted }
        strings = strings.sorted(by: { $0.count > $1.count })
        guard let length = strings.first?.count else { throw StringFormatError.length }
        return length + 5
    }
 }

// MARK: - String

private extension String {
    func cString() throws -> UnsafePointer<Int8> {
        guard let string = (self as NSString).utf8String else {
            throw StringFormatError.cString
        }
        return string
    }
}
