// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

// MARK: - Sourcery Helper

protocol _StringRawRepresentable: RawRepresentable {
    var rawValue: String { get }
}

struct _Variable<T> {
    let date = Date()
    var variable: T

    init(_ variable: T) {
        self.variable = variable
    }
}

final class _Invocation {
    let name: String
    let date = Date()
    private var parameters: [String: Any] = [:]

    init(name: String) {
        self.name = name
    }

    fileprivate func set<T: _StringRawRepresentable>(parameter: Any, forKey key: T) {
        parameters[key.rawValue] = parameter
    }
    func parameter<T: _StringRawRepresentable>(for key: T) -> Any? {
        return parameters[key.rawValue]
    }
}

final class _Actions {
  enum Keys: String, _StringRawRepresentable {
      case returnValue
      case defaultReturnValue
      case error
  }
  private var invocations: [_Invocation] = []

  // MARK: - returnValue

  func set<T: _StringRawRepresentable>(returnValue value: Any, for functionName: T) {
      let invocation = self.invocation(for: functionName)
      invocation.set(parameter: value, forKey: Keys.returnValue)
  }
  func returnValue<T: _StringRawRepresentable>(for functionName: T) -> Any? {
      let invocation = self.invocation(for: functionName)
      return invocation.parameter(for: Keys.returnValue) ?? invocation.parameter(for: Keys.defaultReturnValue)
  }

  // MARK: - defaultReturnValue

  fileprivate func set<T: _StringRawRepresentable>(defaultReturnValue value: Any, for functionName: T) {
      let invocation = self.invocation(for: functionName)
      invocation.set(parameter: value, forKey: Keys.defaultReturnValue)
  }
  fileprivate func defaultReturnValue<T: _StringRawRepresentable>(for functionName: T) -> Any? {
      let invocation = self.invocation(for: functionName)
      return invocation.parameter(for: Keys.defaultReturnValue) as? (() -> Void)
  }

  // MARK: - error

  func set<T: _StringRawRepresentable>(error: Error, for functionName: T) {
      let invocation = self.invocation(for: functionName)
      invocation.set(parameter: error, forKey: Keys.error)
  }
  func error<T: _StringRawRepresentable>(for functionName: T) -> Error? {
      let invocation = self.invocation(for: functionName)
      return invocation.parameter(for: Keys.error) as? Error
  }

  // MARK: - private

  private func invocation<T: _StringRawRepresentable>(for name: T) -> _Invocation {
      if let invocation = invocations.filter({ $0.name == name.rawValue }).first {
          return invocation
      }
      let invocation = _Invocation(name: name.rawValue)
      invocations += [invocation]
      return invocation
  }
}

final class _Invocations {
    private var history = [_Invocation]()

    fileprivate func record(_ invocation: _Invocation) {
        history += [invocation]
    }

    func isInvoked<T: _StringRawRepresentable>(_ name: T) -> Bool {
        return history.contains(where: { $0.name == name.rawValue })
    }

    func count<T: _StringRawRepresentable>(_ name: T) -> Int {
        return history.filter {  $0.name == name.rawValue }.count
    }

    func all() -> [_Invocation] {
        return history.sorted { $0.date < $1.date }
    }

    func find<T: _StringRawRepresentable>(_ name: T) -> [_Invocation] {
        return history.filter {  $0.name == name.rawValue }.sorted { $0.date < $1.date }
    }

    func reset() {
        history.removeAll()
    }
}

// MARK: - Sourcery Mocks

class MockPipe: NSObject, Pipeable {
    var fileHandleForReading: FileHandle {
        get { return _fileHandleForReading }
        set(value) { _fileHandleForReading = value; _fileHandleForReadingHistory.append(_Variable(value)) }
    }
    var _fileHandleForReading: FileHandle!
    var _fileHandleForReadingHistory: [_Variable<FileHandle?>] = []
}

class MockProcess: NSObject, Processing {
    var arguments: [String]? {
        get { return _arguments }
        set(value) { _arguments = value; _argumentsHistory.append(_Variable(value)) }
    }
    var _arguments: [String]? = []
    var _argumentsHistory: [_Variable<[String]?>] = []
    var launchPath: String? {
        get { return _launchPath }
        set(value) { _launchPath = value; _launchPathHistory.append(_Variable(value)) }
    }
    var _launchPath: String?
    var _launchPathHistory: [_Variable<String?>] = []
    var standardOutput: Any? {
        get { return _standardOutput }
        set(value) { _standardOutput = value; _standardOutputHistory.append(_Variable(value)) }
    }
    var _standardOutput: Any?
    var _standardOutputHistory: [_Variable<Any?>] = []
    let invocations = _Invocations()
    let actions = _Actions()
    static let invocations = _Invocations()
    static let actions = _Actions()

    // MARK: - launch

    func launch() {
        let functionName = launch1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
    }

    enum launch1: String, _StringRawRepresentable {
        case name = "launch1"
    }

    // MARK: - waitUntilExit

    func waitUntilExit() {
        let functionName = waitUntilExit2.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocations.record(invocation)
    }

    enum waitUntilExit2: String, _StringRawRepresentable {
        case name = "waitUntilExit2"
    }
}
