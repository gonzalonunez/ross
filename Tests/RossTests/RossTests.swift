import Foundation
import XCTest

@testable import ross

final class RossTests: XCTestCase {

  // MARK: Lifecycle

  override func setUp() async throws {
    try fileManager.createDirectory(at: examplesDirectory, withIntermediateDirectories: false)
  }

  override func tearDownWithError() throws {
    let filePath = examplesDirectory.path
    if fileManager.fileExists(atPath: filePath) {
      try fileManager.removeItem(atPath: filePath)
    }
  }

  // MARK: Internal

  func testClass() async throws {
    let fileURL = examplesDirectory.appendingPathComponent("Test.swift")

    let file = """
      //===----------------------------------------------------------------------===//
      //
      // This source file is part of the Swift.org open source project
      //
      // Copyright (c) 2014 - 2019 Apple Inc. and the Swift project authors
      // Licensed under Apache License v2.0 with Runtime Library Exception
      //
      // See https://swift.org/LICENSE.txt for license information
      // See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
      //
      //===----------------------------------------------------------------------===//
      import Foundation
      import SwiftSyntax

      /// This class takes the raw source text and scans through it searching for comments that instruct
      /// the formatter to change the status of rules for the following node. The comments may include no
      /// rule names to affect all rules, a single rule name to affect that rule, or a comma delimited
      /// list of rule names to affect a number of rules. Ignore is the only supported operation.
      public class RuleMask {
      /// Stores the source ranges in which all rules are ignored.
      private var allRulesIgnoredRanges: [SourceRange] = []

      /// Map of rule names to list ranges in the source where the rule is ignored.
      private var ruleMap: [String: [SourceRange]] = [:]

      /// Used to compute line numbers of syntax nodes.
      private let sourceLocationConverter: SourceLocationConverter
      }
      """

    XCTAssert(fileManager.createFile(atPath: fileURL.path, contents: file.data(using: .utf8)))

    var cli = Ross(directory: examplesDirectory.path)
    try await cli.run()

    let expected = #"""











      import Foundation
      import SwiftSyntax





      public class RuleMask {

      private var allRulesIgnoredRanges: [SourceRange] = []


      private var ruleMap: [String: [SourceRange]] = [:]


      private let sourceLocationConverter: SourceLocationConverter
      }
      """#

    let actual = try String(contentsOf: fileURL, encoding: .utf8)
    XCTAssertEqual(actual, expected)
  }

  func testClassPreservingPlain() async throws {
    let fileURL = examplesDirectory.appendingPathComponent("Test.swift")

    let file = """
      //===----------------------------------------------------------------------===//
      //
      // This source file is part of the Swift.org open source project
      //
      // Copyright (c) 2014 - 2019 Apple Inc. and the Swift project authors
      // Licensed under Apache License v2.0 with Runtime Library Exception
      //
      // See https://swift.org/LICENSE.txt for license information
      // See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
      //
      //===----------------------------------------------------------------------===//
      import Foundation
      import SwiftSyntax

      /// This class takes the raw source text and scans through it searching for comments that instruct
      /// the formatter to change the status of rules for the following node. The comments may include no
      /// rule names to affect all rules, a single rule name to affect that rule, or a comma delimited
      /// list of rule names to affect a number of rules. Ignore is the only supported operation.
      public class RuleMask {
      /// Stores the source ranges in which all rules are ignored.
      private var allRulesIgnoredRanges: [SourceRange] = []

      /// Map of rule names to list ranges in the source where the rule is ignored.
      private var ruleMap: [String: [SourceRange]] = [:]

      /// Used to compute line numbers of syntax nodes.
      private let sourceLocationConverter: SourceLocationConverter
      }
      """

    XCTAssert(fileManager.createFile(atPath: fileURL.path, contents: file.data(using: .utf8)))

    var cli = Ross(directory: examplesDirectory.path, shouldRemovePlainComments: false)
    try await cli.run()

    let expected = #"""
      //===----------------------------------------------------------------------===//
      //
      // This source file is part of the Swift.org open source project
      //
      // Copyright (c) 2014 - 2019 Apple Inc. and the Swift project authors
      // Licensed under Apache License v2.0 with Runtime Library Exception
      //
      // See https://swift.org/LICENSE.txt for license information
      // See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
      //
      //===----------------------------------------------------------------------===//
      import Foundation
      import SwiftSyntax





      public class RuleMask {

      private var allRulesIgnoredRanges: [SourceRange] = []


      private var ruleMap: [String: [SourceRange]] = [:]


      private let sourceLocationConverter: SourceLocationConverter
      }
      """#

    let actual = try String(contentsOf: fileURL, encoding: .utf8)
    XCTAssertEqual(actual, expected)
  }

  func testEnum() async throws {
    let fileURL = examplesDirectory.appendingPathComponent("Test.swift")

    let file = """
      /// The enablement of a lint/format rule based on the presence or absence of comment directives in
      /// the source file.
      public enum RuleState {

      /// There is no explicit information in the source file about whether the rule should be enable
      /// or disabled at the requested location, so the configuration default should be used
      case `default`

      /// The rule is explicitly disabled at the requested location.
      case disabled
      }
      """

    XCTAssert(fileManager.createFile(atPath: fileURL.path, contents: file.data(using: .utf8)))

    var cli = Ross(directory: examplesDirectory.path)
    try await cli.run()

    let expected = #"""


      public enum RuleState {



      case `default`


      case disabled
      }
      """#

    let actual = try String(contentsOf: fileURL, encoding: .utf8)
    XCTAssertEqual(actual, expected)
  }

  func testFunction() async throws {
    let fileURL = examplesDirectory.appendingPathComponent("Test.swift")

    let file = """
      /**
      Registers a handler in an `Application` for a given path.

      - Parameters:
        - app: The `Application` to register the handler in.
        - path: The path to register the handler for.
      */
      public func register(in app: Application, for path: String) {
        app.on(method, path.pathComponents) { [handle] req async throws in
          try await handle(req)
        }
      }
      """

    XCTAssert(fileManager.createFile(atPath: fileURL.path, contents: file.data(using: .utf8)))

    var cli = Ross(directory: examplesDirectory.path)
    try await cli.run()

    let expected = """

      public func register(in app: Application, for path: String) {
        app.on(method, path.pathComponents) { [handle] req async throws in
          try await handle(req)
        }
      }
      """

    let actual = try String(contentsOf: fileURL, encoding: .utf8)
    XCTAssertEqual(actual, expected)
  }

  func testInitializer() async throws {
    let fileURL = examplesDirectory.appendingPathComponent("Test.swift")

    let file = """
      class Foo {
      /// This is my initializer.
      init() { }
      }
      """

    XCTAssert(fileManager.createFile(atPath: fileURL.path, contents: file.data(using: .utf8)))

    var cli = Ross(directory: examplesDirectory.path)
    try await cli.run()

    let expected = """
      class Foo {

      init() { }
      }
      """

    let actual = try String(contentsOf: fileURL, encoding: .utf8)
    XCTAssertEqual(actual, expected)
  }

  func testPreservePlain() async throws {
    let fileURL = examplesDirectory.appendingPathComponent("Test.swift")

    let file = """
      // This is a plain comment, let us make sure it is preserved
      private let fileManager = FileManager.default
      """

    XCTAssert(fileManager.createFile(atPath: fileURL.path, contents: file.data(using: .utf8)))

    var cli = Ross(directory: examplesDirectory.path, shouldRemovePlainComments: false)
    try await cli.run()

    let expected = """
      // This is a plain comment, let us make sure it is preserved
      private let fileManager = FileManager.default
      """

    let actual = try String(contentsOf: fileURL, encoding: .utf8)
    XCTAssertEqual(actual, expected)
  }

  func testRemovePlain() async throws {
    let fileURL = examplesDirectory.appendingPathComponent("Test.swift")

    let file = """
      // This is a plain comment, let us make sure it is preserved
      private let fileManager = FileManager.default
      """

    XCTAssert(fileManager.createFile(atPath: fileURL.path, contents: file.data(using: .utf8)))

    var cli = Ross(directory: examplesDirectory.path)
    try await cli.run()

    let expected = """

      private let fileManager = FileManager.default
      """

    let actual = try String(contentsOf: fileURL, encoding: .utf8)
    XCTAssertEqual(actual, expected)
  }

  func testFreeFunction() async throws {
    let fileURL = examplesDirectory.appendingPathComponent("Test.swift")

    let file = #"""
      /// Type-checked parsing of the argument value.
      ///
      /// - Returns: Typed value of the argument converted using the `parse` function.
      ///
      /// - Throws: `ArgumentError.invalidType` when the conversion fails.
      func checked<T>(
          _ parse: (String) throws -> T?,
          _ value: String,
          argument: String? = nil
      ) throws -> T {
          if let t = try parse(value) { return t }
          var type = "\(T.self)"
          if type.starts(with: "Optional<") {
              let s = type.index(after: type.firstIndex(of: "<")!)
              let e = type.index(before: type.endIndex) // ">"
              type = String(type[s ..< e]) // strip Optional< >
          }
          throw ArgumentError.invalidType(
              value: value, type: type, argument: argument
          )
      }
      """#

    XCTAssert(fileManager.createFile(atPath: fileURL.path, contents: file.data(using: .utf8)))

    var cli = Ross(directory: examplesDirectory.path)
    try await cli.run()

    let expected = #"""





      func checked<T>(
          _ parse: (String) throws -> T?,
          _ value: String,
          argument: String? = nil
      ) throws -> T {
          if let t = try parse(value) { return t }
          var type = "\(T.self)"
          if type.starts(with: "Optional<") {
              let s = type.index(after: type.firstIndex(of: "<")!)
              let e = type.index(before: type.endIndex) // ">"
              type = String(type[s ..< e]) // strip Optional< >
          }
          throw ArgumentError.invalidType(
              value: value, type: type, argument: argument
          )
      }
      """#

    let actual = try String(contentsOf: fileURL, encoding: .utf8)
    XCTAssertEqual(actual, expected)
  }

  // MARK: Private

  private let fileManager = FileManager.default

  private var examplesDirectory: URL {
    fileManager.temporaryDirectory.appendingPathComponent("Examples")
  }
}
