import Foundation

extension String {
    // nettop
    static var validNettopInput: String { loadFile("valid-nettop-input") }
    static var invalidNettopInput: String { loadFile("invalid-nettop-input") }
    static var noBytesNettopInput: String { loadFile("no-bytes-nettop-input") }
    static var noProcessesNettopInput: String { loadFile("no-processes-nettop-input") }
    static var invalidFirstItemNettopInput: String { loadFile("invalid-first-item-nettop-input") }

    // formatter
    static var validFormatterOutput: String { loadFile("valid-formatter-output") }

    // MARK: - private

    //swiftlint:disable force_try
    private static func loadFile(_ name: String, ext: String = "txt") -> String {
        class Dummy {}
        let bundle = Bundle(for: Dummy.self)
        let url = bundle.url(forResource: name, withExtension: ext)!
        return try! String(contentsOf: url, encoding: .utf8)
    }
}

extension String {
    static func unexpectedError(_ error: Error?) -> String {
        return "received unexpected error: \(String(describing: error))"
    }

    static func unexpectedValue<T>(_ value: T) -> String {
        return "received unexpected value: \(value)"
    }
}
