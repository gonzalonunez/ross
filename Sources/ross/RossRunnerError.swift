import Foundation

/// An error that can be thrown by the `RossRunner` class.
enum RossRunnerError: Error {

  /// Thrown if creating an enumerator for a directory fails.
  case failedToCreateEnumerator
}
