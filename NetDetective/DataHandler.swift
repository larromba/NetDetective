import Foundation
import Combine

struct DataHandler {
    enum ProcessingError: Error {
        case unexpectedFormat
    }

    static func process(string: String) -> AnyPublisher<[NetworkItem], Error> {
        do {
            var items = try string
                .split(separator: #"\#n"#)
                .dropFirst()
                .flatMap { try [NetworkItem(data: String($0))] }
            items = try buildHierachy(from: items)
                .filter { $0.bytes > 0 }
                .sorted(by: { $0.bytes > $1.bytes })
            return .success(items)
        } catch {
            return .failure(error)
        }
    }

    // MARK: - private

    private static func buildHierachy(from items: [NetworkItem]) throws -> [NetworkItem] {
        guard items.count > 0, items[0].isTopItem else {
            throw ProcessingError.unexpectedFormat
        }
        var items = items
        var hierachy = [NetworkItem]()
        while items.count > 0 {
            var topItem = items.remove(at: 0)
            topItem.subItems = items.nextSubItems()
            hierachy.append(topItem)
        }
        return hierachy
    }
}

// MARK: - NetworkItem

private extension NetworkItem {
    var isTopItem: Bool {
        return !name.contains("<->")
    }
}

// MARK: - [NetworkItem]

private extension Array where Element == NetworkItem {
    mutating func nextSubItems() -> [NetworkItem] {
        guard let nextIndex = firstIndex(where: { $0.isTopItem }) else {
            let subItems = Array(self[0..<count])
            removeSubrange(0..<count)
            return subItems
        }
        let subItems = Array(self[0..<nextIndex])
        removeSubrange(0..<nextIndex)
        return subItems
    }
}
