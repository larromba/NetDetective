import Combine

extension AnyPublisher {
    static func success<T>(_ element: T) -> AnyPublisher<T, Error> {
        Future<T, Error> { promise in
            promise(.success(element))
        }.eraseToAnyPublisher()
    }

    static func failure<T>(_ error: Error) -> AnyPublisher<T, Error> {
        Future<T, Error> { promise in
            promise(.failure(error))
        }.eraseToAnyPublisher()
    }
}
