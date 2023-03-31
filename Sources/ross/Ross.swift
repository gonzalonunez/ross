import ArgumentParser
import Foundation

@main
struct Ross: AsyncParsableCommand {

  /// Runs the `Ross` command.
  mutating func run() async throws {
    let directoryURL = URL(fileURLWithPath: directory)
    let runner = RossRunner(shouldRemovePlainComments: shouldRemovePlainComments)
    try await runner.run(in: directoryURL)
  }

  // MARK: Internal

  /// The folder whose contents you want to remove comments from.
  @Argument(help: "The folder whose contents you want to remove comments from.")
  var directory: String

  /// Whether or not Ross should remove plain comments.
  @Option(name: .customLong("remove-plain"), help: "Whether or not Ross should remove plain comments.")
  var shouldRemovePlainComments: Bool = true
}

#if DEBUG
  extension Ross {

    /// Initializes a `Ross` instance with the given directory.
    init(directory: String, shouldRemovePlainComments: Bool = true) {
      self.directory = directory
      self.shouldRemovePlainComments = shouldRemovePlainComments
    }
  }
#endif
