import Foundation

// sourcery: name = Process
protocol Processing: AnyObject, Mockable {
    func launch()
    func waitUntilExit()

    var arguments: [String]? { get set }
    var launchPath: String? { get set }
    var standardOutput: Any? { get set }
}
extension Process: Processing {}
