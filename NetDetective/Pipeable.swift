import Foundation

// sourcery: name = Pipe
protocol Pipeable: AnyObject, Mockable {
    var fileHandleForReading: FileHandle { get }
}
extension Pipe: Pipeable {}
