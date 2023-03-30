import Foundation
import SwiftSyntax

/// A `SyntaxRewriter` that removes comments from `DeclModifierSyntax` and `EnumCaseDeclSyntax` nodes.
final class CommentRewriter: SyntaxRewriter {

  override func visit(_ node: DeclModifierSyntax) -> DeclModifierSyntax {
    var newNode = node
    newNode.leadingTrivia?.removeComments()
    newNode.trailingTrivia?.removeComments()
    return newNode
  }

  override func visit(_ node: EnumCaseDeclSyntax) -> DeclSyntax {
    var newNode = node
    newNode.leadingTrivia?.removeComments()
    newNode.trailingTrivia?.removeComments()
    return DeclSyntax(newNode)
  }
}

extension Trivia {

  /// Removes all comments from the trivia.
  mutating func removeComments() {
    self = .init(pieces: pieces.filter({ !$0.isComment }))
  }
}

extension TriviaPiece {

  /// Returns `true` if the trivia piece is a comment.
  var isComment: Bool {
    switch self {
    case .blockComment, .lineComment, .docBlockComment, .docLineComment:
      return true
    default:
      return false
    }
  }
}
