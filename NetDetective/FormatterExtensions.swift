import Combine
import Foundation

enum StringFormatError: Error {
    case cString
    case length
}

extension Formatter {
    static func format(items: [NetworkItem]) -> AnyPublisher<String, Error> {
        guard !items.isEmpty else {
            return .success("no processes are sending or receiving data")
        }
        do {
            let column1Length = try self.column1Length(from: items)
            let column2Length = try self.column2Length(from: items)
            let column3Length = try self.column3Length(from: items)
            let format = "%-\(column1Length)s %-\(column2Length)s %-\(column3Length)s %@\n"
            var output = String(format: format,
                                try "PROCESS".cString(),
                                try "IN".cString(),
                                try "OUT".cString(),
                                "MORE INFO...")
            try items.forEach {
                output.append(String(format: format,
                                     try $0.nameFormatted.cString(),
                                     try $0.bytesInFormatted.cString(),
                                     try $0.bytesOutFormatted.cString(),
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
        var strings = items.map { $0.bytesInFormatted }
        strings = strings.sorted(by: { $0.count > $1.count })
        guard let length = strings.first?.count else { throw StringFormatError.length }
        return length + 5
    }

    private static func column3Length(from items: [NetworkItem]) throws -> Int {
        var strings = items.map { $0.bytesOutFormatted }
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
