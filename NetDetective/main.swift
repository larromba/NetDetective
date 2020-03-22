import Combine
import Foundation

private var cancellable = Set<AnyCancellable>()

let command = Command(launchPath: .nettop, arguments: ["-J", "bytes_in,bytes_out", "-L", "1"])
command.publisher
    .flatMap(DataHandler.process(string:))
    .flatMap(Formatter.format(items:))
    .sink(receiveCompletion: { print($0) },
          receiveValue: { print($0) } )
    .store(in: &cancellable)
command.launch()
