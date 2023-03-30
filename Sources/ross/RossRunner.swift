import Foundation
import SwiftParser
import SwiftSyntax

struct RossRunner {

  // MARK: Internal

  func run(in directoryURL: URL) async throws {
    try await cleanFiles(in: directoryURL)
  }

  // MARK: Private

  private let fileManager = FileManager.default

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

  private func cleanFile(at fileURL: URL) async throws {
    print("᠅ Cleaning \(fileURL.lastPathComponent)...")

    let source = try String(contentsOf: fileURL, encoding: .utf8)
    let sourceFile = Parser.parse(source: source)

    let visitor = CommentRewriter()
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
