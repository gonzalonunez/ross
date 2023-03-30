import Foundation
import SwiftSyntax

final class CommentRewriter: SyntaxRewriter {

  override func visit(_ node: DeclModifierSyntax) -> DeclModifierSyntax {
    var newNode = node
    newNode.leadingTrivia?.removeComments()
    newNode.trailingTrivia?.removeComments()
    return newNode
  }
}

extension Trivia {

  mutating func removeComments() {
    self = .init(pieces: pieces.filter({ !$0.isComment }))
  }
}

extension TriviaPiece {

  var isComment: Bool {
    switch self {
    case .blockComment, .lineComment, .docBlockComment, .docLineComment:
      return true
    default:
      return false
    }
  }
}
