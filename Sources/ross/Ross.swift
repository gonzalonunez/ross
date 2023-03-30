import ArgumentParser
import Foundation

@main
struct Ross: AsyncParsableCommand {

  /// Runs the `Ross` command.
  mutating func run() async throws {
    let directoryURL = URL(fileURLWithPath: directory)
    let runner = RossRunner()
    try await runner.run(in: directoryURL)
  }

  // MARK: Internal

  /// The folder whose contents you want to remove comments from.
  @Argument(help: "The folder whose contents you want to remove comments from.")
  var directory: String
}

#if DEBUG
  extension Ross {

    /// Initializes a `Ross` instance with the given directory.
    init(directory: String) {
      self.directory = directory
    }
  }
#endif
