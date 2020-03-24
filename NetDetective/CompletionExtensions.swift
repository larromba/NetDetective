import Combine
import Foundation

extension Subscribers.Completion {
    var error: Error? {
        switch self {
        case .finished:
            return nil
        case .failure(let error):
            return error
        }
    }
}
