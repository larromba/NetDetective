import Combine
import Foundation

private var cancellable = Set<AnyCancellable>()
private let command = Command(launchPath: .nettop, arguments: ["-J", "bytes_in,bytes_out", "-L", "1"])

command.publisher
    .flatMap(DataHandler.process(string:))
    .flatMap(Formatter.format(items:))
    .sink(receiveCompletion: {
        if let error = $0.error {
            print(error.localizedDescription)
            exit(-1)
        }
    }, receiveValue: {
        print($0)
        exit(0)
    })
    .store(in: &cancellable)
command.launch()
