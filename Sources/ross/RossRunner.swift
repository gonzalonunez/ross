import Foundation
import SwiftParser
import SwiftSyntax

/// A class that runs Ross on Swift files in a given directory.
struct RossRunner {

  // MARK: Internal

  /// Whether or not Ross should remove plain comments.
  var shouldRemovePlainComments: Bool

  /**
   Runs Ross on Swift files in a given directory.

   - Parameter directoryURL: The URL of the directory to lint.

   - Throws: `RossRunnerError.failedToCreateEnumerator` if the file manager fails to create an enumerator.
   */
  func run(in directoryURL: URL) async throws {
    try await cleanFiles(in: directoryURL)
  }

  // MARK: Private

  private let fileManager = FileManager.default

  /**
   Cleans Swift files in a given directory.

   - Parameter directoryURL: The URL of the directory to clean.
   */
  private func cleanFiles(in directoryURL: URL) async throws {
    try await withThrowingTaskGroup(of: Void.self) { group in
      guard let enumerator = fileManager.enumerator(atPath: directoryURL.path) else {
        throw RossRunnerError.failedToCreateEnumerator
      }

      while let file = enumerator.nextObject() as? String {
        guard file.hasSuffix(".swift") else {
          continue
        }
        group.addTask {
          let fileURL = directoryURL.appendingPathComponent(file)
          try await cleanFile(at: fileURL)
        }
      }

      try await group.waitForAll()
    }
  }

  /**
   Cleans a given Swift file.

   - Parameter fileURL: The URL of the file to clean.
   */
  private func cleanFile(at fileURL: URL) async throws {
    print("᠅ Cleaning \(fileURL.lastPathComponent)...")

    let source = try String(contentsOf: fileURL, encoding: .utf8)
    let sourceFile = Parser.parse(source: source)

    let visitor = CommentRewriter(shouldRemovePlainComments: shouldRemovePlainComments)
    let newSyntax = visitor.visit(sourceFile)

    var newContent = ""
    newSyntax.write(to: &newContent)

    let replacementDirectory = try fileManager.url(
      for: .itemReplacementDirectory,
      in: .userDomainMask,
      appropriateFor: fileURL,
      create: true)

    let replacementURL = replacementDirectory.appendingPathComponent(fileURL.lastPathComponent)

    try newContent.write(
      to: replacementURL,
      atomically: true,
      encoding: .utf8)

    _ = try fileManager.replaceItemAt(fileURL, withItemAt: replacementURL)

    print("✓ Finished cleaning \(fileURL.lastPathComponent)")
  }
}
