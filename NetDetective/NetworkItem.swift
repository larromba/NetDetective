import Foundation

struct NetworkItem {
    enum InitError: Error {
        case invalidItemCount(expected: String, count: Int, forItem: String)
        case invalidDate(date: String, forItem: String)
        case invalidBytes(bytes: String, forItem: String)
    }

    var time: Date
    var name: String
    var bytesIn: Int
    var bytesOut: Int
    var subItems = [NetworkItem]()

    init(data: String) throws {
        let items = data.split(separator: ",").map { String($0) }
        guard items.count >= 2 else {
            throw InitError.invalidItemCount(expected: ">=2", count: items.count, forItem: data)
        }
        time = try NetworkItem.time(for: items, in: data)
        name = String(items[1])
        bytesIn = try NetworkItem.bytesIn(for: items, in: data)
        bytesOut = try NetworkItem.bytesOut(for: items, in: data)
    }

    // MARK: - private

    private static func time(for items: [String], in data: String) throws -> Date {
        let item = items[0]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss.SSSSSS"
        guard let date = dateFormatter.date(from: item) else {
            throw InitError.invalidDate(date: item, forItem: data)
        }
        return date
    }

    // TODO: refactor
    private static func bytesIn(for items: [String], in data: String) throws -> Int {
        if items.count == 2 {
            return 0
        }
        guard items.count == 4 else {
            throw InitError.invalidItemCount(expected: "4", count: items.count, forItem: data)
        }
        let item = items[2]
        if item.count == 0 {
            return 0
        }
        guard let bytes = Int(item) else {
            throw InitError.invalidBytes(bytes: item, forItem: data)
        }
        return bytes
    }

    private static func bytesOut(for items: [String], in data: String) throws -> Int {
        if items.count == 2 {
            return 0
        }
        guard items.count == 4 else {
            throw InitError.invalidItemCount(expected: "4", count: items.count, forItem: data)
        }
        let item = items[3]
        if item.count == 0 {
            return 0
        }
        guard let bytes = Int(item) else {
            throw InitError.invalidBytes(bytes: item, forItem: data)
        }
        return bytes
    }
}

// MARK: - NetworkItem utility

extension NetworkItem {
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
