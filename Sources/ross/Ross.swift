import ArgumentParser
import Foundation

@main
struct Ross: AsyncParsableCommand {

  mutating func run() async throws {
    let directoryURL = URL(fileURLWithPath: directory)
    let runner = RossRunner()
    try await runner.run(in: directoryURL)
  }

  // MARK: Internal

  @Argument(help: "The folder whose contents you want to remove comments from.")
  var directory: String
}

#if DEBUG
  extension Ross {

    init(directory: String) {
      self.directory = directory
    }
  }
#endif
