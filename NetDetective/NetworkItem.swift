import Foundation

struct NetworkItem {
    enum InitError: Error {
        case invalidItemCount(expected: String, count: Int, forItem: String)
        case invalidDate(date: String, forItem: String)
        case invalidBytes(bytes: String, forItem: String)
    }

    var time: Date
    var name: String
    var bytes: Int
    lazy var subItems = [NetworkItem]()

    init(data: String) throws {
        let items = data.split(separator: ",").map { String($0) }
        guard items.count >= 2 else {
            throw InitError.invalidItemCount(expected: ">=2", count: items.count, forItem: data)
        }
        time = try NetworkItem.time(for: items, in: data)
        name = String(items[1])
        bytes = try NetworkItem.bytes(for: items, in: data)
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

    private static func bytes(for items: [String], in data: String) throws -> Int {
        if items.count == 2 {
            return 0
        }
        guard items.count == 3 else {
            throw InitError.invalidItemCount(expected: "3", count: items.count, forItem: data)
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

    var bytesFormatted: String {
        return ByteCountFormatter.string(fromByteCount: Int64(bytes), countStyle: .memory)
    }
}
