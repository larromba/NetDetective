import AppKit

extension NSImage {
    static var invalidData: NSImage { loadFile("invalid-data") }

    // MARK: - private

    private static func loadFile(_ name: String, ext: String = "png") -> NSImage {
        class Dummy {}
        let bundle = Bundle(for: Dummy.self)
        let url = bundle.url(forResource: name, withExtension: ext)!
        return NSImage(contentsOf: url)!
    }
}
