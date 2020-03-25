import Foundation

struct NetworkItem {
    enum InitError: Error {
        case invalidItemCount(expected: String, count: Int, inData: String)
        case invalidTime(time: String, inData: String)
        case invalidByte(byte: String, inData: String)
    }

    var time: Date
    var name: String
    var bytesIn: Int
    var bytesOut: Int
    var subItems = [NetworkItem]()

    init(data: String) throws {
        let items = data.split(separator: ",").map { String($0) }
        guard items.count >= 2 else {
            throw InitError.invalidItemCount(expected: ">=2", count: items.count, inData: data)
        }
        time = try NetworkItem.time(for: items, in: data)
        name = String(items[1])

        let bytes = try NetworkItem.bytes(for: items, in: data)
        bytesIn = bytes.byteIn
        bytesOut = bytes.byteOut
    }

    // MARK: - private

    private static func time(for items: [String], in data: String) throws -> Date {
        let item = items[0]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss.SSSSSS"
        guard let date = dateFormatter.date(from: item) else {
            throw InitError.invalidTime(time: item, inData: data)
        }
        return date
    }

    private static func bytes(for items: [String], in data: String) throws -> (byteIn: Int, byteOut: Int) {
        if items.count == 2 {
            return (0, 0)
        }
        guard items.count == 4 else {
            throw InitError.invalidItemCount(expected: "4", count: items.count, inData: data)
        }
        let byteIn = try byte(for: items[2], in: data)
        let byteOut = try byte(for: items[3], in: data)
        return (byteIn, byteOut)
    }

    private static func byte(for item: String, in data: String) throws -> Int {
        if item.isEmpty {
            return 0
        }
        guard let byte = Int(item) else {
            throw InitError.invalidByte(byte: item, inData: data)
        }
        return byte
    }
}

// MARK: - NetworkItem utility

extension NetworkItem {
    var timeFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: time)
    }

    var nameFormatted: String {
        if let name = name.split(separator: ".").first {
            return String(name)
        } else {
            return name
        }
    }

    var bytesInFormatted: String {
        if bytesIn == 0 {
            return "-"
        }
        return ByteCountFormatter.string(fromByteCount: Int64(bytesIn), countStyle: .memory)
    }

    var bytesOutFormatted: String {
        if bytesOut == 0 {
            return "-"
        }
        return ByteCountFormatter.string(fromByteCount: Int64(bytesOut), countStyle: .memory)
    }

    var maxBytesAgnostic: Int {
        bytesIn > bytesOut ? bytesIn : bytesOut
    }
}
