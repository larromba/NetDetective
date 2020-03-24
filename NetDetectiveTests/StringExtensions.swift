import Foundation

extension String {
    // nettop
    static var validNettopOutput: String { loadFile("valid-nettop-output") }
    static var invalidNettopOutput: String { loadFile("invalid-nettop-output") }
    static var noBytesNettopOutput: String { loadFile("no-bytes-nettop-output") }
    static var noProcessesNettopOutput: String { loadFile("no-processes-nettop-output") }

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
