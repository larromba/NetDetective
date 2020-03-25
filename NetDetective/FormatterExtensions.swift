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
            let column1Length = try columnLength(from: items, keyPath: \NetworkItem.name)
            let column2Length = try columnLength(from: items, keyPath: \NetworkItem.bytesInFormatted)
            let column3Length = try columnLength(from: items, keyPath: \NetworkItem.bytesOutFormatted)
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
                                     $0.infoURL.absoluteString))
            }
            output.append("\nopen links with:\n")
            output.append("1. select all: cmd+shift+click [x2]\n")
            output.append("2. open link:  shift+click     [x2]\n")
            return .success(output)
        } catch {
            return .failure(error)
        }
    }

    // MARK: - private

    private static func columnLength(from items: [NetworkItem], keyPath: KeyPath<NetworkItem, String>) throws -> Int {
        var strings = items.map { $0[keyPath: keyPath] }
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
